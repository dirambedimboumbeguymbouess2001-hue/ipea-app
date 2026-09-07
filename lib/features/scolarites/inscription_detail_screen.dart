import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_state.dart';
import '../../../shared/widgets/loading_skeleton.dart';
import 'data/scolarite_models.dart';
import 'data/scolarite_repository.dart';

/// Écran affichant le détail d'une inscription : la liste de ses modules
/// (nom, note, crédits) ainsi que la moyenne et le total de crédits.
///
/// Remplace l'ancien `semestre_detail_screen.dart` : ici il n'y a plus de
/// niveau "classe" en préfixe du titre, uniquement le libellé de
/// l'inscription elle-même (structure de tableau identique à l'ancien écran).
class InscriptionDetailScreen extends StatefulWidget {
  const InscriptionDetailScreen({super.key, required this.inscriptionId});

  final String inscriptionId;

  @override
  State<InscriptionDetailScreen> createState() =>
      _InscriptionDetailScreenState();
}

class _InscriptionDetailScreenState extends State<InscriptionDetailScreen> {
  final ScolariteRepository _repository = ScolariteRepository();

  late Future<List<Module>> _futureModules;

  @override
  void initState() {
    super.initState();
    _futureModules = _repository.obtenirModules(widget.inscriptionId);
  }

  Future<void> _recharger() async {
    setState(() {
      _futureModules = _repository.obtenirModules(widget.inscriptionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondApplication,
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: FutureBuilder<List<Module>>(
        future: _futureModules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSkeleton();
          }

          if (snapshot.hasError) {
            return ErrorState(
              message: 'Impossible de charger les notes.',
              onRetry: _recharger,
            );
          }

          final modules = snapshot.data ?? const <Module>[];

          if (modules.isEmpty) {
            return const EmptyState(
              icon: Symbols.school_rounded,
              message: "Aucune note n'est disponible pour cette inscription.",
            );
          }

          final moyenne = _repository.calculerMoyenne(modules);
          final totalCredits = _repository.calculerTotalCredits(modules);

          return RefreshIndicator(
            onRefresh: _recharger,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _resume(
                        'Moyenne',
                        moyenne.toStringAsFixed(2),
                        Symbols.emoji_events_rounded,
                      ),
                      _resume(
                        'Total crédits',
                        totalCredits.toString(),
                        Symbols.stacks_rounded,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          );
        },
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
