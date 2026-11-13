import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/theme_controller.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_components.dart';

class RegisterPage extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Register->Title_Text'.tr,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Register->Subtitle_Text'.tr,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  AuthTextField(
                    label: 'Global->Full_Name'.tr,
                    onChanged: (v) => controller.name.value = v,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: 'Auth->Email'.tr,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (v) => controller.email.value = v,
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: 'Auth->Password'.tr,
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
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: 'Auth->Confirm_Password'.tr,
                    obscureText: controller.obscureConfirmPassword.value,
                    onChanged: (v) => controller.confirmPassword.value = v,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureConfirmPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: theme.hintColor,
                      ),
                      onPressed: () {
                        controller.obscureConfirmPassword.value =
                            !controller.obscureConfirmPassword.value;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => AuthButton(
                      text: 'Global->Create'.tr,
                      onPressed: controller.register,
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                  const SizedBox(height: 24),
                  /*  Center(
                    child: Text(
                      'OR',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), 
                   OutlinedButton.icon(
                    onPressed: () {}, // Add Google signup
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: theme.dividerColor),
                    ),
                    icon: Image.asset(
                      'assets/images/google.png',
                      width: 24,
                      height: 24,
                    ),
                    label: Text(
                      'Continue with Google',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 40), */
                  Center(
                    child: TextButton(
                      onPressed: () {
                        controller.obscurePassword.value = true;
                        controller.obscureConfirmPassword.value = true;
                        Get.back();
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Auth->Have_Account'.tr,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.hintColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'Auth->Login'.tr,
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
