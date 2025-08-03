import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/app/routes/app_routes.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/theme_controller.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_components.dart';

class LoginPage extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final theme = themeController.currentTheme.value;

      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Welcome Back',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login to continue your notes journey',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AuthTextField(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (v) => controller.email.value = v,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: 'Password',
                    obscureText: controller.obscurePassword.value,
                    onChanged: (v) => controller.password.value = v,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: theme.hintColor,
                      ),
                      onPressed: () {
                        controller.obscurePassword.value =
                            !controller.obscurePassword.value;
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {}, // Add forgot password
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppPalette.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => AuthButton(
                      text: 'Login',
                      onPressed: controller.login,
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                  const SizedBox(height: 24),
                  /* Center(
                    child: Text(
                      'OR',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {}, // Add Google login
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: theme.dividerColor),
                    ),
                    icon: Icon(Icons.login, color: theme.hintColor),
                    // You can replace this with an actual Google icon

                    /* Image.asset(
                      'assets/images/google.png',
                      width: 24,
                      height: 24,
                    ), */
                    label: Text(
                      'Continue with Google',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 40),*/
                  Center(
                    child: TextButton(
                      onPressed: () {
                        controller.obscurePassword.value = true;
                        controller.obscureConfirmPassword.value = true;
                        Get.toNamed(AppRoutes.REGISTER);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.hintColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'Register',
                              style: TextStyle(
                                color: AppPalette.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
