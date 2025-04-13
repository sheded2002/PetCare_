import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Implement login logic
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleProvider>().isArabic;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mauve,
        elevation: 0,
        title: Text(
          isArabic ? 'تسجيل الدخول' : 'Login',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'البريد الإلكتروني' : 'Email',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isArabic
                        ? 'الرجاء إدخال البريد الإلكتروني'
                        : 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: isArabic ? 'كلمة المرور' : 'Password',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isArabic
                        ? 'الرجاء إدخال كلمة المرور'
                        : 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mauve,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isArabic ? 'تسجيل الدخول' : 'Login',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to forgot password screen
                },
                child: Text(
                  isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                  style: const TextStyle(color: AppColors.mauve),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isArabic ? 'ليس لديك حساب؟' : "Don't have an account? ",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to signup screen
                    },
                    child: Text(
                      isArabic ? 'سجل الآن' : 'Sign Up',
                      style: const TextStyle(color: AppColors.mauve),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
