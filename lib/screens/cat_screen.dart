import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/animal_data.dart';
import '../data/animal_data_ar.dart';
import '../providers/locale_provider.dart';
import 'animal_info_screen.dart';

class CatScreen extends StatelessWidget {
  const CatScreen({super.key});

  List<String> _getInformation(
      Map<String, dynamic> data, String animal, String category) {
    final List<Object>? list = data[animal]?[category] as List<Object>?;
    return list?.map((item) => item.toString()).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;

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
          isArabic ? 'القطط' : 'Cats',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('images/cat_logo.jpeg'),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic ? 'القطط' : 'Cats',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'القطط حيوانات أليفة مستقلة ومحبوبة، تتميز بمهاراتها في الصيد ونظافتها.'
                    : 'Cats are beloved independent pets, known for their hunting skills and cleanliness.',
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
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AnimalInfoScreen(
                      title: 'Lifespan',
                      animalName: 'Cat',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Cat',
                        'Lifespan',
                      ),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                isArabic ? 'الغذاء' : 'Food',
                () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AnimalInfoScreen(
                      title: 'Food',
                      animalName: 'Cat',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Cat',
                        'Food',
                      ),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                isArabic ? 'الأمراض' : 'Diseases',
                () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AnimalInfoScreen(
                      title: 'Diseases',
                      animalName: 'Cat',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Cat',
                        'Diseases',
                      ),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                isArabic ? 'التطعيمات' : 'Vaccination',
                () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AnimalInfoScreen(
                      title: 'Vaccination',
                      animalName: 'Cat',
                      information: _getInformation(
                        isArabic
                            ? AnimalDataAr.animalInfo
                            : AnimalData.animalInfo,
                        'Cat',
                        'Vaccination',
                      ),
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
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
          backgroundColor: const Color(0xFF6852A5), // Mauve color
          elevation: 2,
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
