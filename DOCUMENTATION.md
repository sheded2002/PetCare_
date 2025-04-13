# Pet Care App Documentation

## Overview
The Pet Care App is a comprehensive Flutter application for managing pet care services, including bookings, emergency services, and AI chat assistance. The app supports both English and Arabic languages and features a modern, animated UI.

## Database Structure

### Database Implementation (`DatabaseHelper`)
The app uses SQLite database through the `sqflite` package with support for both mobile and web platforms.

#### Tables

1. **Users Table**
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  name TEXT NOT NULL,
  is_doctor BOOLEAN DEFAULT 0
)
```

2. **Bookings Table**
```sql
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
```

### Key Database Operations

#### User Management
- `insertUser`: Creates new user accounts with email validation and user type (regular user/doctor)
- `getUser`: Authenticates users during login
- `getCurrentUser`: Retrieves currently logged-in user
- `checkEmailExists`: Validates email uniqueness
- `updatePassword`: Handles password reset functionality

#### Booking Management
- `insertBooking`: Creates new pet care appointments
- `getUserBookings`: Retrieves user's appointments
- `updateBooking`: Modifies existing appointments
- `deleteBooking`: Cancels appointments

## App Structure

### Main Components

1. **Navigation System**
- Animated bottom navigation bar with 5 main sections:
  - Emergency Services
  - AI Chat
  - Home
  - Bookings
  - Account
- Smooth page transitions using custom animations

2. **Home Screen (`HomeScreen`)**
- Grid layout displaying different animal categories
- Favorite system for quick access
- Animated UI elements
- Bilingual support (English/Arabic)

3. **Booking System (`BookingScreen`)**
- Appointment scheduling
- Date and time selection
- Animal type and age input
- Notes and additional information
- Status tracking (pending, confirmed, etc.)

### Doctor Authentication System

The app implements a dual-role authentication system that distinguishes between regular users and veterinary doctors:

1. **Signup Process**
- During signup, users can select "I am a doctor" checkbox
- Doctor accounts get additional privileges and access to doctor-specific screens
- The checkbox toggles the user type in the database

2. **Doctor-Specific Features**
- Custom dashboard for managing appointments
- Access to patient history
- Ability to accept/reject bookings
- Professional profile management

3. **Navigation Flow**
- Regular users are directed to the main user interface
- Doctors are redirected to the doctor dashboard after login
- Different bottom navigation options based on user type

### UI/UX Features

1. **Animations**
- Page transitions with zoom effect on Android
- Native Cupertino transitions on iOS
- Bottom navigation bar animations:
  - 400ms duration for smooth transitions
  - Tab background color animations
  - Ripple effects on tap
  - Icon-text gap animation

2. **Theme**
- Primary color: `Color(0xFF6852A5)` (Purple)
- Custom app bar styling
- Consistent shadow effects
- Responsive layout design

## Code Organization

### Key Files and Their Purposes

1. **`main.dart`**
```dart
// Entry point of the application
// Handles:
// - App initialization
// - Theme setup
// - Navigation configuration
// - Localization setup
```

2. **`home_screen.dart`**
```dart
// Main dashboard implementation
// Features:
// - Animated bottom navigation
// - Grid view of animal categories
// - Favorites system
// - Localization support
```

3. **`database_helper.dart`**
```dart
// Database management singleton
// Responsibilities:
// - Database initialization
// - CRUD operations
// - User authentication
// - Booking management
```

## Best Practices Implemented

1. **Database Management**
- Singleton pattern for database instance
- Error handling and logging
- Version management for schema updates
- Foreign key constraints

2. **State Management**
- Provider pattern for localization
- Efficient state updates
- Persistent storage using SharedPreferences

3. **UI/UX**
- Responsive layouts
- Consistent animations
- Error feedback
- Loading states

## Code Comments Guide

### Database Operations
```dart
// Initialize database with platform-specific settings
void _initPlatformSpecific() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
}

// Create tables with proper constraints and relationships
Future<void> _onCreate(Database db, int version) async {
  // Table creation with foreign key support
}

// Handle database upgrades and schema changes
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  // Version-specific migrations
}
```

### UI Components
```dart
// Bottom Navigation Bar with animations
bottomNavigationBar: Container(
  // Custom decoration for depth effect
  decoration: BoxDecoration(/* ... */),
  
  child: GNav(
    // Animation configuration
    duration: Duration(milliseconds: 400),
    // Tab styling and behavior
    tabBackgroundColor: Color(0xFF6852A5).withOpacity(0.1),
  )
)
```

## Security Considerations

1. **User Authentication**
- Password hashing (recommended implementation)
- Session management using SharedPreferences
- Email validation

2. **Data Protection**
- SQL injection prevention using parameterized queries
- Error handling to prevent data leaks
- Proper logout cleanup

## Future Enhancements

1. **Database**
- Add backup functionality
- Implement caching layer
- Add more complex queries for analytics

2. **UI/UX**
- Add more custom animations
- Implement dark mode
- Enhance accessibility features

3. **Features**
- Add push notifications
- Implement payment integration
- Add pet health tracking
