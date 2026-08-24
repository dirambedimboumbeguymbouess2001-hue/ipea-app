/// Espacements et rayons de bordure, conformes à la section 5 de la
/// charte graphique (BTS-CG-2026-01). Toutes les valeurs dérivent d'une
/// base de 8 points. Utiliser ces constantes plutôt que des valeurs
/// numériques codées en dur.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  // Conservé pour compatibilité avec le code déjà écrit (non prévu par
  // la charte, mais utile ponctuellement pour des respirations plus
  // marquées — ex: écran de démarrage).
  static const double xxl = 48;

  static const double radiusSmall = 8; // badges, puces de statut
  static const double radiusMedium = 12; // champs de saisie, boutons
  static const double radiusLarge = 16; // cartes, feuilles modales
  static const double radiusFull = 999;
}
