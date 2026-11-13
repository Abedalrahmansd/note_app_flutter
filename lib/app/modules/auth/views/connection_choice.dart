import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../routes/app_routes.dart';
import '../../notes/bindings.dart';
import '../../notes/views/notes_page.dart';

class ConnectionChoiceScreen extends StatefulWidget {
  const ConnectionChoiceScreen({super.key});

  @override
  State<ConnectionChoiceScreen> createState() => _ConnectionChoiceScreenState();
}

class _ConnectionChoiceScreenState extends State<ConnectionChoiceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Animated header
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/animations/database.json', // Use a cloud/connection animation
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'CS->T_Text'.tr,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'CS->S_Text'.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Animated buttons
              ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  children: [
                    _ConnectionCard(
                      icon: Icons.cloud_off_rounded,
                      title: "CS->Offline_Title".tr,
                      subtitle: "CS->Offline_Subtitle".tr,
                      color: isDark ? Colors.teal.shade300 : Colors.teal,
                      onTap: () => _handleOfflineChoice(),
                    ),
                    const SizedBox(height: 20),
                    _ConnectionCard(
                      icon: Icons.cloud_rounded,
                      title: 'CS->Online_Title'.tr,
                      subtitle: 'CS->Online_Subtitle'.tr,
                      color: isDark
                          ? Colors.blue.shade300
                          : Colors.blue.shade600,
                      onTap: () => _handleOnlineChoice(),
                    ),
                  ],
                ),
              ),
              /*const Spacer(),
              // Footer note
               FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'You can change this later in settings',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ), */
            ],
          ),
        ),
      ),
    );
  }

  void _handleOfflineChoice() async {
    // Handle offline mode selection
    final FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: 'is_offline', value: 'true');
    Get.offAll(
      () => NotesPage(),
      binding: NotesBinding(isOffline: true),
      routeName: AppRoutes.NOTES,
    );
  }

  void _handleOnlineChoice() {
    // Handle online mode selection
    Get.offAllNamed(AppRoutes.LOGIN); // Replace with your online home
  }
}

class _ConnectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ConnectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
