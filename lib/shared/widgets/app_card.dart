import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Carte standard de l'application. Toujours utiliser ce widget plutôt
/// qu'un Container/Card nu, pour garantir un style uniforme (arrondi,
/// bordure, ombre légère, padding) sur tous les blocs de contenu.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final contenu = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.blanc,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.bordure, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.noir.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return contenu;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: contenu,
    );
  }
}
