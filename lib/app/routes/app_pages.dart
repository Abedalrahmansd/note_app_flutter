import 'package:get/get.dart';

import '../modules/auth/views/connection_choice.dart';
import '../modules/auth/views/login_page.dart';
import '../modules/auth/views/register_page.dart';
import '../modules/notes/views/notes_page.dart';
import '../modules/splash/splash_page.dart';
import 'app_routes.dart';

final routes = [
  GetPage(name: AppRoutes.SPLASH, page: () => SplashScreen()),
  GetPage(
    name: AppRoutes.CONNECTION_CHOICE,
    page: () => ConnectionChoiceScreen(),
    // binding: AuthBinding(),
  ),
  GetPage(
    name: AppRoutes.LOGIN,
    page: () => LoginPage(),
    // binding: AuthBinding(),
  ),
  GetPage(
    name: AppRoutes.REGISTER,
    page: () => RegisterPage(),
    // binding: AuthBinding(),
  ),
  GetPage(
    name: AppRoutes.NOTES,
    page: () => NotesPage(),
    // binding: NotesBinding(),
  ),
];
