import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/translations.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';

import 'app/data/helpers/global_bindings.dart';
import 'app/data/models/note_model.dart';
import 'app/routes/app_pages.dart' as AppPages;
import 'app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>('offline_notes');
  await AssetLottie('assets/animations/notebook.json').load();
  Box settingsBox = await Hive.openBox('settings');
  String langCode = settingsBox
      .get('language', defaultValue: "ar_PS")
      .split('_')[0];
  runApp(
    GetMaterialApp(
      locale: Locale(langCode),
      translations: AppTranslations(),
      /* textDirection: langCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr, */
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
      initialBinding: GlobalBinding(),
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      title: 'Notes',
      builder: (context, child) {
        // Use current Get.locale (updates when you call Get.updateLocale)
        final currentCode = Get.locale?.languageCode ?? langCode;
        return Directionality(
          textDirection: _isRtlLanguage(currentCode)
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
    ),
  );
}

bool _isRtlLanguage(String code) {
  final rtlLanguages = <String>['ar', 'fa', 'he', 'ur', 'ps', 'ku'];
  return rtlLanguages.contains(code.toLowerCase());
}
