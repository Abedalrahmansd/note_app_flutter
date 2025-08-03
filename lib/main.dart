import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/theme/app_theme.dart';

import 'app/data/helpers/global_bindings.dart';
import 'app/routes/app_pages.dart' as AppPages;
import 'app/routes/app_routes.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
      initialBinding: GlobalBinding(),
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    ),
  );
}
