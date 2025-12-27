import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

/// Responsive helper to determine device type and provide responsive values
class ResponsiveHelper {
  final BuildContext context;

  ResponsiveHelper(this.context);

  /// Get screen width
  double get width => MediaQuery.of(context).size.width;

  /// Get screen height
  double get height => MediaQuery.of(context).size.height;

  /// Check if device is mobile
  bool get isMobile => width < AppSizes.mobileBreakpoint;

  /// Check if device is tablet
  bool get isTablet =>
      width >= AppSizes.mobileBreakpoint && width < AppSizes.desktopBreakpoint;

  /// Check if device is desktop
  bool get isDesktop => width >= AppSizes.desktopBreakpoint;

  /// Check if device is widescreen
  bool get isWidescreen => width >= AppSizes.widescreenBreakpoint;

  /// Check if device is mobile or tablet
  bool get isMobileOrTablet => width < AppSizes.desktopBreakpoint;

  /// Get responsive value based on device type
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? widescreen,
  }) {
    if (isWidescreen && widescreen != null) return widescreen;
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Get responsive padding
  double get responsivePadding {
    return responsive(
      mobile: AppSizes.paddingMD,
      tablet: AppSizes.paddingLG,
      desktop: AppSizes.paddingXL,
      widescreen: AppSizes.paddingXXL,
    );
  }

  /// Get responsive font size multiplier
  double get fontSizeMultiplier {
    return responsive(
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
      widescreen: 1.3,
    );
  }

  /// Get number of columns for grid
  int get gridColumns {
    return responsive(
      mobile: 1,
      tablet: 2,
      desktop: 3,
      widescreen: 4,
    );
  }

  /// Get max content width
  double get maxContentWidth {
    return responsive(
      mobile: width,
      tablet: width * 0.9,
      desktop: AppSizes.maxContentWidth,
      widescreen: AppSizes.maxContentWidthWide,
    );
  }

  /// Get horizontal padding for content
  double get horizontalPadding {
    return responsive(
      mobile: AppSizes.paddingMD,
      tablet: AppSizes.paddingLG,
      desktop: AppSizes.paddingXL,
      widescreen: (width - AppSizes.maxContentWidthWide) / 2,
    );
  }

  /// Get vertical spacing
  double get verticalSpacing {
    return responsive(
      mobile: AppSizes.spaceLG,
      tablet: AppSizes.spaceXL,
      desktop: AppSizes.spaceXXL,
      widescreen: AppSizes.space3XL,
    );
  }

  /// Static method to use without context dependency
  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < AppSizes.mobileBreakpoint;
  }

  static bool isTabletScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppSizes.mobileBreakpoint &&
        width < AppSizes.desktopBreakpoint;
  }

  static bool isDesktopScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppSizes.desktopBreakpoint;
  }
}

/// Extension on BuildContext for easy access to ResponsiveHelper
extension ResponsiveContext on BuildContext {
  ResponsiveHelper get responsive => ResponsiveHelper(this);
}
