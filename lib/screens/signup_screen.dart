import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../providers/locale_provider.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      // Implement signup logic
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
          isArabic ? 'إنشاء حساب' : 'Sign Up',
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
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'الاسم' : 'Name',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isArabic
                        ? 'الرجاء إدخال الاسم'
                        : 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText:
                      isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.black54),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isArabic
                        ? 'الرجاء تأكيد كلمة المرور'
                        : 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return isArabic
                        ? 'كلمة المرور غير متطابقة'
                        : 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mauve,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isArabic ? 'إنشاء حساب' : 'Sign Up',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isArabic
                        ? 'لديك حساب بالفعل؟'
                        : 'Already have an account? ',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      isArabic ? 'تسجيل الدخول' : 'Login',
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
