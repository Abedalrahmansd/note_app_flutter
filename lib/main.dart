import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/theme/app_theme.dart';
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
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
      initialBinding: GlobalBinding(),
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      title: 'Notes',
    ),
  );
}
