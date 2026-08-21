/// Espacements et rayons de bordure standardisés de l'application.
/// Utiliser ces constantes plutôt que des valeurs numériques codées
/// en dur, pour garantir une cohérence visuelle sur tous les écrans.
class AppSpacing {
  AppSpacing._();

  // Espacements (padding, margin, gap)
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Rayons de bordure (cards, boutons, champs de texte)
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusFull = 999; // pour les éléments parfaitement arrondis
}
