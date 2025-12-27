import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.aboutTitle),
      ),
      body: const Center(
        child: Text(AppStrings.aboutDescription),
      ),
    );
  }
}
