import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../providers/locale_provider.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      // Implement password reset logic
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
          isArabic ? 'نسيت كلمة المرور' : 'Forgot Password',
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
              Text(
                isArabic
                    ? 'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور'
                    : 'Enter your email to reset your password',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mauve,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isArabic ? 'إرسال رابط إعادة التعيين' : 'Send Reset Link',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  isArabic ? 'العودة إلى تسجيل الدخول' : 'Back to Login',
                  style: const TextStyle(color: AppColors.mauve),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
