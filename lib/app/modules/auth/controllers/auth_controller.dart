import 'package:get/get.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/note_provider.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;

  final AuthProvider provider = AuthProvider();

  void login() async {
    isLoading.value = true;
    final res = await provider.login(email.value, password.value);
    isLoading.value = false;
    if (res.isOk) {
      Get.offAllNamed(AppRoutes.NOTES);
    } else {
      Get.snackbar('Login Failed', res.statusText ?? 'Error');
    }
  }
}