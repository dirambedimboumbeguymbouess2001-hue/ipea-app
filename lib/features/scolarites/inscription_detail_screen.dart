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
import 'semestre_modules_screen.dart';

/// Écran affichant le détail d'une inscription : une liste de semestres
/// cliquables (règle IPEA : L1 -> S1/S2, L2 -> S3/S4, L3 -> S5/S6), avec
/// un résumé (moyenne, crédits) par semestre. Taper un semestre ouvre le
/// détail de ses modules (voir semestre_modules_screen.dart).
///
/// [inscription] est optionnelle : si elle est fournie (transmise par
/// l'écran appelant via `extra`), on évite un appel réseau superflu pour
/// connaître son code. Si absente (ex. accès direct à l'URL), l'écran la
/// retrouve lui-même via la liste des inscriptions.
class InscriptionDetailScreen extends StatefulWidget {
  const InscriptionDetailScreen({
    super.key,
    required this.inscriptionId,
    this.inscription,
  });

  final String inscriptionId;
  final Inscription? inscription;

  @override
  State<InscriptionDetailScreen> createState() =>
      _InscriptionDetailScreenState();
}

class _InscriptionDetailScreenState extends State<InscriptionDetailScreen> {
  final ScolariteRepository _repository = ScolariteRepository();

  late Future<(Inscription, List<Module>)> _futureDonnees;

  @override
  void initState() {
    super.initState();
    _futureDonnees = _charger();
  }

  Future<(Inscription, List<Module>)> _charger() async {
    var inscription = widget.inscription;

    if (inscription == null) {
      final inscriptions = await _repository.obtenirInscriptions();
      inscription = inscriptions.firstWhere(
        (i) => i.id == widget.inscriptionId,
        orElse: () => throw Exception('Inscription introuvable'),
      );
    }

    final (premier, second) = _repository.semestresPourNiveau(inscription.code);
    final modules = await _repository.obtenirModules(
      widget.inscriptionId,
      premierSemestre: premier,
      deuxiemeSemestre: second,
    );

    return (inscription, modules);
  }

  Future<void> _recharger() async {
    setState(() {
      _futureDonnees = _charger();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondApplication,
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: FutureBuilder<(Inscription, List<Module>)>(
        future: _futureDonnees,
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

          final (inscription, modules) = snapshot.data!;

          if (modules.isEmpty) {
            return const EmptyState(
              icon: Symbols.school_rounded,
              message: "Aucune note n'est disponible pour cette inscription.",
            );
          }

          final semestres = modules.map((m) => m.semestre).toSet().toList()..sort();
          final moyenneGenerale = _repository.calculerMoyenne(modules);
          final totalCreditsGeneral = _repository.calculerTotalCredits(modules);

          return RefreshIndicator(
            onRefresh: _recharger,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text(inscription.libelle, style: AppTypography.h2),
                Text(inscription.code, style: AppTypography.libelle),
                const SizedBox(height: AppSpacing.lg),

                for (final semestre in semestres) ...[
                  _carteSemestre(
                    context,
                    inscription,
                    semestre,
                    modules.where((m) => m.semestre == semestre).toList(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                const SizedBox(height: AppSpacing.md),

                AppCard(
                  backgroundColor: AppColors.marineTresClair,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _resume('Moyenne générale', moyenneGenerale.toStringAsFixed(2), Symbols.emoji_events_rounded),
                      _resume('Total crédits', totalCreditsGeneral.toString(), Symbols.stacks_rounded),
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

  Widget _carteSemestre(
    BuildContext context,
    Inscription inscription,
    int semestre,
    List<Module> modulesDuSemestre,
  ) {
    final moyenne = _repository.calculerMoyenne(modulesDuSemestre);
    final totalCredits = _repository.calculerTotalCredits(modulesDuSemestre);

    return AppCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SemestreModulesScreen(
              inscription: inscription,
              semestre: semestre,
              modules: modulesDuSemestre,
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Semestre $semestre', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              Text(
                'Moy. ${moyenne.toStringAsFixed(2)} · $totalCredits crédits · ${modulesDuSemestre.length} modules',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          const Icon(Symbols.chevron_right_rounded, color: AppColors.grisMoyen),
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
