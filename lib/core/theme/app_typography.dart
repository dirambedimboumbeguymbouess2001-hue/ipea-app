import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Styles de texte officiels, conformes à l'échelle typographique exacte
/// du document BTS-CG-2026-01 (section 4.1). Poppins pour les titres et
/// le chiffre principal, Inter pour tout le reste. Aucune taille en
/// dessous de 12 sp n'est autorisée par la charte.
class AppTypography {
  AppTypography._();

  /// Display — 32sp Bold — chiffre principal du tableau de bord
  /// (moyenne, solde). Seul usage autorisé par la charte.
  static TextStyle get display => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        color: AppColors.texteFPrincipal,
      );

  /// Titre 1 — 24sp SemiBold — titre d'écran
  static TextStyle get h1 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: AppColors.texteFPrincipal,
      );

  /// Titre 2 — 20sp SemiBold — titre de section
  static TextStyle get h2 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.texteFPrincipal,
      );

  /// Titre 3 — 16sp SemiBold — titre de carte, nom de matière
  static TextStyle get h3 => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        color: AppColors.texteFPrincipal,
      );

  /// Corps — 14sp Regular — texte courant, valeurs
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.texteFPrincipal,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.texteSecondaire,
      );

  /// Légende — 12sp Regular — métadonnées, dates, mentions
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: AppColors.texteSecondaire,
      );

  /// Bouton — 14sp SemiBold — libellés d'actions
  static TextStyle get bouton => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: AppColors.surface,
      );

  static TextStyle get libelle => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: AppColors.texteDesactive,
      );
}
