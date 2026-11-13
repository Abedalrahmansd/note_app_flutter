import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/notes/views/edit_note_page.dart';
import '../../modules/settings/view/settings.dart';
import '../models/note_model.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;

  SlideRightRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.fastEaseInToSlowEaseOut;
          // const duration = Duration(milliseconds: 650);

          // Create staggered animations
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation);

          final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.3, 1.0, curve: curve),
            ),
          );

          final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 1.0, curve: curve),
            ),
          );

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(scale: scaleAnimation, child: child),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
      );
}

//slideleft route
class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.fastEaseInToSlowEaseOut;

          final offsetAnimation = Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
      );
}

void openNoteEditPage(NoteModel? note) {
  Navigator.of(
    Get.context!,
  ).push(SlideRightRoute(page: NoteEditPage(note: note)));
}

class CustomNavigation {
  static void navigateToSettingsPage() {
    Navigator.of(Get.context!).push(SlideLeftRoute(page: SettingsPage()));
  }
}
