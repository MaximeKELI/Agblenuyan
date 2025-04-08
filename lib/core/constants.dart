import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50); // Vert principal
  static const Color primaryDark = Color(0xFF388E3C); // Vert foncé
  static const Color primaryLight = Color(0xFFC8E6C9); // Vert clair
  static const Color accent = Color(0xFF8BC34A); // Vert accent
  static const Color textDark = Color(0xFF212121); // Texte sombre
  static const Color textLight = Color(0xFFF5F5F5); // Texte clair
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    color: AppColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );
}
