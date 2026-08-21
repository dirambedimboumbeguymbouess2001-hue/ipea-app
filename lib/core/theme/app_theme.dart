import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Thème Material 3 complet de l'application, assemblé à partir
/// des couleurs, typographies et espacements définis dans ce dossier.
/// C'est ce thème qui doit être passé à MaterialApp — aucun widget
/// ne doit redéfinir ses propres couleurs ou styles de texte.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.blanc,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.marine,
        primary: AppColors.marine,
        secondary: AppColors.orFonce,
        error: AppColors.erreur,
        brightness: Brightness.light,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.marine,
        foregroundColor: AppColors.blanc,
        elevation: 0,
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.blanc),
      ),

      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.marine,
          foregroundColor: AppColors.blanc,
          textStyle: AppTypography.bouton,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
      ),

      // Champs de texte
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grisClair,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),

      // Cartes
      cardTheme: CardThemeData(
        color: AppColors.blanc,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
      ),

      // Typographie par défaut du thème (fallback)
      textTheme: TextTheme(
        headlineLarge: AppTypography.h1,
        headlineMedium: AppTypography.h2,
        headlineSmall: AppTypography.h3,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.bouton,
        labelSmall: AppTypography.libelle,
      ),
    );
  }
}
