import 'package:flutter/material.dart';
import 'package:learning_app/widgets/customAppBar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget sectionContent(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: Customappbar(title: "Privacy Policy"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Crescent Learning App",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text("Last Updated: April 09, 2026"),

              sectionTitle("1. Information We Collect"),
              sectionContent(
                "We collect personal information you provide such as name, email, phone number, username, password, and address when you register or use our services.",
              ),

              sectionTitle("2. How We Use Your Information"),
              sectionContent(
                "We use your data to create accounts, provide services, communicate with you, improve our app, and ensure security.",
              ),

              sectionTitle("3. Sharing of Information"),
              sectionContent(
                "We may share your data during business transfers or when required by law.",
              ),

              sectionTitle("4. Data Retention"),
              sectionContent(
                "We retain your data only as long as necessary to provide services or comply with legal obligations.",
              ),

              sectionTitle("5. Data Security"),
              sectionContent(
                "We implement reasonable security measures, but no system is completely secure.",
              ),

              sectionTitle("6. Your Rights"),
              sectionContent(
                "You can review, update, or delete your data and withdraw consent by contacting us.",
              ),

              sectionTitle("7. Updates to Policy"),
              sectionContent(
                "We may update this policy from time to time. Changes will be reflected with a new date.",
              ),

              sectionTitle("8. Contact Us"),
              sectionContent(
                "Email: crescentlearningapp@gmail.com\n"
                "Address: Crescent Centre Hybrid Tuition,\n"
                "Kadungathukundu, Tirur, Kerala 676551, India",
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
