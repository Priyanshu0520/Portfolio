import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive_helper.dart';
import '../../routes/app_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        AppStrings.appName,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
      ),
      actions: [
        if (responsive.isDesktop) ...[
          _buildNavButton(context, AppStrings.navHome, AppRoutes.home),
          const SizedBox(width: AppSizes.spaceMD),
        ] else
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _showMobileMenu(context),
          ),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String label, String route) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isActive = currentRoute == route;

    return TextButton(
      onPressed: () => context.go(route),
      style: TextButton.styleFrom(
        foregroundColor: isActive ? AppColors.primary : AppColors.textPrimary,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.paddingLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMobileNavItem(context, AppStrings.navHome, AppRoutes.home, Icons.home),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(
    BuildContext context,
    String label,
    String route,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
