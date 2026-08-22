import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import 'data/tableau_de_bord_models.dart';
import 'data/tableau_de_bord_repository.dart';

class TableauDeBordScreen extends StatefulWidget {
  const TableauDeBordScreen({super.key});

  @override
  State<TableauDeBordScreen> createState() => _TableauDeBordScreenState();
}

class _TableauDeBordScreenState extends State<TableauDeBordScreen> {
  final _repository = TableauDeBordRepository();

  // Les 3 états possibles de l'écran : chargement (null + pasErreur),
  // erreur (pasErreur == false), ou succès (donnees != null)
  TableauDeBordData? _donnees;
  bool _enErreur = false;
  bool _enChargement = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() {
      _enChargement = true;
      _enErreur = false;
    });

    try {
      final donnees = await _repository.obtenirDonnees();
      if (!mounted) return;
      setState(() {
        _donnees = donnees;
        _enChargement = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _enErreur = true;
        _enChargement = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grisClair,
      appBar: AppBar(title: const Text('Tableau de bord')),
      body: RefreshIndicator(
        onRefresh: _charger,
        child: _construireContenu(),
      ),
    );
  }

  Widget _construireContenu() {
    // État ERREUR
    if (_enErreur) {
      return ErrorState(onRetry: _charger);
    }

    // État CHARGEMENT — squelettes à la forme du contenu final,
    // jamais de spinner plein écran (règle de la charte graphique)
    if (_enChargement) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const LoadingSkeleton(height: 80, borderRadius: BorderRadius.all(Radius.circular(12))),
          const SizedBox(height: AppSpacing.md),
          const LoadingSkeleton(height: 100, borderRadius: BorderRadius.all(Radius.circular(12))),
          const SizedBox(height: AppSpacing.md),
          const LoadingSkeleton(height: 60, borderRadius: BorderRadius.all(Radius.circular(12))),
        ],
      );
    }

    // État SUCCÈS
    final donnees = _donnees!;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Bonjour, ${donnees.nomEtudiant}', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.md),

        // Cartes statistiques
        Row(
          children: [
            Expanded(
              child: AppCard(
                backgroundColor: AppColors.succes.withValues(alpha: 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Moyenne', style: AppTypography.bodySmall.copyWith(color: AppColors.succes)),
                    const SizedBox(height: 4),
                    Text('${donnees.moyenneGenerale}', style: AppTypography.h2.copyWith(color: AppColors.succes)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reste à payer', style: AppTypography.bodySmall),
                    const SizedBox(height: 4),
                    Text('${donnees.resteAPayer} FCFA', style: AppTypography.h3),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        Text('Ma scolarité', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          onTap: () {}, // sera relié à /scolarites/:id plus tard
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(donnees.scolariteNom, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  Text('Année ${donnees.scolariteAnnee}', style: AppTypography.bodySmall),
                ],
              ),
              StatusBadge(label: donnees.scolariteStatut, type: StatusType.succes),
            ],
          ),
        ),
      ],
    );
  }
}
