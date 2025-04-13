import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/favorite_animal.dart';
import '../services/navigation_service.dart';
import 'cat_screen.dart';
import 'dog_screen.dart';
import 'cow_screen.dart';
import 'sheep_screen.dart';
import 'horse_screen.dart';
import 'donkey_screen.dart';
import 'hamster_screen.dart';
import 'rabbit_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final Function(String, String, String)? onFavoriteToggled;
  
  const FavoritesScreen({
    Key? key,
    this.onFavoriteToggled,
  }) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FavoriteAnimal> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    setState(() {
      favorites = favoritesJson
          .map((json) => FavoriteAnimal.fromMap(jsonDecode(json)))
          .toList();
    });
  }

  Future<void> _removeFavorite(FavoriteAnimal animal) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites.removeWhere((fav) =>
          fav.name == animal.name &&
          fav.imagePath == animal.imagePath &&
          fav.type == animal.type);
    });
    final favoritesJson =
        favorites.map((fav) => jsonEncode(fav.toMap())).toList();
    await prefs.setStringList('favorites', favoritesJson);
    
    // Notify home screen about the change
    if (widget.onFavoriteToggled != null) {
      widget.onFavoriteToggled!(animal.name, animal.imagePath, animal.type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationService.goBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Favorites',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => NavigationService.goBack(),
          ),
        ),
        body: favorites.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final animal = favorites[index];
                  return Hero(
                    tag: 'favorite_${animal.name}',
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          final animalName = animal.name.toLowerCase();
                          
                          if (animalName == 'cats'|| animalName == 'قطط') {
                            NavigationService.navigateTo(const CatScreen());
                          } else if (animalName == 'dogs'|| animalName == 'كلاب') {
                            NavigationService.navigateTo(const DogScreen());
                          } else if (animalName == 'cows'|| animalName == 'أبقار') {
                            NavigationService.navigateTo(const CowScreen());
                          } else if (animalName == 'sheep'|| animalName == 'أغنام') {
                            NavigationService.navigateTo(const SheepScreen());
                          } else if (animalName == 'horses'|| animalName == 'خيول') {
                            NavigationService.navigateTo(const HorseScreen());
                          } else if (animalName == 'donkeys'|| animalName == 'حمير') {
                            NavigationService.navigateTo(const DonkeyScreen());
                          } else if (animalName == 'hamsters'|| animalName == 'هامستر') {
                            NavigationService.navigateTo(const HamsterScreen());
                          } else if (animalName == 'rabbits'|| animalName == 'أرانب') {
                            NavigationService.navigateTo(const RabbitScreen());
                          }
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                animal.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  onPressed: () => _removeFavorite(animal),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
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
                                  animal.name,
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
                    ),
                  );
                },
              ),
      ),
    );
  }
}
