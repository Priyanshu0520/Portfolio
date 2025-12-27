import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.projectsTitle),
      ),
      body: const Center(
        child: Text('Projects will be displayed here'),
      ),
    );
  }
}
