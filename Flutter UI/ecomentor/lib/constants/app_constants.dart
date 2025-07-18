class AppConstants {
  // App Info
  static const String appName = 'EcoMentor';
  static const String appVersion = '1.0.0';

  // API Endpoints (to be filled later)
  static const String baseUrl = 'https://api.ecomentor.com'; // Example URL

  // Asset Paths
  static const String imagePath = 'assets/images';
  static const String iconPath = 'assets/icons';

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Padding and Margins
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Border Radius
  static const double defaultBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  static const double roundedBorderRadius = 24.0;

  // Screen Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Cache Keys
  static const String userCacheKey = 'user_cache';
  static const String themeCacheKey = 'theme_cache';

  // Default Values
  static const int defaultPageSize = 10;
  static const Duration cacheTimeout = Duration(days: 7);
}
