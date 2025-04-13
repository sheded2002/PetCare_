import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/animal_data.dart';
import '../data/animal_data_ar.dart';
import '../providers/locale_provider.dart';
import 'animal_info_screen.dart';

class CowScreen extends StatelessWidget {
  const CowScreen({super.key});

  List<String> _getInformation(
      Map<String, dynamic> data, String animal, String category) {
    final List<Object>? list = data[animal]?[category] as List<Object>?;
    return list?.map((item) => item.toString()).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF030416), Color.fromARGB(255, 255, 255, 255)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(isArabic ? 'الأبقار' : 'Cows'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('images/cow_logo.jpeg'),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic ? 'الأبقار' : 'Cows',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'الأبقار حيوانات مهمة في الزراعة وإنتاج الحليب واللحوم.'
                    : 'Cows are important farm animals for milk and meat production.',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildMenuButton(
                isArabic ? 'العمر' : 'Lifespan',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimalInfoScreen(
                      title: 'Lifespan',
                      animalName: 'Cow',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Cow',
                        'Lifespan',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                isArabic ? 'الغذاء' : 'Food',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimalInfoScreen(
                      title: 'Food',
                      animalName: 'Cow',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Cow',
                        'Food',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                isArabic ? 'الأمراض' : 'Diseases',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimalInfoScreen(
                      title: 'Diseases',
                      animalName: 'Cow',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Cow',
                        'Diseases',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                isArabic ? 'التطعيمات' : 'Vaccination',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimalInfoScreen(
                      title: 'Vaccination',
                      animalName: 'Cow',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Cow',
                        'Vaccination',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String title, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6852A5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
