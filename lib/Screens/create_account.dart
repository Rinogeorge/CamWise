import 'package:flutter/material.dart';
import 'package:rinosfirstproject/Screens/login.dart';
import 'package:rinosfirstproject/functions/model.dart';
import 'package:rinosfirstproject/widgets/textform.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController nameInputcontroller = TextEditingController();
  TextEditingController usernameInputcontroller = TextEditingController();
  TextEditingController passwordInputcontroller = TextEditingController();
  TextEditingController emailInputcontroller = TextEditingController();
  TextEditingController mobileInputcontroller = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/Free Vector _ Gray fluid background frame vector.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 13, right: 2),
                        child: Column(
                          children: [
                            const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            textform(
                              hintText: 'Name',
                              label: 'Name',
                              controller: nameInputcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              name: 'Name',
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 20),
                            textform(
                              name: 'Username',
                              label: 'Username',
                              hintText: 'Username',
                              controller: usernameInputcontroller,
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
                              controller: passwordInputcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 20),
                            textform(
                              hintText: 'Email',
                              name: 'Email',
                              label: 'Email',
                              controller: emailInputcontroller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 20),
                            textform(
                              hintText: 'Mobile',
                              name: 'Mobile',
                              label: 'Mobile',
                              controller: mobileInputcontroller,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your mobile';
                                }
                                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                  return 'Please enter a valid mobile number';
                                }
                                return null;
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Login',
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
                                  if (_formKey.currentState!.validate()) {
                                    onCreateAccountButtonClicked();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'Please enter all fields',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                      255, 30, 66, 98),
                                ),
                                child: const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onCreateAccountButtonClicked() async {
    final name = nameInputcontroller.text.trim();
    final username = usernameInputcontroller.text.trim();
    final password = passwordInputcontroller.text.trim();
    final email = emailInputcontroller.text.trim();
    final mobile = int.parse(mobileInputcontroller.text.trim());

    if (name.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        mobile.toString().isEmpty) {
      return;
    }

    final user = Userdatamodel(
      name: name,
      username: username,
      password: password,
      email: email,
      phone: mobile,
    );

    final box = Hive.box<Userdatamodel>('create_account');
    await box.add(user);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Account created successfully!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const LoginScreen()),
      (route) => false,
    );
  }
}
