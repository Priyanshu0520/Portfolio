# Portfolio - Flutter Web & Mobile App

A professional portfolio application built with Flutter, supporting both mobile and web platforms with a responsive design.

## 🏗️ Project Structure

```
lib/
├── core/                      # Core functionality
│   ├── constants/             # App constants
│   │   ├── app_colors.dart    # Color palette
│   │   ├── app_sizes.dart     # Size constants & breakpoints
│   │   └── app_strings.dart   # String constants
│   ├── theme/                 # App theming
│   │   └── app_theme.dart     # Light & Dark themes
│   └── utils/                 # Utility classes
│       ├── responsive_helper.dart  # Responsive design helper
│       └── screen_utils.dart       # Screen utility functions
│
├── data/                      # Data layer
│   ├── models/                # Data models
│   └── repositories/          # Data repositories
│
├── viewmodels/                # MVVM ViewModels
│   ├── base_viewmodel.dart    # Base ViewModel class
│   └── home_viewmodel.dart    # Home screen ViewModel
│
├── views/                     # UI layer
│   ├── screens/               # App screens
│   │   ├── home_screen.dart
│   │   ├── about_screen.dart
│   │   ├── projects_screen.dart
│   │   └── contact_screen.dart
│   └── widgets/               # Reusable widgets
│       ├── custom_app_bar.dart
│       └── responsive_layout.dart
│
├── routes/                    # Navigation
│   └── app_router.dart        # GoRouter configuration
│
└── main.dart                  # App entry point

assets/
├── fonts/                     # Custom fonts
├── images/                    # Image assets
├── animations/                # Animation files
└── lottie/                    # Lottie animations
```
