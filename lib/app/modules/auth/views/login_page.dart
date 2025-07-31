import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(onChanged: (v) => controller.email.value = v),
          TextField(onChanged: (v) => controller.password.value = v),
          ElevatedButton(
            onPressed: controller.login,
            child: Obx(() => controller.isLoading.value ? CircularProgressIndicator() : Text('Login')),
          ),
        ],
      ),
    );
  }
}