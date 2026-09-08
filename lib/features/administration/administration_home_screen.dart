import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import 'administration_annonce_screen.dart';
import 'administration_activation_screen.dart';

/// Accueil de l'espace administration : les 2 seules actions demandées
/// (publier une annonce, activer un compte étudiant) - pas de gestion
/// scolaire complète, volontairement.
class AdministrationHomeScreen extends StatelessWidget {
  const AdministrationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grisClair,
      appBar: AppBar(title: const Text('Administration')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AdministrationAnnonceScreen()),
            ),
            child: Row(
              children: [
                const Icon(Symbols.campaign_rounded, color: AppColors.marine, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Publier une annonce', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                      Text('Diffuser une information aux étudiants', style: AppTypography.bodySmall),
                    ],
                  ),
                ),
                const Icon(Symbols.chevron_right_rounded, color: AppColors.grisMoyen),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AdministrationActivationScreen()),
            ),
            child: Row(
              children: [
                const Icon(Symbols.person_check_rounded, color: AppColors.marine, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Activer un compte étudiant', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                      Text('À partir du matricule de l\'étudiant', style: AppTypography.bodySmall),
                    ],
                  ),
                ),
                const Icon(Symbols.chevron_right_rounded, color: AppColors.grisMoyen),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
