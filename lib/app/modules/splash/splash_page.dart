import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () => Get.offNamed(AppRoutes.LOGIN));
    return Scaffold(body: Center(child: Text('Splash')));
  }
}