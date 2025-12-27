import 'package:flutter/material.dart';

/// Screen utility class for responsive design
class ScreenUtils {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockSizeHorizontal;
  static late double _blockSizeVertical;
  static late double _safeBlockHorizontal;
  static late double _safeBlockVertical;
  static late EdgeInsets _safeAreaPadding;

  /// Initialize screen utilities
  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    _safeAreaPadding = mediaQuery.padding;
    final safeAreaHorizontal =
        _safeAreaPadding.left + _safeAreaPadding.right;
    final safeAreaVertical = _safeAreaPadding.top + _safeAreaPadding.bottom;
    _safeBlockHorizontal = (_screenWidth - safeAreaHorizontal) / 100;
    _safeBlockVertical = (_screenHeight - safeAreaVertical) / 100;
  }

  /// Get screen width
  static double get screenWidth => _screenWidth;

  /// Get screen height
  static double get screenHeight => _screenHeight;

  /// Get percentage of screen width
  static double percentWidth(double percent) => _blockSizeHorizontal * percent;

  /// Get percentage of screen height
  static double percentHeight(double percent) => _blockSizeVertical * percent;

  /// Get safe percentage of screen width (excluding safe area)
  static double safePercentWidth(double percent) =>
      _safeBlockHorizontal * percent;

  /// Get safe percentage of screen height (excluding safe area)
  static double safePercentHeight(double percent) =>
      _safeBlockVertical * percent;

  /// Get safe area padding
  static EdgeInsets get safeAreaPadding => _safeAreaPadding;

  /// Get aspect ratio
  static double get aspectRatio => _screenWidth / _screenHeight;

  /// Check if device is in landscape mode
  static bool get isLandscape => _screenWidth > _screenHeight;

  /// Check if device is in portrait mode
  static bool get isPortrait => _screenHeight > _screenWidth;

  /// Get orientation
  static Orientation get orientation =>
      isLandscape ? Orientation.landscape : Orientation.portrait;

  /// Scale size based on design reference
  /// For example, if design is based on iPhone 11 (414x896)
  static double scaleWidth(double size, {double designWidth = 414}) {
    return (_screenWidth / designWidth) * size;
  }

  static double scaleHeight(double size, {double designHeight = 896}) {
    return (_screenHeight / designHeight) * size;
  }

  /// Get responsive text size
  static double getResponsiveTextSize(double size) {
    if (_screenWidth < 600) {
      // Mobile
      return size;
    } else if (_screenWidth < 900) {
      // Tablet
      return size * 1.1;
    } else if (_screenWidth < 1200) {
      // Desktop
      return size * 1.2;
    } else {
      // Large Desktop
      return size * 1.3;
    }
  }
}
