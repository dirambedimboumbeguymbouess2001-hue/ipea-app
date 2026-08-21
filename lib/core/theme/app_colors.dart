import 'package:flutter/material.dart';

/// Palette de couleurs officielle de l'identité IPEA.
/// Toute couleur utilisée dans l'application doit provenir de cette classe —
/// aucune valeur hexadécimale ne doit être codée en dur ailleurs.
class AppColors {
  AppColors._(); // Empêche l'instanciation, cette classe est un simple conteneur de constantes

  // Couleurs de marque
  static const Color marine = Color(0xFF00256B);
  static const Color or = Color(0xFFEDD046);

  // Variante foncée de l'or, à utiliser pour tout texte ou icône
  // sur fond clair (l'or standard n'offre pas assez de contraste).
  static const Color orFonce = Color(0xFF8A6D00);

  // Couleurs neutres
  static const Color blanc = Color(0xFFFFFFFF);
  static const Color noir = Color(0xFF000000);
  static const Color grisClair = Color(0xFFF5F5F5);
  static const Color grisMoyen = Color(0xFF9E9E9E);
  static const Color grisFonce = Color(0xFF424242);

  // Couleurs sémantiques (succès, erreur, avertissement)
  static const Color succes = Color(0xFF2E7D32);
  static const Color erreur = Color(0xFFC62828);
  static const Color avertissement = Color(0xFFF9A825);
}
