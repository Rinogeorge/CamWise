import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:rinosfirstproject/Screens/about_page.dart';
import 'package:rinosfirstproject/Screens/cartpage.dart';
import 'package:rinosfirstproject/Screens/login.dart';
import 'package:rinosfirstproject/Screens/privacy_policy.dart';
import 'package:rinosfirstproject/Screens/terms_of_use.dart';
import 'package:rinosfirstproject/functions/db_functions.dart';
import 'package:rinosfirstproject/functions/model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  Userdatamodel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    loadImage();
  }

  Future<void> fetchUserData() async {
    final userDataService = UserDataService();
    final retrievedUser = await userDataService.retrieveUserData();

    setState(() {
      user = retrievedUser;
      isLoading = false;
    });
  }

  Future<void> loadImage() async {
    final box = await Hive.openBox<ProfileModel>('profile');
    final profile = box.get('user_profile');
    if (profile != null && profile.image.isNotEmpty) {
      setState(() {
        _image = File(profile.image);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      await saveData();
    }
  }

  Future<void> saveData() async {
    if (_image != null) {
      final box = await Hive.openBox<ProfileModel>('profile');
      final profile = ProfileModel(image: _image!.path);
      await box.put('user_profile', profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4AAEE7), Color(0xFF148DD2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4AAEE7), Color(0xFF148DD2)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: screenWidth * 0.15,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : const AssetImage('lib/assets/Profile.jpg')
                                  as ImageProvider,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        user?.name ?? "Loading...",
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        user?.email ?? "Loading...",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Body Section
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(screenWidth * 0.08),
                        topRight: Radius.circular(screenWidth * 0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Expanded(
                            child: ListView(
                              children: [
                                _buildListTile(
                                  icon: Icons.shopping_cart_outlined,
                                  title: "Cart Page",
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartPage(),
                                    ),
                                  ),
                                ),
                                _buildListTile(
                                  icon: Icons.policy_outlined,
                                  title: "Privacy Policy",
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Privacypolicy(),
                                    ),
                                  ),
                                ),
                                _buildListTile(
                                  icon: Icons.handshake_outlined,
                                  title: "Terms of Use",
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TermsOfUseScreen(),
                                    ),
                                  ),
                                ),
                                _buildListTile(
                                  icon: Icons.info_outline,
                                  title: "About Us",
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AboutPage(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.3,
                                  vertical: screenHeight * 0.015,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: const Color(0xFF4facfe),
                              ),
                              onPressed: () async {
                                final loginBox =
                                    await Hive.openBox('loginBox');
                                await loginBox.put('isLoggedIn', false);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueGrey),
      onTap: onTap,
    );
  }
}
