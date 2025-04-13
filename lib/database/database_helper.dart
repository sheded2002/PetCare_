import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

// DatabaseHelper: A singleton class that manages all database operations
// Uses SQLite for mobile and web platforms through sqflite
class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Factory constructor to return the singleton instance
  factory DatabaseHelper() => _instance;

  // Private constructor for singleton pattern
  DatabaseHelper._internal() {
    _initPlatformSpecific();
  }

  // Initialize database factory based on platform (web/mobile)
  void _initPlatformSpecific() {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
  }

  // Get the database instance, creating it if needed
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database with tables and configuration
  Future<Database> _initDatabase() async {
    if (!kIsWeb) {
      WidgetsFlutterBinding.ensureInitialized();
    }
    
    String path = join(await getDatabasesPath(), 'petcare.db');
    
    return await openDatabase(
      path,
      version: 4,  // Increment version to trigger upgrade
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create initial database tables
  // - users: Stores user account information
  // - bookings: Stores appointment information with foreign key to users
  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'user'
      )
    ''');

    // Create bookings table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        animal_type TEXT NOT NULL,
        animal_age INTEGER NOT NULL,
        notes TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }

  // Handle database schema upgrades between versions
  // - Version 2: Recreated bookings table
  // - Version 3: Added status column to bookings
  // - Version 4: Added role column to users table
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS bookings');
      await db.execute('''
        CREATE TABLE bookings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          date TEXT NOT NULL,
          time TEXT NOT NULL,
          animal_type TEXT NOT NULL,
          animal_age INTEGER NOT NULL,
          notes TEXT,
          status TEXT NOT NULL DEFAULT 'pending',
          FOREIGN KEY (user_id) REFERENCES users (id)
        )
      ''');
    }
    if (oldVersion < 3) {
      // Add status column if it doesn't exist
      try {
        await db.execute('ALTER TABLE bookings ADD COLUMN status TEXT NOT NULL DEFAULT "pending"');
      } catch (e) {
        print('Status column might already exist: $e');
      }
    }
    if (oldVersion < 4) {
      // Add role column to users table
      try {
        await db.execute('ALTER TABLE users ADD COLUMN role TEXT NOT NULL DEFAULT "user"');
      } catch (e) {
        print('Role column might already exist: $e');
      }
    }
  }

  // USER MANAGEMENT METHODS

  // Create a new user account
  // Throws exception if email already exists
  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      return await db.insert(
        'users',
        user,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      print('Error inserting user: $e');
      throw Exception('Failed to create account. Email might already exist.');
    }
  }

  // Authenticate user and store their ID in SharedPreferences
  // Returns user data if credentials are valid, null otherwise
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (results.isNotEmpty) {
        // Store user ID in SharedPreferences when user logs in
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', results.first['id'] as int);
        return results.first;
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Get currently logged-in user's data
  // Uses stored user ID from SharedPreferences
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final userId = await getCurrentUserId();
      if (userId == null) return null;

      final db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (results.isNotEmpty) {
        return results.first;
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Get ID of currently logged-in user from SharedPreferences
  Future<int?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('userId');
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }

  // BOOKING MANAGEMENT METHODS

  // Create a new booking appointment
  // Required fields: user_id, date, time, animal_type, animal_age
  Future<int> insertBooking(Map<String, dynamic> booking) async {
    try {
      final db = await database;
      return await db.insert('bookings', booking);
    } catch (e) {
      print('Error inserting booking: $e');
      throw Exception('Failed to create booking.');
    }
  }

  // Get all bookings for a specific user
  // Sorted by date and time in ascending order
  Future<List<Map<String, dynamic>>> getUserBookings(int userId) async {
    try {
      final db = await database;
      return await db.query(
        'bookings',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date ASC, time ASC',
      );
    } catch (e) {
      print('Error getting bookings: $e');
      throw Exception('Failed to get bookings.');
    }
  }

  // Get user's bookings sorted by most recent first
  Future<List<Map<String, dynamic>>> getBookingsByUserId(int userId) async {
    try {
      final db = await database;
      return await db.query(
        'bookings',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC, time DESC',
      );
    } catch (e) {
      print('Error getting bookings: $e');
      return [];
    }
  }

  // Get all bookings
  Future<List<Map<String, dynamic>>> getAllBookings() async {
    final db = await database;
    return await db.query(
      'bookings',
      orderBy: 'date DESC, time DESC',
    );
  }

  // Update an existing booking
  // booking map must contain the booking 'id'
  Future<int> updateBooking(Map<String, dynamic> booking) async {
    try {
      final db = await database;
      return await db.update(
        'bookings',
        booking,
        where: 'id = ?',
        whereArgs: [booking['id']],
      );
    } catch (e) {
      print('Error updating booking: $e');
      throw Exception('Failed to update booking.');
    }
  }

  // Delete a booking by its ID
  Future<int> deleteBooking(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'bookings',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting booking: $e');
      throw Exception('Failed to delete booking.');
    }
  }

  // SESSION MANAGEMENT METHODS

  // Clear user session data on logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Alternative method for signing out
  // Clears user session data
  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  // UTILITY METHODS

  // Check if an email is already registered
  // Returns true if email exists in database
  Future<bool> checkEmailExists(String email) async {
    try {
      final db = await database;
      var results = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      return results.isNotEmpty;
    } catch (e) {
      print('Error checking email: $e');
      throw Exception('Failed to check email existence.');
    }
  }

  // Update user's password
  // Throws exception if update fails
  Future<void> updatePassword(String email, String newPassword) async {
    try {
      final db = await database;
      await db.update(
        'users',
        {'password': newPassword},
        where: 'email = ?',
        whereArgs: [email],
      );
    } catch (e) {
      print('Error updating password: $e');
      throw Exception('Failed to update password.');
    }
  }

  // DOCTOR SPECIFIC METHODS

  // Get all bookings for today
  Future<List<Map<String, dynamic>>> getTodayBookings() async {
    try {
      final db = await database;
      final now = DateTime.now();
      final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      
      print('Fetching bookings for date: $today'); // Debug print
      
      // First try with the formatted date
      var bookings = await db.query(
        'bookings',
        where: 'date = ?',
        whereArgs: [today],
        orderBy: 'time ASC',
      );
      
      // If no bookings found, try with ISO8601 format
      if (bookings.isEmpty) {
        final isoToday = now.toIso8601String().split('T')[0];
        print('Trying with ISO format: $isoToday'); // Debug print
        
        bookings = await db.query(
          'bookings',
          where: 'date LIKE ?',
          whereArgs: ['$isoToday%'],
          orderBy: 'time ASC',
        );
      }
      
      print('Found ${bookings.length} bookings for today'); // Debug print
      return bookings;
    } catch (e) {
      print('Error getting today\'s bookings: $e');
      return [];
    }
  }

  // Update booking status (pending, done, cancelled)
  Future<int> updateBookingStatus(int bookingId, String status) async {
    try {
      final db = await database;
      
      // If status is cancelled, delete the booking instead of updating it
      if (status.toLowerCase() == 'cancelled') {
        return await db.delete(
          'bookings',
          where: 'id = ?',
          whereArgs: [bookingId],
        );
      }
      
      // For other statuses, update the booking
      return await db.update(
        'bookings',
        {'status': status},
        where: 'id = ?',
        whereArgs: [bookingId],
      );
    } catch (e) {
      print('Error updating booking status: $e');
      throw Exception('Failed to update booking status.');
    }
  }

  // Get all bookings with user information
  Future<List<Map<String, dynamic>>> getAllBookingsWithUsers() async {
    try {
      final db = await database;
      return await db.rawQuery('''
        SELECT bookings.*, users.name as user_name, users.email as user_email
        FROM bookings
        JOIN users ON bookings.user_id = users.id
        ORDER BY bookings.date DESC, bookings.time DESC
      ''');
    } catch (e) {
      print('Error getting bookings with users: $e');
      return [];
    }
  }
}
