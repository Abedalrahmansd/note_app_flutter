import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../theme/theme_controller.dart';
import '../../data/helpers/auth_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  final ThemeController _themeController = Get.find();


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart),
    );
    _controller.forward();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), checkAuth);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = _themeController.currentTheme.value;

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated notebook icon
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Lottie.asset(
                    'assets/animations/notebook.json', // Replace with your Lottie file
                    controller: _controller,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                /* // App name with gradient
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppPalette.primary,
                      AppPalette.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'Noted',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white, // Color is overridden by shader
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Capture your thoughts',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 50),
                // Loading indicator
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppPalette.primary,
                    ),
                  ),
                ), */
              ],
            ),
          ),
        ),
      );
    });
  }
}
