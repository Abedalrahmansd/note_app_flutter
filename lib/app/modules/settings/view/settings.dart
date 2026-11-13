import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/theme/theme_controller.dart';

import '../../../../theme/app_theme.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../notes/views/widgets/delete_dialog.dart';

class SettingsController extends GetxController {
  final ThemeController themeController = Get.find<ThemeController>();
  late Box settingsBox;

  Rx<ThemeMode> get themeMode => themeController.themeMode;

  var notificationsEnabled = true.obs;
  var language = "ar".obs;

  @override
  void onInit() {
    super.onInit();
    settingsBox = Hive.box('settings');

    // Load saved settings
    String storedThemeMode = settingsBox.get(
      'themeMode',
      defaultValue: 'system',
    );
    themeController.setThemeMode(
      ThemeMode.values.firstWhere(
        (e) => e.name == storedThemeMode,
        orElse: () => ThemeMode.system,
      ),
    );

    notificationsEnabled.value = settingsBox.get(
      'notificationsEnabled',
      defaultValue: true,
    );
    language.value = settingsBox.get('language', defaultValue: "ar");
  }

  void toggleThemeMode(ThemeMode? value) async {
    if (value != null) {
      await settingsBox.put('themeMode', value.name);
      themeController.setThemeMode(value);
    }
  }

  // Other methods remain the same
  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    settingsBox.put('notificationsEnabled', value);
  }

  void changeLanguage(String? value) {
    if (value != null) {
      language.value = value;
      settingsBox.put('language', value);
      Get.updateLocale(Locale(value));
      // Update text direction
      
    }
  }
}

class SettingsPage extends GetView<SettingsController> {
  // final SettingsController controller = Get.put(SettingsController());
  final themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = themeController.currentTheme.value;
      return Theme(
        data: theme,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(title: Text('Settings->Title_Text'.tr)),
            body: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  /*  Obx(
                      () => ListTile(
                        title: Text('وضع السمة'),
                        subtitle: Text(
                          controller.themeLabels[controller.themeMode.value] ?? '',
                        ),
                        trailing: DropdownButton<String>(
                          value: controller.themeMode.value,
                          items: [
                            DropdownMenuItem(
                              value: "high_contrast_light",
                              child: Text("تباين خفيف"),
                            ),
                            DropdownMenuItem(value: "light", child: Text("خفيف")),
                            DropdownMenuItem(value: "auto", child: Text("تلقائي")),
                            DropdownMenuItem(value: "dark", child: Text("داكن")),
                            DropdownMenuItem(
                              value: "high_contrast_dark",
                              child: Text("تباين داكن"),
                            ),
                          ],
                          onChanged: controller.toggleThemeMode,
                        ),
                      ),
                    ), */
                  SizedBox(height: 1),
                  Obx(
                    () => ListTile(
                      title: Text('Settings->Theme_Mode'.tr),
                      // subtitle: Text(controller.themeMode.value),
                      trailing: DropdownButton<ThemeMode>(
                        value: controller.themeMode.value,
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text("Global->Light".tr),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text("Global->Auto".tr),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text("Global->Dark".tr),
                          ),
                        ],
                        onChanged: controller.toggleThemeMode,
                      ),
                    ),
                  ),
                  SizedBox(height: 1),
                  Obx(
                    () => ListTile(
                      title: Text('Global->Language'.tr),
                      // subtitle: Text(
                      //   controller.languageLabels[controller.language.value] ?? '',
                      // ),
                      trailing: DropdownButton<String>(
                        value: controller.language.value,
                        items: [
                          DropdownMenuItem(
                            value: "ar",
                            child: Text("Global->Arabic".tr),
                          ),
                          DropdownMenuItem(
                            value: "en",
                            child: Text("Global->English".tr),
                          ),
                        ],
                        onChanged: controller.changeLanguage,
                      ),
                    ),
                  ),
                  SizedBox(height: 1),
                  Obx(
                    () => SwitchListTile(
                      title: Text('Settings->Enable_Notifications'.tr),
                      value: controller.notificationsEnabled.value,
                      onChanged: controller.toggleNotifications,
                    ),
                  ),

                  /* Obx(
                      () => ListTile(
                        title: Text('حجم الخط'),
                        subtitle: Text('${controller.fontSize.value}'),
                        trailing: DropdownButton<double>(
                          value: controller.fontSize.value,
                          items: [
                            DropdownMenuItem(value: 12.0, child: Text("12")),
                            DropdownMenuItem(value: 14.0, child: Text("14")),
                            DropdownMenuItem(value: 16.0, child: Text("16")),
                            DropdownMenuItem(value: 18.0, child: Text("18")),
                          ],
                          onChanged: controller.changeFontSize,
                        ),
                      ),
                    ), */
                  //logout button
                  SizedBox(height: 20),
                  ListTile(
                    trailing: Icon(Icons.logout, color: AppPalette.errorRed),
                    title: Text(
                      'Auth->Logout'.tr,
                      style: TextStyle(color: AppPalette.errorRed),
                    ),
                    onTap: () async {
                      final result = await Get.dialog(
                        ConfirmationDialog(
                          title: 'Auth->Logout'.tr,
                          description: 'Auth->Logout_Confirm_Title'.tr,
                          confirmButtonBackgroundColor: AppPalette.errorRed,
                          confirmText: 'Global->Confirm'.tr,
                          theme: themeController.currentTheme.value,
                        ),
                      );
                      if (result ?? false) {
                        Get.find<AuthController>().logout();
                      }
                    },
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
