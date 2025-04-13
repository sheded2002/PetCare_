import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/animal_data.dart';
import '../data/animal_data_ar.dart';
import '../providers/locale_provider.dart';
import 'animal_info_screen.dart';

class RabbitScreen extends StatelessWidget {
  const RabbitScreen({super.key});

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
          colors: [Color(0xFF030416), Color.fromARGB(255, 250, 250, 252)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            isArabic ? 'الأرانب' : 'Rabbits',
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
                backgroundImage: AssetImage('images/rabbit_logo.jpeg'),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic ? 'الأرانب' : 'Rabbits',
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'الأرانب حيوانات أليفة لطيفة ومحبوبة، معروفة بفرائها الناعم وآذانها الطويلة.'
                    : 'Rabbits are gentle and beloved pets, known for their soft fur and long ears.',
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
                      animalName: 'Rabbit',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Rabbit',
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
                      animalName: 'Rabbit',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Rabbit',
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
                      animalName: 'Rabbit',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Rabbit',
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
                      animalName: 'Rabbit',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Rabbit',
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
