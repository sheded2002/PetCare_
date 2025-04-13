import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/locale_provider.dart';
import '../services/navigation_service.dart';
import '../utils/page_transition.dart';
import '../models/favorite_animal.dart';
import 'account_screen.dart';
import 'ai_chat_screen.dart';
import 'booking_screen.dart';
import 'cat_screen.dart';
import 'dog_screen.dart';
import 'emergency_screen.dart';
import 'favorites_screen.dart';
import 'hamster_screen.dart';
import 'rabbit_screen.dart';
import 'horse_screen.dart';
import 'cow_screen.dart';
import 'sheep_screen.dart';
import 'donkey_screen.dart';

// Main home screen widget with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current selected tab index
  int _currentIndex = 2;

  // List of screens for bottom navigation
  final List<Widget> _screens = [
    const EmergencyScreen(), // Emergency services
    const AiChatScreen(), // AI chat assistant
    const HomeContent(), // Main home content
    const BookingScreen(), // Appointments
    const AccountScreen(), // User profile
  ];

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;

    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation to login
      child: Scaffold(
        body: _screens[_currentIndex],

        // Animated bottom navigation bar with custom styling
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GNav(
                // Navigation bar styling
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: const Color(0xFF6852A5),
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: const Color(0xFF6852A5).withOpacity(0.1),
                color: Colors.grey[600],

                // Navigation tabs with localized labels
                tabs: [
                  GButton(
                    icon: Icons.phone,
                    text: isArabic ? 'الطوارئ' : 'Emergency',
                  ),
                  GButton(
                    icon: Icons.chat,
                    text: isArabic ? 'دردشة الذكاء الاصطناعي' : 'AI Chat',
                  ),
                  GButton(
                    icon: Icons.home,
                    text: isArabic ? 'الرئيسية' : 'Home',
                  ),
                  GButton(
                    icon: Icons.calendar_today,
                    text: isArabic ? 'الحجوزات' : 'Bookings',
                  ),
                  GButton(
                    icon: Icons.account_circle,
                    text: isArabic ? 'الحساب' : 'Account',
                  ),
                ],
                selectedIndex: _currentIndex,
                onTabChange: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Main content of the home screen
class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Search query text controller
  final TextEditingController _searchController = TextEditingController();

  // Search query text
  String _searchQuery = '';

  // Set of favorite animals
  Set<String> _favorites = {};

  void _onFavoriteToggled(String name, String imagePath, String type) {
    _toggleFavorite(name, imagePath, type);
  }

  // Load saved favorite animals from storage
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    setState(() {
      _favorites = favoritesJson
          .map((json) => FavoriteAnimal.fromMap(jsonDecode(json)))
          .map((animal) => animal.name.toLowerCase())
          .toSet();
    });
  }

  // Toggle favorite status of an animal
  // Add or remove animal from favorites
  Future<void> _toggleFavorite(
      String name, String imagePath, String type) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    final favorites = favoritesJson
        .map((json) => FavoriteAnimal.fromMap(jsonDecode(json)))
        .toList();

    final animalName = name.toLowerCase();
    if (_favorites.contains(animalName)) {
      favorites
          .removeWhere((fav) => fav.name.toLowerCase() == animalName);
      _favorites.remove(animalName);
    } else {
      favorites.add(FavoriteAnimal(
        name: name,
        imagePath: imagePath,
        type: type,
      ));
      _favorites.add(animalName);
    }

    await prefs.setStringList(
        'favorites', favorites.map((f) => jsonEncode(f.toMap())).toList());

    setState(() {});
  }

  // Get list of animals based on current language and search query
  List<Map<String, dynamic>> _getFilteredAnimals(bool isArabic) {
    final animals = [
      {
        'title': isArabic ? 'قطط' : 'Cats',
        'image': 'images/cat_logo.jpeg',
        'screen': const CatScreen(),
      },
      {
        'title': isArabic ? 'كلاب' : 'Dogs',
        'image': 'images/dog_logo.jpeg',
        'screen': const DogScreen(),
      },
      {
        'title': isArabic ? 'أرانب' : 'Rabbits',
        'image': 'images/rabbit_logo.jpeg',
        'screen': const RabbitScreen(),
      },
      {
        'title': isArabic ? 'هامستر' : 'Hamsters',
        'image': 'images/hamster_logo.jpeg',
        'screen': const HamsterScreen(),
      },
      {
        'title': isArabic ? 'خيول' : 'Horses',
        'image': 'images/horse_logo.jpeg',
        'screen': const HorseScreen(),
      },
      {
        'title': isArabic ? 'أبقار' : 'Cows',
        'image': 'images/cow_logo.jpeg',
        'screen': const CowScreen(),
      },
      {
        'title': isArabic ? 'أغنام' : 'Sheep',
        'image': 'images/sheep_logo.jpeg',
        'screen': const SheepScreen(),
      },
      {
        'title': isArabic ? 'حمير' : 'Donkeys',
        'image': 'images/donkey_logo.jpeg',
        'screen': const DonkeyScreen(),
      },
    ];

    if (_searchQuery.isEmpty) {
      return animals;
    }

    return animals
        .where((animal) => animal['title']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.isArabic;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6852A5),
        automaticallyImplyLeading: false,
        title: Text(
          isArabic ? 'عيادة الحيوانات الأليفة' : 'Pet Care Clinic',
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            color: Colors.white,
            onPressed: () => NavigationService.navigateTo(
              FavoritesScreen(
                onFavoriteToggled: _onFavoriteToggled,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText:
                    isArabic ? 'ابحث عن حيوان...' : 'Search for an animal...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0B0FF)),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _getFilteredAnimals(isArabic).length,
              itemBuilder: (context, index) {
                final animal = _getFilteredAnimals(isArabic)[index];
                final isFavorite =
                    _favorites.contains(animal['title'].toLowerCase());

                // Animal card with image and favorite button
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      NavigationService.navigateTo(
                        animal['screen'],
                        transitionType: PageTransitionType.scale,
                      );
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Animal image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Image.asset(
                            animal['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Favorite button
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(0.25),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    isFavorite ? Colors.red : Colors.deepPurple,
                                size: 15,
                              ),
                              onPressed: () => _toggleFavorite(
                                animal['title'],
                                animal['image'],
                                'animal',
                              ),
                            ),
                          ),
                        ),
                        // Animal title
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              animal['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
