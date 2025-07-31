import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart' as AppPages;
import 'app/routes/app_routes.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: AppRoutes.SPLASH,
    getPages: AppPages.routes,
  ));
}