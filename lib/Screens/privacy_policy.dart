import 'package:flutter/material.dart';

class Privacypolicy extends StatelessWidget {
  const Privacypolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We respect your privacy and are committed to protecting your personal information. This policy outlines how we collect, use, and safeguard your data.',
            ),
            SizedBox(height: 16),
            Text(
              'Information We Collect:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Account Information: Name, email address, and contact details.',
            ),
            Text(
              '- Inventory Data: Product descriptions, quantities, prices, etc.',
            ),
            Text(
              '- Device Information: Device identifiers, IP address, and operating system details.',
            ),
            SizedBox(height: 16),
            Text(
              'How We Use Your Information:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Provide and improve our inventory management services.',
            ),
            Text(
              '- Communicate with you about your account and updates.',
            ),
            Text(
              '- Analyze user interactions to enhance our services.',
            ),
            SizedBox(height: 16),
            Text(
              'Data Sharing:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Share data with service providers to assist in providing our services.',
            ),
            Text(
              '- Disclose information when required by law.',
            ),
            SizedBox(height: 16),
            Text(
              'Your Choices:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Review and update account information within the app.',
            ),
            Text(
              '- Opt-out of promotional communications.',
            ),
            SizedBox(height: 16),
            Text(
              'Security:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We employ measures to protect your information from unauthorized access or disclosure.',
            ),
            SizedBox(height: 16),
            Text(
              'Changes to This Policy:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We may update this policy and will notify you of any changes.',
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you have questions or concerns, please contact us at Focalyx@gmail.com',
            ),
          ],
        ),
      ),
    );
  }
}