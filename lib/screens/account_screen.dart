import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Map<String, dynamic>? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _databaseHelper.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await _databaseHelper.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6852A5),
        title: Text(
          isArabic ? 'الحساب' : 'Account',
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_currentUser != null) ...[
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                child: Text(
                  _currentUser!['name'][0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 32,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _currentUser!['name'],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                _currentUser!['email'],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),
            ],
            _buildMenuButton(
              isArabic ? 'الملف الشخصي' : 'Profile',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              isArabic ? 'الإعدادات' : 'Settings',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              isArabic ? 'حول التطبيق' : 'About',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuButton(
              isArabic ? 'تسجيل الخروج' : 'Logout',
              () => _logout(context),
              isLogoutButton: true, // علامة لتمييز زر تسجيل الخروج
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String title, VoidCallback onPressed,
      {bool isLogoutButton = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLogoutButton
              ? Colors.red
              : AppTheme.primaryColor, // تغيير لون الخلفية لزر تسجيل الخروج
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
