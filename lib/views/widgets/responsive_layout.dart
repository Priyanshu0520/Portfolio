import 'package:flutter/material.dart';
import '../../core/utils/responsive_helper.dart';

/// Responsive layout widget that displays different layouts based on screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    if (responsive.isDesktop && desktop != null) {
      return desktop!;
    } else if (responsive.isTablet && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
