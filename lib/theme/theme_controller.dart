import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_theme.dart';

class ThemeController extends GetxController with WidgetsBindingObserver {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<Brightness> systemBrightness = Brightness.light.obs;
  final Rx<ThemeData> currentTheme = AppTheme.lightTheme.obs; // Add this line

  @override
  void onInit() {
    super.onInit();
    _initTheme();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    systemBrightness.value = WidgetsBinding.instance.window.platformBrightness;
    if (themeMode.value == ThemeMode.system) {
      _updateTheme();
    }
  }

  void _updateTheme() {
    final newTheme = _getCurrentTheme();
    if (currentTheme.value != newTheme) {
      currentTheme.value = newTheme;
      Get.changeTheme(newTheme);
    }
  }

  ThemeData _getCurrentTheme() {
    if (themeMode.value == ThemeMode.system) {
      return systemBrightness.value == Brightness.dark
          ? AppTheme.darkTheme
          : AppTheme.lightTheme;
    }
    return themeMode.value == ThemeMode.dark
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;
  }

  void _initTheme() {
    systemBrightness.value = WidgetsBinding.instance.window.platformBrightness;
    currentTheme.value = _getCurrentTheme();
    Get.changeTheme(currentTheme.value);
  }

  void toggleTheme() {
    final modes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    final nextIndex = (themeMode.value.index + 1) % modes.length;
    setThemeMode(modes[nextIndex]);
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _updateTheme();
  }

  bool isActiveTheme(ThemeMode mode) => themeMode.value == mode;
}
