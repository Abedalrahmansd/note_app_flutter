//a function that returns a suitable textDirection based on a variable text
import 'package:flutter/material.dart';

TextDirection autoTextDirection(String text) {
  final arabicRegex = RegExp(r'[\u0600-\u06FF]');
  if (arabicRegex.hasMatch(text)) {
    return TextDirection.rtl;
  } else {
    return TextDirection.ltr;
  }
}