import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_sizes.dart';
import 'core/utils/screen_utils.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.theme,

      // Router Configuration
      routerConfig: AppRouter.router,

      // Responsive Framework Configuration
      builder: (context, child) {
        // Initialize ScreenUtils
        ScreenUtils.init(context);

        return ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(
                start: 0, end: AppSizes.mobileBreakpoint, name: MOBILE),
            const Breakpoint(
              start: AppSizes.mobileBreakpoint + 1,
              end: AppSizes.tabletBreakpoint,
              name: TABLET,
            ),
            const Breakpoint(
              start: AppSizes.tabletBreakpoint + 1,
              end: AppSizes.desktopBreakpoint,
              name: DESKTOP,
            ),
            const Breakpoint(
              start: AppSizes.desktopBreakpoint + 1,
              end: double.infinity,
              name: '4K',
            ),
          ],
        );
      },
    );
  }
}
