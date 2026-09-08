import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/app_card.dart';
import 'data/scolarite_models.dart';
import 'data/scolarite_repository.dart';

/// Écran affichant le détail des modules d'UN SEUL semestre (atteint en
/// tapant un semestre depuis inscription_detail_screen.dart). Les
/// modules sont déjà chargés par l'écran parent - pas de nouvel appel
/// réseau ici.
class SemestreModulesScreen extends StatelessWidget {
  const SemestreModulesScreen({
    super.key,
    required this.inscription,
    required this.semestre,
    required this.modules,
  });

  final Inscription inscription;
  final int semestre;
  final List<Module> modules;

  @override
  Widget build(BuildContext context) {
    final repository = ScolariteRepository();
    final moyenne = repository.calculerMoyenne(modules);
    final totalCredits = repository.calculerTotalCredits(modules);

    return Scaffold(
      backgroundColor: AppColors.fondApplication,
      appBar: AppBar(title: Text('Semestre $semestre')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(inscription.libelle, style: AppTypography.h3),
          Text(inscription.code, style: AppTypography.libelle),
          const SizedBox(height: AppSpacing.lg),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _enTeteTableau(),
                const Divider(height: AppSpacing.lg),
                for (final module in modules) ...[
                  _ligneModule(module),
                  const Divider(height: AppSpacing.md),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          AppCard(
            backgroundColor: AppColors.marineTresClair,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _resume('Moyenne', moyenne.toStringAsFixed(2), Symbols.emoji_events_rounded),
                _resume('Crédits', totalCredits.toString(), Symbols.stacks_rounded),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _enTeteTableau() {
    final style = AppTypography.libelle.copyWith(fontWeight: FontWeight.w600);
    return Row(
      children: [
        Expanded(flex: 3, child: Text('Module', style: style)),
        Expanded(
          child: Text('Note', textAlign: TextAlign.center, style: style),
        ),
        Expanded(
          child: Text('Crédits', textAlign: TextAlign.center, style: style),
        ),
      ],
    );
  }

  Widget _ligneModule(Module module) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(module.nom, style: AppTypography.bodyLarge),
          ),
          Expanded(
            child: Text(
              module.note.toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge,
            ),
          ),
          Expanded(
            child: Text(
              module.credits.toString(),
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resume(String libelle, String valeur, IconData icone) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, color: AppColors.orFonce),
        const SizedBox(height: AppSpacing.xs),
        Text(valeur, style: AppTypography.h2),
        Text(libelle, style: AppTypography.libelle),
      ],
    );
  }
}
