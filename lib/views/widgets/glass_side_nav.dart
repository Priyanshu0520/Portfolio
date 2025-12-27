import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class GlassSideNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const GlassSideNav({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  State<GlassSideNav> createState() => _GlassSideNavState();
}

class _GlassSideNavState extends State<GlassSideNav> {
  int? _hoveredIndex;

  final List<NavItem> _navItems = [
    NavItem(icon: Icons.home_rounded, label: 'Home'),
    NavItem(icon: Icons.work_rounded, label: 'Projects'),
    NavItem(icon: Icons.workspace_premium, label: 'Experience'),
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 32,
      top: 0,
      bottom: 0,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 115,
              height: 650,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingXL),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.white.withOpacity(0.15),
                    AppColors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(5, 0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  _navItems.length,
                  (index) => _buildNavItem(
                    _navItems[index],
                    index,
                    widget.currentIndex == index,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavItem item, int index, bool isActive) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: () => widget.onTabChanged(index),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceSM),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bubble animation on right side
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                right: isHovered ? -24 : -8,
                top: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isHovered ? 1.0 : 0.0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Icon container
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(AppSizes.paddingLG),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withOpacity(0.2)
                      : isHovered
                          ? AppColors.primaryLight.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary.withOpacity(0.3)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: isHovered ? 1.2 : 1.0,
                      child: Icon(
                        item.icon,
                        color: isActive
                            ? AppColors.primary
                            : isHovered
                                ? AppColors.primaryDark
                                : AppColors.textSecondary,
                        size: AppSizes.iconXL,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceXS),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isHovered || isActive ? 1.0 : 0.7,
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: AppSizes.fontXS,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Active indicator
              if (isActive)
                Positioned(
                  right: -12,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({
    required this.icon,
    required this.label,
  });
}
