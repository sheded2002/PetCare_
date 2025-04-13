import 'package:flutter/material.dart';
import 'package:pet_care/data/animal_data.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../data/animal_data_ar.dart';

class AnimalInfoScreen extends StatelessWidget {
  final String title;
  final String animalName;
  final List<String> information;

  const AnimalInfoScreen({
    Key? key,
    required this.title,
    required this.animalName,
    required this.information,
  }) : super(key: key);

  List<String> _formatArabicInfo(List<dynamic> arabicInfo) {
    return arabicInfo
        .map((item) => item is Map<String, dynamic>
            ? '${item['title']}\n${item['description']}'
            : item.toString())
        .toList();
  }

  List<String> _formatEnglishInfo(List<dynamic> englishInfo) {
    return englishInfo
        .map((item) => item is Map<String, dynamic>
            ? '${item['title']}\n${item['description']}'
            : item.toString())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;

    // Get the appropriate information based on language
    final List<String> displayInfo = isArabic
        ? _formatArabicInfo(AnimalDataAr.animalInfo[animalName]?[title] ?? [])
        // : information;
        : _formatEnglishInfo(AnimalData.animalInfo[animalName]?[title] ?? []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isArabic ? _getArabicTitle(title) : title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: displayInfo.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF6852A5),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                displayInfo[index],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          );
        },
      ),
    );
  }

  String _getArabicTitle(String title) {
    switch (title) {
      case 'Lifespan':
        return 'العمر';
      case 'Food':
        return 'الغذاء';
      case 'Diseases':
        return 'الأمراض';
      case 'Vaccination':
        return 'التطعيمات';
      default:
        return title;
    }
  }
}
