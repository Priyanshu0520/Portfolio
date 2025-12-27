import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive_helper.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/responsive_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..init(),
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context, viewModel, responsive),
        tablet: _buildTabletLayout(context, viewModel, responsive),
        desktop: _buildDesktopLayout(context, viewModel, responsive),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    HomeViewModel viewModel,
    ResponsiveHelper responsive,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.responsivePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: responsive.verticalSpacing),
          _buildHeroSection(context, viewModel, responsive),
          SizedBox(height: responsive.verticalSpacing * 2),
          _buildActionButtons(context, responsive),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    HomeViewModel viewModel,
    ResponsiveHelper responsive,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.responsivePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: responsive.verticalSpacing),
          _buildHeroSection(context, viewModel, responsive),
          SizedBox(height: responsive.verticalSpacing * 2),
          _buildActionButtons(context, responsive),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    HomeViewModel viewModel,
    ResponsiveHelper responsive,
  ) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: responsive.maxContentWidth),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.horizontalPadding,
          vertical: responsive.verticalSpacing,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(context, viewModel, responsive),
                  SizedBox(height: responsive.verticalSpacing),
                  _buildActionButtons(context, responsive),
                ],
              ),
            ),
            SizedBox(width: responsive.horizontalPadding),
            Expanded(
              child: _buildIllustration(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    HomeViewModel viewModel,
    ResponsiveHelper responsive,
  ) {
    return Column(
      crossAxisAlignment: responsive.isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Text(
            viewModel.greeting,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceSM),
        FadeInDown(
          duration: const Duration(milliseconds: 800),
          child: Text(
            viewModel.name,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: responsive.responsive(
                    mobile: AppSizes.font3XL,
                    tablet: AppSizes.font4XL,
                    desktop: 72,
                  ),
                ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceMD),
        FadeInDown(
          duration: const Duration(milliseconds: 1000),
          child: Container(
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
        ),
        const SizedBox(height: AppSizes.spaceLG),
        FadeInUp(
          duration: const Duration(milliseconds: 1200),
          child: Text(
            viewModel.description,
            textAlign:
                responsive.isDesktop ? TextAlign.left : TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: responsive.responsive(
                    mobile: AppSizes.fontMD,
                    tablet: AppSizes.fontLG,
                    desktop: AppSizes.fontXL,
                  ),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ResponsiveHelper responsive) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1400),
      child: Wrap(
        spacing: AppSizes.spaceMD,
        runSpacing: AppSizes.spaceMD,
        alignment: responsive.isDesktop ? WrapAlignment.start : WrapAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.work_outline),
            label: const Text(AppStrings.viewWork),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mail_outline),
            label: const Text(AppStrings.contactMe),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 1600),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        ),
        child: const Center(
          child: Icon(
            Icons.code,
            size: 120,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
