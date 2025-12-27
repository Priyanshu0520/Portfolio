import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive_helper.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../widgets/glass_side_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _selectedProjectIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(3, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollPosition = _scrollController.position.pixels;
    final screenHeight = MediaQuery.of(context).size.height;

    int newIndex = 0;
    if (scrollPosition < screenHeight * 0.5) {
      newIndex = 0;
    } else if (scrollPosition < screenHeight * 1.5) {
      newIndex = 1;
    } else {
      newIndex = 2;
    }

    if (newIndex != _currentIndex) {
      setState(() => _currentIndex = newIndex);
    }
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
    final screenHeight = MediaQuery.of(context).size.height;

    _scrollController.animateTo(
      screenHeight * index,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..init(),
      child: _HomeScreenView(
        currentIndex: _currentIndex,
        onTabChanged: _onTabChanged,
        scrollController: _scrollController,
        sectionKeys: _sectionKeys,
        selectedProjectIndex: _selectedProjectIndex,
        onProjectSelected: (index) => setState(() => _selectedProjectIndex = index),
      ),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;
  final int selectedProjectIndex;
  final Function(int) onProjectSelected;

  const _HomeScreenView({
    required this.currentIndex,
    required this.onTabChanged,
    required this.scrollController,
    required this.sectionKeys,
    required this.selectedProjectIndex,
    required this.onProjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          // Scrollable content sections
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              // Only handle scroll from main controller, ignore nested scrolls
              if (notification.depth == 0) {
                return false; // Allow scroll to propagate
              }
              return true; // Block nested scrolls from affecting main scroll
            },
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.only(
                  left: responsive.isDesktop ? 170 : 0, // Shift content right for glass nav
                ),
                child: Column(
                  children: [
                    _buildHomeSection(
                        context, viewModel, responsive, sectionKeys[0], onTabChanged),
                    _buildProjectsSection(
                        context, responsive, sectionKeys[1]),
                    _buildExperienceSection(context, responsive, sectionKeys[2]),
                  ],
                ),
              ),
            ),
          ),

          // Glass side navigation
          if (responsive.isDesktop)
            GlassSideNav(
              currentIndex: currentIndex,
              onTabChanged: onTabChanged,
            ),
        ],
      ),
    );
  }

  Widget _buildHomeSection(
    BuildContext context,
    HomeViewModel viewModel,
    ResponsiveHelper responsive,
    GlobalKey key,
    Function(int) onTabChanged,
  ) {
    return Container(
      key: key,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.isDesktop ? 80 : responsive.responsivePadding,
        vertical: responsive.responsivePadding,
      ),
      child: Center(
        child: responsive.isDesktop
            ? _buildDesktopHomeLayout(context, viewModel, responsive, onTabChanged)
            : _buildMobileHomeLayout(context, viewModel, responsive, onTabChanged),
      ),
    );
  }

  Widget _buildDesktopHomeLayout(
    BuildContext context,
    HomeViewModel viewModel,
    ResponsiveHelper responsive,
    Function(int) onTabChanged,
  ) {
    return Row(
      children: [
        // Left side - Avatar and Content
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Avatar
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 4,
                      ),
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/profile.jpeg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceXL),
              
              // Name and Title
              FadeInUp(
                duration: const Duration(milliseconds: 900),
                child: Column(
                  children: [
                    Text(
                      viewModel.name,
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceSM),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingLG,
                        vertical: AppSizes.paddingSM,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Text(
                        viewModel.tagline,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: AppSizes.spaceXXL),
        
        // Right side - Social Links and Description
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Social Icons
              FadeInRight(
                duration: const Duration(milliseconds: 1000),
                child: Row(
                  children: [
                    _buildSocialIcon(
                      'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                      'https://github.com/Priyanshu0520',
                    ),
                    const SizedBox(width: AppSizes.spaceMD),
                    _buildSocialIcon(
                      'https://cdn-icons-png.flaticon.com/512/174/174857.png',
                      'https://www.linkedin.com/in/priyanshu-gupta-1b6b4020b/',
                    ),
                    const SizedBox(width: AppSizes.spaceMD),
                    _buildSocialIcon(
                      'https://cdn-icons-png.flaticon.com/512/5968/5968534.png',
                      'mailto:priyanshugupta052002@gmail.com',
                    ),
                    const SizedBox(width: AppSizes.spaceLG),
                    // Resume Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add resume download/view logic
                      },
                      icon: const Icon(Icons.description),
                      label: const Text('Resume'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingLG,
                          vertical: AppSizes.paddingMD,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSizes.spaceXL),
              
              // Description
              FadeInRight(
                duration: const Duration(milliseconds: 1100),
                delay: const Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.greeting,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceMD),
                    Text(
                      viewModel.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: AppSizes.fontLG,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceXL),
                    Wrap(
                      spacing: AppSizes.spaceMD,
                      runSpacing: AppSizes.spaceMD,
                      children: [
                        SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () => onTabChanged(1),
                            icon: const Icon(Icons.work_outline),
                            label: const Text(AppStrings.viewWork),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => onTabChanged(2),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingLG,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.workspace_premium,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: AppSizes.spaceSM),
                                Text(
                                  'Experiences',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHomeLayout(
    BuildContext context,
    HomeViewModel viewModel,
    ResponsiveHelper responsive,
    Function(int) onTabChanged,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.responsivePadding),
      child: Column(
        children: [
          // Avatar
          FadeInDown(
            duration: const Duration(milliseconds: 800),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/profile.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceLG),
          
          // Name and Title
          Text(
            viewModel.name,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceSM),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingLG,
              vertical: AppSizes.paddingSM,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              viewModel.tagline,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
          
          const SizedBox(height: AppSizes.spaceXL),
          
          // Social Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                'https://github.com/Priyanshu0520',
              ),
              const SizedBox(width: AppSizes.spaceMD),
              _buildSocialIcon(
                'https://cdn-icons-png.flaticon.com/512/174/174857.png',
                'https://linkedin.com/in/yourprofile',
              ),
              const SizedBox(width: AppSizes.spaceMD),
              _buildSocialIcon(
                'https://cdn-icons-png.flaticon.com/512/5968/5968534.png',
                'mailto:priyanshugupta052002@gmail.com',
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.spaceLG),
          
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.description),
            label: const Text('Resume'),
          ),
          
          const SizedBox(height: AppSizes.spaceXL),
          
          // Description
          Text(
            viewModel.greeting,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceMD),
          Text(
            viewModel.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceXL),
          
          Wrap(
            spacing: AppSizes.spaceMD,
            runSpacing: AppSizes.spaceMD,
            alignment: WrapAlignment.center,
            children: [
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => onTabChanged(1),
                  icon: const Icon(Icons.work_outline),
                  label: const Text(AppStrings.viewWork),
                ),
              ),
              GestureDetector(
                onTap: () => onTabChanged(2),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLG,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSizes.spaceSM),
                      Text(
                        'Experience',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String imageUrl, String link) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(link);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(AppSizes.radiusMD),
      child: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          border: Border.all(
            color: AppColors.greyLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildExperienceSection(
    BuildContext context,
    ResponsiveHelper responsive,
    GlobalKey key,
  ) {
    // Sample experience data
    final experiences = [
      {
        'company': 'Current Company',
        'role': 'Senior Flutter Developer',
        'duration': 'Jan 2024 - Present',
        'startDate': 'Jan 2024',
        'endDate': 'Present',
        'description': 'Leading mobile development team, architecting scalable Flutter applications, implementing CI/CD pipelines, and mentoring junior developers.',
        'skills': ['Flutter', 'Dart', 'Firebase', 'State Management'],
      },
      {
        'company': 'Previous Company',
        'role': 'Flutter Developer',
        'duration': 'Jun 2022 - Dec 2023',
        'startDate': 'Jun 2022',
        'endDate': 'Dec 2023',
        'description': 'Developed and maintained Flutter applications, worked on state management, integrated REST APIs, and collaborated with cross-functional teams.',
        'skills': ['Flutter', 'REST API', 'Provider', 'GetX'],
      },
      {
        'company': 'XYZ Company',
        'role': 'Flutter Intern',
        'duration': 'Jan 2022 - May 2022',
        'startDate': 'Jan 2022',
        'endDate': 'May 2022',
        'description': 'Worked on Flutter basics, state management, Firebase integration, and building responsive UI components.',
        'skills': ['Flutter', 'Firebase', 'Basic State Management'],
      },
    ];

    final skills = [
      'Flutter', 'Dart', 'Firebase', 'REST API', 
      'Provider', 'Bloc', 'GetX', 'Riverpod',
      'Git', 'CI/CD', 'Node.js', 'MongoDB',
      'UI/UX', 'Responsive Design', 'Testing', 'Clean Architecture'
    ];

    return Container(
      key: key,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.isDesktop ? 60 : responsive.responsivePadding,
        vertical: responsive.responsivePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Text(
              'Experience',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXL),
          Expanded(
            child: responsive.isDesktop
                ? _buildDesktopExperienceLayout(context, experiences, skills, responsive)
                : _buildMobileExperienceLayout(context, experiences, skills, responsive),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopExperienceLayout(
    BuildContext context,
    List<Map<String, dynamic>> experiences,
    List<String> skills,
    ResponsiveHelper responsive,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Skills with glass dividers (30%)
        Expanded(
          flex: 3,
          child: _buildSkillsSection(context, skills),
        ),
        const SizedBox(width: AppSizes.spaceXL),
        // Right side - Timeline (70%)
        Expanded(
          flex: 7,
          child: _buildTimelineSection(context, experiences),
        ),
      ],
    );
  }

  Widget _buildMobileExperienceLayout(
    BuildContext context,
    List<Map<String, dynamic>> experiences,
    List<String> skills,
    ResponsiveHelper responsive,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTimelineSection(context, experiences),
          const SizedBox(height: AppSizes.spaceXL),
          _buildSkillsSection(context, skills),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(BuildContext context, List<String> skills) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skills',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: AppSizes.spaceLG),
            // Floating transparent skill bubbles with 360-degree movement
            Wrap(
              spacing: 20,
              runSpacing: 30,
              alignment: WrapAlignment.start,
              children: List.generate(skills.length, (index) {
                return _FloatingSkillBubble(
                  skill: skills[index],
                  index: index,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineSection(
    BuildContext context,
    List<Map<String, dynamic>> experiences,
  ) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          // Dotted road path connecting all experiences
         
          // Experience items
          Column(
            children: List.generate(experiences.length, (index) {
              final experience = experiences[index];
              final isLeft = index % 2 == 0;
              final isLast = index == experiences.length - 1;
              
              return FadeIn(
                duration: Duration(milliseconds: 600 + (index * 200)),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: isLeft ? 0 : MediaQuery.of(context).size.width * 0.15,
                    right: isLeft ? MediaQuery.of(context).size.width * 0.15 : 0,
                    bottom: isLast ? 0 : AppSizes.spaceXL * 2,
                  ),
                  child: Row(
                    mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      // Experience dot
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            border: Border.all(
                              color: AppColors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceMD),
                      // Experience content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
                              children: [
                                if (experience['endDate'] == 'Present')
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.paddingMD,
                                      vertical: AppSizes.paddingSM,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                    ),
                                    child: Text(
                                      'Current',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.spaceSM),
                            Text(
                              experience['role'],
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: isLeft ? TextAlign.left : TextAlign.right,
                            ),
                            const SizedBox(height: AppSizes.spaceSM),
                            Text(
                              experience['company'],
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: isLeft ? TextAlign.left : TextAlign.right,
                            ),
                            const SizedBox(height: AppSizes.spaceSM),
                            Row(
                              mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: AppSizes.spaceSM),
                                Text(
                                  experience['duration'],
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.spaceMD),
                            Text(
                              experience['description'],
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: isLeft ? TextAlign.left : TextAlign.right,
                            ),
                            const SizedBox(height: AppSizes.spaceMD),
                            Wrap(
                              spacing: AppSizes.spaceSM,
                              runSpacing: AppSizes.spaceSM,
                              alignment: isLeft ? WrapAlignment.start : WrapAlignment.end,
                              children: (experience['skills'] as List).map((skill) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.paddingMD,
                                    vertical: AppSizes.paddingSM,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.5),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    skill,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection(
    BuildContext context,
    ResponsiveHelper responsive,
    GlobalKey key,
  ) {
    final projects = [
      {
        'name': 'Vitality - Fitness App',
        'description':
            'A comprehensive fitness tracking app with workout plans, nutrition tracking, and progress monitoring.',
        'gridImage':
            'https://play-lh.googleusercontent.com/Yp1PdEQWsK3bzuD0wKKVP3cdhSDqN4GLV_45dJ3BlshzV5PjB5JAzReEShYZo_6tD-IY=w526-h296-rw',
        'technologies': ['Flutter', 'Firebase', 'Provider', 'REST API'],
        'github': 'https://github.com/username/vitality',
        'images': [
          'https://cdn.dribbble.com/userupload/14315397/file/original-b2d9fa368a9fb4cdd8575ee4ecef06c5.jpg?format=webp&resize=400x300&vertical=center',
        ],
      },
      {
        'name': 'E-Commerce Platform',
        'description':
            'Modern e-commerce solution with product management, cart, checkout, and payment integration.',
        'gridImage':
            'https://play-lh.googleusercontent.com/Yp1PdEQWsK3bzuD0wKKVP3cdhSDqN4GLV_45dJ3BlshzV5PjB5JAzReEShYZo_6tD-IY=w526-h296-rw',
        'technologies': ['Flutter', 'Node.js', 'MongoDB', 'Stripe'],
        'github': 'https://github.com/username/ecommerce',
        'images': [
          'https://cdn.dribbble.com/userupload/14315397/file/original-b2d9fa368a9fb4cdd8575ee4ecef06c5.jpg?format=webp&resize=400x300&vertical=center',
        ],
      },
      {
        'name': 'Social Media App',
        'description':
            'Social networking platform with posts, stories, messaging, and real-time notifications.',
        'gridImage':
            'https://play-lh.googleusercontent.com/Yp1PdEQWsK3bzuD0wKKVP3cdhSDqN4GLV_45dJ3BlshzV5PjB5JAzReEShYZo_6tD-IY=w526-h296-rw',
        'technologies': ['Flutter', 'Firebase', 'Bloc', 'Cloud Functions'],
        'github': 'https://github.com/username/social-app',
        'images': [
          'https://cdn.dribbble.com/userupload/14315397/file/original-b2d9fa368a9fb4cdd8575ee4ecef06c5.jpg?format=webp&resize=400x300&vertical=center',
        ],
      },
    ];

    return Container(
      key: key,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.isDesktop ? 60 : responsive.responsivePadding,
        vertical: responsive.responsivePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Text(
              'Projects',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXL),
          Expanded(
            child: responsive.isDesktop
                ? _buildDesktopProjectLayout(context, projects, selectedProjectIndex, onProjectSelected)
                : _buildMobileProjectLayout(context, projects),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopProjectLayout(
      BuildContext context, 
      List<Map<String, dynamic>> projects,
      int selectedProjectIndex,
      Function(int) onProjectSelected) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project grid
        Expanded(
          flex: 2,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSizes.spaceMD,
              mainAxisSpacing: AppSizes.spaceMD,
              childAspectRatio: 1.2,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return _buildProjectCard(
                context,
                projects[index],
                index,
                selectedProjectIndex,
                onProjectSelected,
              );
            },
          ),
        ),
        const SizedBox(width: AppSizes.spaceXL),
        // Project details
        Expanded(
          flex: 3,
          child: _buildProjectDetails(
            context,
            projects[selectedProjectIndex],
            selectedProjectIndex,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileProjectLayout(
      BuildContext context, List<Map<String, dynamic>> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return _buildMobileProjectCard(context, projects[index]);
      },
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    Map<String, dynamic> project,
    int index,
    int selectedProjectIndex,
    Function(int) onProjectSelected,
  ) {
    final isSelected = selectedProjectIndex == index;

    return GestureDetector(
      onTap: () {
        onProjectSelected(index);
      },
      child: FadeInUp(
        duration: Duration(milliseconds: 600 + (index * 100)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLG),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.greyLight,
              width: isSelected ? 2 : 1,
            ),
            gradient: isSelected ? AppColors.primaryGradient : null,
          ),
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppSizes.radiusLG - 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Stack(
                    children: [
                      // Stacked card effect - 3 layers
                      Positioned(
                        top: 12,
                        left: 8,
                        right: 8,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.greyLight.withOpacity(0.3),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMD),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 4,
                        right: 4,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.greyLight.withOpacity(0.6),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMD),
                          ),
                        ),
                      ),
                      // Main image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.radiusLG - 2),
                          topRight: Radius.circular(AppSizes.radiusLG - 2),
                        ),
                        child: Image.network(
                          project['gridImage'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 120,
                              color: AppColors.greyLight,
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 40,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 120,
                              color: AppColors.greyLight,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ),
                      // GitHub icon
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () async {
                            final url = project['github'] as String;
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingSM),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          project['name'],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceSM),
                      Flexible(
                        child: Text(
                          project['description'],
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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

  Widget _buildProjectDetails(
    BuildContext context,
    Map<String, dynamic> project,
    int selectedProjectIndex,
  ) {
    return SingleChildScrollView(
      child: FadeIn(
        key: ValueKey(selectedProjectIndex),
        duration: const Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project['name'],
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: AppSizes.spaceMD),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final url = project['github'] as String;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMD,
                      vertical: AppSizes.paddingSM,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMD),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                          width: 20,
                          height: 20,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: AppSizes.spaceSM),
                        Text(
                          'View on GitHub',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceLG),
            Text(
              project['description'],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSizes.spaceLG),
            Text(
              'Technologies',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.spaceMD),
            Wrap(
              spacing: AppSizes.spaceSM,
              runSpacing: AppSizes.spaceSM,
              children:
                  (project['technologies'] as List<dynamic>).map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMD,
                    vertical: AppSizes.paddingSM,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Text(
                    tech,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSizes.spaceXL),
            Text(
              'Gallery',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.spaceMD),
            ...(project['images'] as List<dynamic>).map((imageUrl) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spaceMD),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: AppColors.greyLight,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: AppColors.greyLight,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileProjectCard(
      BuildContext context, Map<String, dynamic> project) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusXL),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSizes.paddingLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.greyLight,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSM),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceLG),
                      Text(
                        project['name'],
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSizes.spaceMD),
                      GestureDetector(
                        onTap: () async {
                          final url = project['github'] as String;
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingMD,
                            vertical: AppSizes.paddingSM,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusMD),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                                width: 20,
                                height: 20,
                                color: AppColors.white,
                              ),
                              const SizedBox(width: AppSizes.spaceSM),
                              Text(
                                'View on GitHub',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceLG),
                      Text(
                        project['description'],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSizes.spaceLG),
                      Text(
                        'Technologies',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSizes.spaceMD),
                      Wrap(
                        spacing: AppSizes.spaceSM,
                        runSpacing: AppSizes.spaceSM,
                        children: (project['technologies'] as List<dynamic>)
                            .map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.paddingMD,
                              vertical: AppSizes.paddingSM,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusFull),
                            ),
                            child: Text(
                              tech,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSizes.spaceXL),
                      Text(
                        'Gallery',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSizes.spaceMD),
                      ...(project['images'] as List<dynamic>).map((imageUrl) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSizes.spaceMD),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusLG),
                            child: Image.network(
                              imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: AppColors.greyLight,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 48,
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 200,
                                  color: AppColors.greyLight,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSizes.spaceMD),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppSizes.radiusLG),
            border: Border.all(color: AppColors.greyLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Stacked card effect - 3 layers
                  Positioned(
                    top: 16,
                    left: 12,
                    right: 12,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.greyLight.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 6,
                    right: 6,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.greyLight.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                      ),
                    ),
                  ),
                  // Main image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSizes.radiusLG),
                    ),
                    child: Image.network(
                      project['gridImage'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          color: AppColors.greyLight,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 180,
                          color: AppColors.greyLight,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                  // GitHub icon
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () async {
                        final url = project['github'] as String;
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.network(
                          'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['name'],
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: AppSizes.spaceSM),
                    Text(
                      project['description'],
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingSkillBubble extends StatefulWidget {
  final String skill;
  final int index;

  const _FloatingSkillBubble({
    required this.skill,
    required this.index,
  });

  @override
  State<_FloatingSkillBubble> createState() => _FloatingSkillBubbleState();
}

class _FloatingSkillBubbleState extends State<_FloatingSkillBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _horizontalAnimation;
  late Animation<double> _verticalAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 3000 + (widget.index * 300)),
      vsync: this,
    )..repeat(reverse: true);

    // Create different movement patterns for each bubble
    final offset = widget.index % 4;
    _horizontalAnimation = Tween<double>(
      begin: -8.0 + (offset * 2),
      end: 8.0 - (offset * 2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _verticalAnimation = Tween<double>(
      begin: -10.0 + (offset * 3),
      end: 10.0 - (offset * 3),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: Duration(milliseconds: 600 + (widget.index * 80)),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              _horizontalAnimation.value,
              _verticalAnimation.value,
            ),
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMD,
                      vertical: AppSizes.paddingSM,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      widget.skill,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

