import 'package:flutter/material.dart';
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Our App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20,),
            Text(
              'Our inventory management app is designed specifically for shop owners to efficiently manage their inventory. With intuitive features and user-friendly interface, it streamlines the process of tracking products, managing stock levels, and generating reports.',
            ),
            SizedBox(height: 20,),
            Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Text('- Easy product cataloging and organization.'),
            Text('- Real-time tracking of inventory levels.'),
            Text('- Automated notifications for low stock items.'),
            Text('- Sales analytics and reporting tools.'),
            SizedBox(height: 20,),
            Text(
              'Our mission is to empower shop owners with the tools they need to effectively manage their inventory, streamline operations, and optimize business performance.',
            ),
            SizedBox(height: 20,),
            Text(
              'For any inquiries or feedback, please contact us. Thank you for choosing our app!',
            ),
            SizedBox(height: 50,), // Space before the version number
            Align(
              alignment: Alignment.center,
              child: Text(
                'Version 1', // Replace with your version number
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 16, 15, 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}