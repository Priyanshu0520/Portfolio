import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/about_screen.dart';
import '../views/screens/projects_screen.dart';
import '../views/screens/contact_screen.dart';

/// App route names
class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
  static const String projects = '/projects';
  static const String contact = '/contact';
}

/// App router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.about,
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: AppRoutes.projects,
        name: 'projects',
        builder: (context, state) => const ProjectsScreen(),
      ),
      GoRoute(
        path: AppRoutes.contact,
        name: 'contact',
        builder: (context, state) => const ContactScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
