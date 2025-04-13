import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/animal_data.dart';
import '../providers/locale_provider.dart';
import 'animal_info_screen.dart';

class DonkeyScreen extends StatelessWidget {
  const DonkeyScreen({super.key});

  List<String> _getInformation(String category) {
    final data = AnimalData.animalInfo['Donkey']?[category];
    if (data == null) return [];

    return data
        .map((item) => '${item['title']}\n${item['description']}')
        .toList();
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
          colors: [Color(0xFF030416), Color.fromARGB(255, 249, 249, 250)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            isArabic ? 'الحمير' : 'Donkeys',
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
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
                backgroundImage: AssetImage('images/donkey_logo.jpeg'),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic ? 'الحمير' : 'Donkeys',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'الحمير حيوانات قوية وذكية، تستخدم في النقل والزراعة.'
                    : 'Donkeys are strong and intelligent animals used for transportation and farming.',
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
                      animalName: 'Donkey',
                      information: _getInformation('Lifespan'),
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
                      animalName: 'Donkey',
                      information: _getInformation('Food'),
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
                      animalName: 'Donkey',
                      information: _getInformation('Diseases'),
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
                      animalName: 'Donkey',
                      information: _getInformation('Vaccination'),
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
