import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:note_app/app/modules/notes/controllers/implementations/i_note_controller.dart';
import '../../../data/helpers/auth_helper.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  final AuthProvider provider = AuthProvider();

  void login() async {
    isLoading.value = true;
    final res = await provider.login(email.value, password.value);
    isLoading.value = false;
    if (res.isOk) {
      await provider.saveToken(res.body['access_token']);
      final FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.write(key: 'is_offline', value: 'false');
      //Get.snackbar('Login Successful', 'Welcome back!');
      checkAuth();
    } else {
      //Get.snackbar('Login Failed', res.statusText ?? 'Error');
    }
  }

  void register() async {
    isLoading.value = true;
    final res = await provider.register(
      name.value,
      email.value,
      password.value,
      confirmPassword.value,
    );
    isLoading.value = false;
    if (res.isOk) {
      //Get.snackbar('Registration Successful', 'You can now log in!');
      Get.offAllNamed(AppRoutes.LOGIN);
    } else {
      //Get.snackbar('Registration Failed', res.statusText ?? 'Error');
    }
  }

  void logout() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    await provider.clearToken();
    await storage.write(key: 'is_offline', value: 'false');
    provider.logout();
    // Navigate to login page
    Get.offAllNamed(AppRoutes.CONNECTION_CHOICE);
    //delete note controller
    Get.delete<INoteController>(force: true);
    //Get.snackbar('Logged Out', 'You have been logged out successfully.');

    // //Get.snackbar('Logout Failed', response.statusText ?? 'Error');
  }
}
