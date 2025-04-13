import 'package:flutter/material.dart';
import 'home_screen.dart'; // تأكد من استيراد الصفحة الرئيسية

class PersonalDataScreen extends StatelessWidget {
  const PersonalDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF030416), Color(0xFF191E5B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60), // لإفساح مساحة للسهم
                    const Center(
                        child: Text('Personal Data',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24))),
                    const SizedBox(height: 20),
                    const Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('images/user.png'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(label: 'Full Name'),
                    _buildTextField(
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      prefixText: '+20',
                    ),
                    _buildTextField(
                      label: 'Date of Birth',
                      keyboardType: TextInputType.datetime,
                    ),
                    _buildTextField(
                      label: 'Gender',
                      enabled: true,
                      initialValue: 'Male',
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                        ),
                        onPressed: () {
                          // هنا يمكنك تحديث البيانات في قاعدة البيانات
                        },
                        child: const Text('Save Changes'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
    bool enabled = true,
    String? prefixText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        keyboardType: keyboardType,
        enabled: enabled,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixText: prefixText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }
}
