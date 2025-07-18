import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../routes/app_routes.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../services/preferences_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _hasSeenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateNext();
      }
    });

    // Check if user has seen onboarding
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefsService = PreferencesService();
    _hasSeenOnboarding = await prefsService.getHasSeenOnboarding();
  }

  void _navigateNext() {
    if (_hasSeenOnboarding) {
      // If user has seen onboarding, go to login
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      // If user hasn't seen onboarding, show it first
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation
            SizedBox(
              height: 200,
              child: Lottie.asset(
                'assets/animations/eco_loading.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller.duration = composition.duration;
                  _controller.forward();
                },
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            Text(
              'EcoMentor',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
