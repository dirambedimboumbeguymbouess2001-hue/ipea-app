import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

enum StatusType { succes, erreur, avertissement, neutre }

/// Badge de statut réutilisable (ex: "Actif", "En attente", "Impayé").
/// Toujours utiliser ce widget plutôt que de composer un badge à la main,
/// pour garantir une cohérence visuelle des statuts sur toute l'application.
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  ({Color fond, Color texte}) get _couleurs {
    switch (type) {
      case StatusType.succes:
        return (fond: AppColors.succes.withValues(alpha: 0.12), texte: AppColors.succes);
      case StatusType.erreur:
        return (fond: AppColors.erreur.withValues(alpha: 0.12), texte: AppColors.erreur);
      case StatusType.avertissement:
        // Utilise orFonce plutôt que l'or standard, pour garantir un
        // contraste suffisant sur fond clair (règle de la charte graphique).
        return (fond: AppColors.avertissement.withValues(alpha: 0.15), texte: AppColors.orFonce);
      case StatusType.neutre:
        return (fond: AppColors.grisClair, texte: AppColors.grisFonce);
    }
  }

  @override
  Widget build(BuildContext context) {
    final couleurs = _couleurs;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: couleurs.fond,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: couleurs.texte,
        ),
      ),
    );
  }
}
