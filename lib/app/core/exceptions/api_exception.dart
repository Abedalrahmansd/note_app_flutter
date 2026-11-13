import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Turns a failed [Response] into a message the user can read.
///
/// Understands the usual Laravel shapes: `{ "message": "..." }` and
/// `{ "message": "...", "errors": { "field": ["first problem", ...] } }`.
String apiErrorMessage(Response res, {String? fallback}) {
  // No status code means the request never reached the server (offline, DNS,
  // timeout, TLS).
  if (res.statusCode == null) return 'Api->No_Connection'.tr;

  final body = res.body;
  if (body is Map) {
    final errors = body['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
      if (first != null) return first.toString();
    }
    final message = body['message'];
    if (message is String && message.isNotEmpty) return message;
  }
  if (res.statusCode == 401) return 'Api->Session_Expired'.tr;
  return fallback ?? 'Api->Error_Generic'.tr;
}

/// Shows [message] as a snackbar. Does nothing when no UI is running yet
/// (start-up, unit tests), so callers do not need to check.
void showApiMessage(String message, {bool isError = true}) {
  if (Get.overlayContext == null) return;
  Get.snackbar(
    '',
    message,
    titleText: const SizedBox.shrink(),
    backgroundColor: isError ? const Color(0xFFE94F37) : const Color(0xFF4CAF50),
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 8,
    duration: const Duration(seconds: 3),
  );
}

void showApiError(Response res, {String? fallback}) =>
    showApiMessage(apiErrorMessage(res, fallback: fallback));
