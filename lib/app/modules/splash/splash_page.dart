import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/helpers/auth_helper.dart';
import '../../routes/app_routes.dart';

class SplashPage extends StatelessWidget {
  void checkAuth() async {
    final loggedIn = await isLoggedIn();
    if (loggedIn) {
      Get.offAllNamed(AppRoutes.NOTES);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), checkAuth);
    return Scaffold(body: Center(child: Text('Splash')));
  }
}
