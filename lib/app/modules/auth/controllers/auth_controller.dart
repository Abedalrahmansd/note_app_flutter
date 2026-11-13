import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:notes_app/app/modules/notes/controllers/implementations/i_note_controller.dart';
import '../../../core/exceptions/api_exception.dart';
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
    if (isLoading.value) return;
    final mail = email.value.trim();
    if (mail.isEmpty || password.value.isEmpty) {
      showApiMessage('Auth->Fill_Fields'.tr);
      return;
    }
    isLoading.value = true;
    final res = await provider.login(mail, password.value);
    isLoading.value = false;

    final body = res.body;
    final token = res.isOk && body is Map ? body['access_token'] : null;
    if (token is String && token.isNotEmpty) {
      await provider.saveToken(token);
      final FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.write(key: 'is_offline', value: 'false');
      checkAuth();
    } else {
      Get.snackbar('Auth->Login_Failed'.tr, apiErrorMessage(res));
    }
  }

  void register() async {
    if (isLoading.value) return;
    if (name.value.trim().isEmpty ||
        email.value.trim().isEmpty ||
        password.value.isEmpty) {
      showApiMessage('Auth->Fill_Fields'.tr);
      return;
    }
    if (password.value != confirmPassword.value) {
      showApiMessage('Auth->Passwords_Mismatch'.tr);
      return;
    }
    isLoading.value = true;
    final res = await provider.register(
      name.value.trim(),
      email.value.trim(),
      password.value,
      confirmPassword.value,
    );
    isLoading.value = false;
    if (res.isOk) {
      showApiMessage('Auth->Register_Success'.tr, isError: false);
      Get.offAllNamed(AppRoutes.LOGIN);
    } else {
      Get.snackbar('Auth->Register_Failed'.tr, apiErrorMessage(res));
    }
  }

  void logout() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    // Revoke the token on the server first, while we still have it. Offline
    // mode has no token, so there is nothing to tell the server.
    if ((await provider.getToken()) != null) {
      try {
        await provider.logout().timeout(const Duration(seconds: 5));
      } catch (_) {
        // Never block logging out on a flaky connection.
      }
    }
    await provider.clearToken();
    await storage.write(key: 'is_offline', value: 'false');
    Get.offAllNamed(AppRoutes.CONNECTION_CHOICE);
    // Drop the note controller so the next mode choice starts clean.
    Get.delete<INoteController>(force: true);
  }
}
