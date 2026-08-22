import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import 'app_button.dart';

/// État "erreur" réutilisable — à afficher quand un appel à l'API échoue
/// (pas de réseau, erreur serveur, etc.). Un des 4 états obligatoires
/// imposés par la charte graphique sur tout écran consommant l'API.
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorState({
    super.key,
    this.message = 'Une erreur est survenue. Veuillez réessayer.',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.erreur),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grisFonce),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: 160,
              child: AppButton(
                label: 'Réessayer',
                onPressed: onRetry,
                icon: Icons.refresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
