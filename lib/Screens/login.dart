import 'package:flutter/material.dart';
import 'package:rinosfirstproject/Screens/create_account.dart';
import 'package:rinosfirstproject/functions/model.dart';
import 'package:rinosfirstproject/widgets/bottomnav.dart';
import 'package:rinosfirstproject/widgets/textform.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/Free Vector _ Gray fluid background frame vector.jpeg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 106),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),
                        textform(
                          hintText: 'Username',
                          name: "Username",
                          label: 'Username',
                          controller: _userNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),
                        textform(
                          hintText: 'Password',
                          name: 'Password',
                          label: 'Password',
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => const CreateAccount(),
                                ));
                              },
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_globalKey.currentState!.validate()) {
                                checkLogin();
                              } else {
                                showSnackbar(
                                  context,
                                  'Please enter all fields',
                                  Colors.red,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 30, 66, 98),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Future<void> checkLogin() async {
    try {
      final userBox = await Hive.openBox<Userdatamodel>('create_account');
      final users = userBox.values;

      final username = _userNameController.text;
      final password = _passwordController.text;

      bool foundUser = false;
      for (var user in users) {
        if (user.username == username && user.password == password) {
          foundUser = true;

          // Store the login status
          final loginBox = await Hive.openBox('loginBox');
          await loginBox.put('isLoggedIn', true);

          if (!mounted) return; // Check context safely
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavbar()),
            (route) => false,
          );
          break;
        }
      }

      if (!foundUser) {
        showSnackbar(
          context,
          'Please enter correct username and password',
          Colors.red,
        );
      }
    } catch (e) {
      showSnackbar(
        context,
        'An error occurred. Please try again.',
        Colors.red,
      );
    }
  }

  void showSnackbar(BuildContext context, String message, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: background,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ));
  }
}
