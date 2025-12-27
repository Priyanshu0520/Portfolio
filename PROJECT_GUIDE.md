# Project Structure Guide

## 📁 Folder Descriptions

### `/lib/core/`
Core application logic and utilities that are used throughout the app.

#### `/lib/core/constants/`
- **app_colors.dart**: Defines the app's color palette for light/dark themes
- **app_sizes.dart**: Contains sizing constants, breakpoints, and spacing values
- **app_strings.dart**: Centralizes all text strings used in the app

#### `/lib/core/theme/`
- **app_theme.dart**: Complete theme configuration for Material Design

#### `/lib/core/utils/`
- **responsive_helper.dart**: Helper class for responsive design
- **screen_utils.dart**: Screen size calculations and utilities

---

### `/lib/data/`
Data layer following clean architecture principles.

#### `/lib/data/models/`
Place your data models here. Example:
```dart
class Project {
  final String title;
  final String description;
  final String imageUrl;
  
  Project({required this.title, required this.description, required this.imageUrl});
}
```

#### `/lib/data/repositories/`
Place repository classes here for data operations. Example:
```dart
class ProjectRepository {
  Future<List<Project>> getProjects() async {
    // Fetch from API or local storage
  }
}
```

---

### `/lib/viewmodels/`
ViewModels for MVVM architecture. Each screen should have its own ViewModel.

**Example**: Creating a new ViewModel
```dart
import 'base_viewmodel.dart';

class ProjectsViewModel extends BaseViewModel {
  List<Project> _projects = [];
  
  List<Project> get projects => _projects;
  
  @override
  void init() {
    super.init();
    loadProjects();
  }
  
  Future<void> loadProjects() async {
    await executeAsync(() async {
      // Load projects logic
      _projects = await projectRepository.getProjects();
      notifyListeners();
    });
  }
}
```

---

### `/lib/views/`
UI layer containing all screens and reusable widgets.

#### `/lib/views/screens/`
Individual screen widgets. Each screen should:
- Use a ViewModel via Provider
- Be responsive using ResponsiveLayout
- Follow the established design system

#### `/lib/views/widgets/`
Reusable UI components. Examples:
- Custom buttons
- Cards
- Form fields
- Loading indicators

---

### `/lib/routes/`
Navigation configuration using GoRouter.

**Adding a new route**:
1. Add route constant to `AppRoutes` class
2. Add GoRoute to router configuration
3. Create the corresponding screen

---

### `/assets/`
Static assets used in the app.

#### Structure:
```
assets/
├── fonts/          # Custom fonts (if not using Google Fonts)
├── images/         # PNG, JPG images
│   ├── logo.png
│   └── profile.jpg
├── animations/     # Animation files
└── lottie/         # Lottie JSON files
    ├── loading.json
    └── success.json
```

---

## 🎯 Development Workflow

### 1. Adding a New Feature

**Example: Adding a Skills Section**

1. **Create Model** (`lib/data/models/skill.dart`):
```dart
class Skill {
  final String name;
  final String icon;
  final int proficiency;
  
  Skill({required this.name, required this.icon, required this.proficiency});
}
```

2. **Create ViewModel** (`lib/viewmodels/skills_viewmodel.dart`):
```dart
class SkillsViewModel extends BaseViewModel {
  List<Skill> _skills = [];
  List<Skill> get skills => _skills;
  
  @override
  void init() {
    super.init();
    loadSkills();
  }
  
  Future<void> loadSkills() async {
    await executeAsync(() async {
      _skills = [
        Skill(name: 'Flutter', icon: '🦋', proficiency: 90),
        Skill(name: 'Dart', icon: '🎯', proficiency: 85),
      ];
      notifyListeners();
    });
  }
}
```

3. **Create Screen** (`lib/views/screens/skills_screen.dart`):
```dart
class SkillsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SkillsViewModel()..init(),
      child: SkillsScreenView(),
    );
  }
}
```

4. **Add Route** (in `lib/routes/app_router.dart`):
```dart
class AppRoutes {
  static const String skills = '/skills';
}

GoRoute(
  path: AppRoutes.skills,
  name: 'skills',
  builder: (context, state) => const SkillsScreen(),
),
```

---

### 2. Making Components Responsive

Use the `ResponsiveLayout` widget:

```dart
ResponsiveLayout(
  mobile: _buildMobileLayout(),
  tablet: _buildTabletLayout(),
  desktop: _buildDesktopLayout(),
)
```

Or use `ResponsiveHelper`:

```dart
final responsive = context.responsive;

Container(
  padding: EdgeInsets.all(responsive.responsivePadding),
  width: responsive.responsive(
    mobile: double.infinity,
    tablet: 600,
    desktop: 800,
  ),
)
```

---

### 3. Adding Animations

**Fade In Animation**:
```dart
import 'package:animate_do/animate_do.dart';

FadeInUp(
  duration: Duration(milliseconds: 600),
  child: YourWidget(),
)
```

**Lottie Animation**:
```dart
import 'package:lottie/lottie.dart';

Lottie.asset(
  'assets/lottie/loading.json',
  width: 200,
  height: 200,
)
```

---

### 4. Using Themes

Access theme colors:
```dart
// Using theme
final primaryColor = Theme.of(context).colorScheme.primary;

// Using custom colors
import 'package:portfolio/core/constants/app_colors.dart';
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
  ),
)
```

---

## 📝 Best Practices

1. **State Management**:
   - Use ViewModels for business logic
   - Keep widgets pure and stateless when possible
   - Use `Consumer` or `context.watch` to rebuild on changes

2. **Responsive Design**:
   - Always test on multiple screen sizes
   - Use responsive breakpoints consistently
   - Consider touch targets on mobile vs mouse on desktop

3. **Code Organization**:
   - One widget per file for screens
   - Group related widgets in the same folder
   - Keep files under 300 lines when possible

4. **Naming Conventions**:
   - Screens: `*_screen.dart`
   - ViewModels: `*_viewmodel.dart`
   - Widgets: `*_widget.dart` or descriptive names
   - Models: Use noun names

5. **Assets**:
   - Optimize images before adding
   - Use SVG for icons when possible
   - Keep Lottie files under 100KB

---

## 🚀 Next Steps

1. **Customize Content**: Update strings, colors, and content in `/lib/core/constants/`
2. **Add Your Projects**: Create project models and repository
3. **Design Screens**: Implement About, Projects, and Contact screens
4. **Add Assets**: Add your images, animations, and other assets
5. **Deploy**: Build for web, mobile, or desktop

---

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Responsive Framework](https://pub.dev/packages/responsive_framework)
- [Animate Do](https://pub.dev/packages/animate_do)
- [Lottie Files](https://lottiefiles.com/)

---

**Happy Coding! 🎉**
