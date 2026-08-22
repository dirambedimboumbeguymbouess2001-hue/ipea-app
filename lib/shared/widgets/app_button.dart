import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

enum AppButtonVariant { primaire, secondaire }

/// Bouton standard de l'application. Toujours utiliser ce widget plutôt
/// qu'un ElevatedButton/OutlinedButton nu, pour garantir un style uniforme
/// sur tous les écrans (couleurs, arrondis, état de chargement).
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primaire,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final estPrimaire = variant == AppButtonVariant.primaire;

    final enfant = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                estPrimaire ? AppColors.blanc : AppColors.marine,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label, style: AppTypography.bouton.copyWith(
                color: estPrimaire ? AppColors.blanc : AppColors.marine,
              )),
            ],
          );

    // isLoading désactive le bouton pour éviter les double-soumissions
    final onTap = isLoading ? null : onPressed;

    if (estPrimaire) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.marine,
            disabledBackgroundColor: AppColors.marine.withValues(alpha: 0.5),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
          ),
          child: enfant,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.marine),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
        child: enfant,
      ),
    );
  }
}
