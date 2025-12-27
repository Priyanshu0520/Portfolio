# Portfolio Theme Guide 🎨

## Color Palette - Chocolate Brown & Beige

### Primary Colors
- **Rich Chocolate Brown** (#5D4037) - Main brand color
- **Dark Chocolate** (#3E2723) - Darker accent
- **Light Brown** (#8D6E63) - Lighter accent

### Secondary Colors
- **Soft Beige** (#D7CCC8) - Secondary brand color
- **Warm Beige** (#BCAAA4) - Darker beige
- **Light Beige** (#EFEBE9) - Lighter beige

### Background Colors
- **Creamy White** (#FAF8F6) - Main background
- **Pure White** (#FFFFFF) - Surface color
- **Warm White** (#FFF8F5) - Card background

### Text Colors
- **Dark Brown** (#3E2723) - Primary text
- **Medium Brown** (#6D4C41) - Secondary text
- **Light Brown** (#8D6E63) - Tertiary text

## Typography

### Display Text (Headings)
- **Font**: Playfair Display
- **Weights**: Bold (700), Semi-bold (600)
- **Usage**: Large headings, hero sections

### Headlines
- **Font**: Merriweather
- **Weight**: Semi-bold (600)
- **Usage**: Section titles, subheadings

### Body Text
- **Font**: Lato
- **Weights**: Regular (400), Semi-bold (600)
- **Usage**: Paragraphs, buttons, general content

## How to Use

### Accessing Colors
```dart
import 'package:portfolio/core/constants/app_colors.dart';

// Primary colors
AppColors.primary
AppColors.secondary
AppColors.accent

// Background colors
AppColors.background
AppColors.surface
AppColors.card

// Text colors
AppColors.textPrimary
AppColors.textSecondary
AppColors.textTertiary

// Gradients
AppColors.primaryGradient
AppColors.secondaryGradient
AppColors.warmGradient
```

### Using Theme
```dart
// The theme is automatically applied in main.dart
// Access theme properties in any widget:
Theme.of(context).textTheme.displayLarge
Theme.of(context).colorScheme.primary
Theme.of(context).cardTheme
```

## Design Philosophy

The chocolate brown and beige color scheme creates a:
- ✨ Warm and inviting atmosphere
- 🎯 Professional yet approachable feel
- 📱 Elegant and timeless design
- 💼 Perfect for a portfolio showcasing creativity and professionalism

The combination of serif fonts (Playfair Display, Merriweather) for headings and sans-serif (Lato) for body text creates visual hierarchy and readability.
