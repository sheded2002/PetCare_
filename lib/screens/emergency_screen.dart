import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'لا يمكن فتح الرابط: $url';
    }
  }

  final List<Map<String, String>> clinics = [
    {
      "name": "المستشفى البيطري الدولي",
      "location": "القاهرة، مصر",
      "url":
          "https://www.google.com/maps/search/%D8%A7%D9%84%D9%85%D8%B3%D8%AA%D8%B4%D9%81%D9%89+%D8%A7%D9%84%D8%A8%D9%8A%D8%B7%D8%B1%D9%8A+%D8%A7%D9%84%D8%AF%D9%88%D9%84%D9%8A%2C+%D8%A7%D9%84%D9%82%D8%A7%D9%87%D8%B1%D8%A9%D8%8C+%D9%85%D8%B5%D8%B1",
    },
    {
      "name": "عيادة كاتس آند دوجز البيطرية",
      "location": "القاهرة، مصر",
      "url":
          "https://www.google.com/maps/search/%D8%B9%D9%8A%D8%A7%D8%AF%D8%A9+%D9%83%D8%A7%D8%AA%D8%B3+%D8%A2%D9%86%D8%AF+%D8%AF%D9%88%D8%AC%D8%B2+%D8%A7%D9%84%D8%A8%D9%8A%D8%B7%D8%B1%D9%8A%D8%A9,+%D8%A7%D9%84%D9%82%D8%A7%D9%87%D8%B1%D8%A9%D8%8C+%D9%85%D8%B5%D8%B1%E2%80%AD/@30.1266936,31.4908959,12z/data=!3m1!4b1?entry=ttu&g_ep=EgoyMDI1MDMxMi4wIKXMDSoASAFQAw%3D%3D",
    },
    {
      "name": "بيت بالانس",
      "location": "القاهرة، مصر",
      "url":
          "https://www.google.com/maps/search/%D8%A8%D8%AA+%D8%A8%D8%A7%D9%84%D8%A7%D8%B3%2C+%D8%A7%D9%84%D9%82%D8%A7%D9%87%D8%B1%D8%A9%D8%8C+%D9%85%D8%B5%D8%B1",
    },
    {
      "name": "ألفا فيت",
      "location": "القاهرة، مصر",
      "url":
          "https://www.google.com/maps/search/%D8%A3%D9%84%D9%81%D8%A7+%D9%81%D9%8A%D8%AA%2C+%D8%A7%D9%84%D9%82%D8%A7%D9%87%D8%B1%D8%A9%D8%8C+%D9%85%D8%B5%D8%B1",
    },
    {
      "name": "هابي بيتس",
      "location": "الجيزة، مصر",
      "url":
          "https://www.google.com/maps/search/%D9%87%D8%A7%D8%A8%D9%8A+%D8%A8%D9%8A%D8%AA%D8%B3,+%D8%A7%D9%84%D8%AC%D9%8A%D8%B2%D8%A9%D8%8C+%D9%85%D8%B5%D8%B1%E2%80%AD/@30.0176139,31.130253,11z/data=!3m1!4b1?entry=ttu&g_ep=EgoyMDI1MDMxMi4wIKXMDSoASAFQAw%3D%3D",
    },
    {
      "name": "Pet Familia العيادة البيطرية",
      "location": "القاهرة، مصر",
      "url":
          "https://www.google.com/maps/search/Pet+Familia+%D8%A7%D9%84%D8%B9%D9%8A%D8%A7%D8%AF%D8%A9+%D8%A7%D9%84%D8%A8%D9%8A%D8%B7%D8%B1%D9%8A%D8%A9%2C+%D8%A7%D9%84%D9%82%D8%A7%D9%87%D8%B1%D8%A9%D8%8C+%D9%85%D8%B5%D8%B1",
    },
    {
      "name": "The Veterinary Center عيادة بيطرية متكاملة",
      "location": "القاهرة، مصر",
      "url":
          "https://www.google.com/maps/search/The+Veterinary+Center+%D8%B9%D9%8A%D8%A7%D8%AF%D8%A9+%D8%A8%D9%8A%D8%B7%D8%B1%D9%8A%D8%A9+%D9%85%D8%AA%D9%83%D8%A7%D9%85%D9%84%D8%A9%2C+%D8%A7%D9%84%D9%82%D8%A7%D9%87%D8%B1%D8%A9%D8%8C+%D9%85%D8%B5%D8%B1",
    },
    {
      "name": "عيادة نيويورك البيطرية",
      "location": "القاهرة، مصر",
      "url":
          "https://www.google.com/maps/search/%D8%B9%D9%8A%D8%A7%D8%AF%D8%A9+%D9%86%D9%8A%D9%88%D9%8A%D9%88%D8%B1%D9%83+%D8%A7%D9%84%D8%A8%D9%8A%D8%B7%D8%B1%D9%8A%D8%A9%2C+%D8%A7%D9%84%D9%82%D8%A7%D9%87%D8%B1%D8%A9%D8%8C+%D9%85%D8%B5%D8%B1",
    },
    {
      "name": "عيادة الهرم البيطرية",
      "location": "الجيزة، مصر",
      "url":
          "https://www.google.com/maps/place/%D8%B9%D9%8A%D8%A7%D8%AF%D8%A9+%D8%A7%D9%84%D9%87%D8%B1%D9%85+%D8%A7%D9%84%D8%A8%D9%8A%D8%B7%D8%B1%D9%8A%D8%A9%E2%80%AD/@30.0002538,31.1814622,17z/data=!3m1!4b1!4m6!3m5!1s0x1458475b1270e8db:0x3efd3e8f840d288c!8m2!3d30.0002538!4d31.1814622!16s%2Fg%2F11rr4zxl2_?entry=ttu&g_ep=EgoyMDI1MDMxMi4wIKXMDSoASAFQAw%3D%3D",
    },
    {
      "name": "الزهور كلينك",
      "location": "الزقازيق، مصر",
      "url":
          "https://www.google.com/maps/search/%D8%A7%D9%84%D8%B2%D9%87%D9%88%D8%B1+%D9%83%D9%84%D9%8A%D9%86%D9%83%2C+%D8%A7%D9%84%D8%B2%D9%82%D8%A7%D8%B2%D9%8A%D9%82%D8%8C+%D9%85%D8%B5%D8%B1",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6852A5),
        title: Text(
          isArabic ? "أشهر العيادات البيطرية" : "TOP VETERINARY CLINICS",
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   height: 200,
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("images/emergency.png"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: clinics.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: InkWell(
                    onTap: () => _launchURL(clinics[index]["url"]!),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: isArabic
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            clinics[index]["name"]!,
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppTheme.primaryColor,
                                  // decoration: TextDecoration.underline,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            clinics[index]["location"]!,
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
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
