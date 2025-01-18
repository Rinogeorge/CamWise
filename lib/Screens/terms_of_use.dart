import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  final String lastUpdatedDate = "23/09/2024";
  final int minimumAgeRequirement = 15;
  final String contactEmail = "Focalyx@gmail.com";

  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(title: const Text("Terms of Use")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                heading: 'Terms of Use',
                child: const Text(
                  'By accessing and using Focalyx, you agree to comply with and be bound by the following terms and conditions of use. If you disagree with any part of these terms, please do not use our app.',
                ),
              ),
              _buildSectionCard(
                heading: '1. Acceptance of Terms',
                child: const Text(
                  'By using Focalyx, you acknowledge that you have read, understood, and agree to be bound by these Terms of Use. If you do not agree to these terms, please discontinue use immediately.',
                ),
              ),
              _buildSectionCard(
                heading: '2. Use of the App',
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2.1. You must be at least 15 years old to use this app.',
                    ),
                    Text(
                      '2.2. You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account or password.',
                    ),
                    Text(
                      '2.3. Focalyx is designed for managing inventory. Any unauthorized use, reproduction, or distribution of the app\'s content may result in legal action.',
                    ),
                  ],
                ),
              ),
              _buildSectionCard(
                heading: '3. User Accounts',
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3.1. To access certain features of the app, you may be required to create a user account. You agree to provide accurate, current, and complete information during the registration process.',
                    ),
                    Text(
                      '3.2. You are responsible for safeguarding your account information and maintaining the security of your password.',
                    ),
                  ],
                ),
              ),
              _buildSectionCard(
                heading: '4. Data Privacy',
                child: const Text(
                  'Focalyx respects your privacy. Please refer to our Privacy Policy for details on how we collect, use, and protect your personal information.',
                ),
              ),
              _buildSectionCard(
                heading: '5. Content Ownership',
                child: const Text(
                  'All content within the app, including but not limited to text, images, and features, is the property of Focalyx or its licensors.',
                ),
              ),
              _buildSectionCard(
                heading: '6. Limitation of Liability',
                child: const Text(
                  'Focalyx shall not be liable for any direct, indirect, incidental, consequential, or exemplary damages resulting from your use of the app.',
                ),
              ),
              _buildSectionCard(
                heading: '7. Modifications to Terms',
                child: const Text(
                  'Focalyx reserves the right to modify these Terms of Use at any time. Your continued use of the app following such changes constitutes your acceptance of the revised terms.',
                ),
              ),
              _buildSectionCard(
                heading: '8. Contact Information',
                child: const Text(
                  'If you have any questions or concerns regarding these Terms of Use, please contact us at Focalyx@gmail.com .',
                ),
              ),
              _buildSectionCard(
                heading: 'Thank you for using Focalyx  !',
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String heading, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            child,
          ],
        ),
      ),
    );
  }
}