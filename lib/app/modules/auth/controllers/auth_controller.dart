import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_routes.dart';
import '../../notes/controllers/note_controller.dart';

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
      provider.saveToken(res.body['access_token']);
      Get.snackbar('Login Successful', 'Welcome back!');
      Get.offAllNamed(AppRoutes.NOTES);
    } else {
      Get.snackbar('Login Failed', res.statusText ?? 'Error');
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
      Get.snackbar('Registration Successful', 'You can now log in!');
      Get.offAllNamed(AppRoutes.LOGIN);
    } else {
      Get.snackbar('Registration Failed', res.statusText ?? 'Error');
    }
  }

  void logout() async {
    await provider.logout().then((response) async {
      if (response.isOk) {
        await provider.clearToken();
        // Navigate to login page
        Get.offAllNamed(AppRoutes.LOGIN);
        //delete note controller
        Get.delete<NoteController>(force: true);
        Get.snackbar('Logged Out', 'You have been logged out successfully.');
      } else {
        Get.snackbar('Logout Failed', response.statusText ?? 'Error');
      }
    });
  }
}
