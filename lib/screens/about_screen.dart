import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFF6852A5),
          elevation: 0,
          title: Text(
            isArabic ? 'حول التطبيق' : 'About',
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50,
                  backgroundImage:
                      AssetImage('images/CS_25_design.jpeg')),
              const SizedBox(height: 24),
              Text(
                isArabic ? 'عيادة الحيوانات الأليفة' : 'Pet Care Clinic',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              _buildInfoSection(
                isArabic ? 'نبذة عنا' : 'About Us',
                isArabic
                    ? 'نحن نقدم خدمات رعاية متكاملة للحيوانات الأليفة، مع التركيز على صحة ورفاهية حيواناتكم المحببة.'
                    : 'We provide comprehensive pet care services with a focus on the health and well-being of your beloved animals.',
              ),
              const SizedBox(height: 24),
              _buildInfoSection(
                isArabic ? 'خدماتنا' : 'Our Services',
                isArabic
                    ? '• فحوصات طبية شاملة\n• رعاية طارئة على مدار الساعة\n• استشارات تغذية\n• تطعيمات\n• علاج الأمراض'
                    : '• Comprehensive medical examinations\n• 24/7 emergency care\n• Nutrition consultations\n• Vaccinations\n• Disease treatment',
              ),
              const SizedBox(height: 24),
              _buildInfoSection(
                isArabic ? 'تواصل معنا' : 'Contact Us',
                isArabic
                    ? 'الهاتف: 123-456-789\nالبريد الإلكتروني: info@petcare.com'
                    : 'Phone: 123-456-789\nEmail: info@petcare.com',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: Colors.black.withOpacity(0.7),
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
