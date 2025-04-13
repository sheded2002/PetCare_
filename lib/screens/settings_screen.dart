import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6852A5),
        title: Text(
          isArabic ? ' الاعدادات' : 'Setiings',
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            isArabic ? 'العامة' : 'General',
            [
              SwitchListTile(
                title: Text(
                  isArabic ? 'الإشعارات' : 'Notifications',
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  isArabic
                      ? 'تلقي إشعارات التطبيق'
                      : 'Receive app notifications',
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: const Color(0xFF6852A5),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            isArabic ? 'اللغة' : 'sdfsdffds',
            [
              ListTile(
                title: Text(
                  isArabic ? 'اللغة' : 'Language',
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  isArabic ? 'العربية' : 'English',
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
                trailing: const Icon(Icons.language, color: Colors.black),
                onTap: () {
                  localeProvider.toggleLocale();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ), */
        Card(
          color: Colors.white.withOpacity(0.9),
          // margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
