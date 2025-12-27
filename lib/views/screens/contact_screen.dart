import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.contactTitle),
      ),
      body: const Center(
        child: Text(AppStrings.contactDescription),
      ),
    );
  }
}
