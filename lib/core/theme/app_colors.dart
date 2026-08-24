import 'package:flutter/material.dart';

/// Palette de couleurs officielle de l'identité IPEA, conforme au document
/// BTS-CG-2026-01. Toute couleur utilisée dans l'application doit provenir
/// de cette classe — aucune valeur hexadécimale ne doit être codée en dur
/// ailleurs. Aucune couleur hors de cette palette n'est autorisée.
class AppColors {
  AppColors._();

  // --- Couleurs de marque ---
  static const Color marine = Color(0xFF00256B); // Primaire — Marine IPEA
  static const Color marineClair = Color(0xFF1B4FA8); // Primaire clair
  static const Color marineTresClair = Color(0xFFE6EDF8); // Primaire très clair
  static const Color or = Color(0xFFEDD046); // Accent — Or IPEA

  // Règle impérative de la charte : l'or standard n'a pas assez de
  // contraste sur fond blanc. Toujours utiliser orFonce pour du texte
  // ou une icône posée sur fond clair.
  static const Color orFonce = Color(0xFF8A6D00);

  // --- Couleurs neutres ---
  static const Color fondApplication = Color(0xFFF6F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color bordure = Color(0xFFE2E6EC);
  static const Color texteFPrincipal = Color(0xFF101828);
  static const Color texteSecondaire = Color(0xFF5B6472);
  static const Color texteDesactive = Color(0xFF9AA3B0);

  // Alias conservés pour compatibilité avec le code déjà écrit
  static const Color blanc = surface;
  static const Color noir = texteFPrincipal;
  static const Color grisClair = fondApplication;
  static const Color grisMoyen = texteDesactive;
  static const Color grisFonce = texteFPrincipal;

  // --- Couleurs fonctionnelles ---
  static const Color succes = Color(0xFF16A34A);
  static const Color avertissement = Color(0xFFD97706); // "Alerte" dans la charte
  static const Color erreur = Color(0xFFDC2626);
  static const Color information = Color(0xFF1B4FA8);
}
