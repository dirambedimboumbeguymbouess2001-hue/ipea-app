import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import 'data/tableau_de_bord_models.dart';
import 'data/tableau_de_bord_repository.dart';
import '../scolarites/data/scolarite_models.dart';

class TableauDeBordScreen extends StatefulWidget {
  const TableauDeBordScreen({super.key});

  @override
  State<TableauDeBordScreen> createState() => _TableauDeBordScreenState();
}

class _TableauDeBordScreenState extends State<TableauDeBordScreen> {
  final _repository = TableauDeBordRepository();

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
    if (_enErreur) return ErrorState(onRetry: _charger);

    if (_enChargement) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const LoadingSkeleton(height: 40, borderRadius: BorderRadius.all(Radius.circular(8))),
          const SizedBox(height: AppSpacing.md),
          const LoadingSkeleton(height: 80, borderRadius: BorderRadius.all(Radius.circular(12))),
          const SizedBox(height: AppSpacing.md),
          const LoadingSkeleton(height: 100, borderRadius: BorderRadius.all(Radius.circular(12))),
          const SizedBox(height: AppSpacing.md),
          const LoadingSkeleton(height: 120, borderRadius: BorderRadius.all(Radius.circular(12))),
        ],
      );
    }

    final donnees = _donnees!;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Bonjour, ${donnees.prenomEtudiant}', style: AppTypography.h2),
            ),
            Tooltip(
              message: donnees.boursier ? 'Étudiant boursier' : 'Étudiant non boursier',
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: donnees.boursier ? AppColors.or : AppColors.grisMoyen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.workspace_premium_rounded, size: 18, color: AppColors.marine),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Carte scolarité/paiement — s'adapte si l'étudiant est boursier
        // (voir la règle dans tableau_de_bord_repository.dart)
        AppCard(
          backgroundColor: donnees.boursier ? AppColors.succes.withValues(alpha: 0.08) : null,
          child: Row(
            children: [
              Icon(
                donnees.boursier ? Symbols.check_circle_rounded : Symbols.payments_rounded,
                color: donnees.boursier ? AppColors.succes : AppColors.marine,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donnees.boursier ? 'Scolarité prise en charge' : 'Reste à payer',
                      style: AppTypography.bodySmall.copyWith(
                        color: donnees.boursier ? AppColors.succes : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      donnees.boursier ? 'Bourse IPEA' : '${donnees.resteAPayer} FCFA',
                      style: AppTypography.h3.copyWith(
                        color: donnees.boursier ? AppColors.succes : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        Text('Ma scolarité', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          onTap: donnees.scolariteId == null
              ? null
              : () => context.push(
                    '/scolarites/${donnees.scolariteId}',
                    extra: Inscription(
                      id: donnees.scolariteId!,
                      idClasse: '',
                      libelle: donnees.scolariteNom,
                      code: donnees.scolariteCode,
                    ),
                  ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(donnees.scolariteNom, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  if (donnees.scolariteCode.isNotEmpty)
                    Text(donnees.scolariteCode, style: AppTypography.bodySmall),
                ],
              ),
              if (donnees.scolariteId != null)
                const Icon(Symbols.chevron_right_rounded, color: AppColors.grisMoyen),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        Row(
          children: [
            Text('Annonces', style: AppTypography.h3),
            const SizedBox(width: AppSpacing.xs),
            // Signal discret que cette section reste simulée (aucun
            // endpoint réel n'existe - voir QUESTIONS_API.md, point 6)
            Tooltip(
              message: "Aucun endpoint annonces n'existe encore côté API — contenu simulé",
              child: Icon(Symbols.info_rounded, size: 14, color: AppColors.grisMoyen),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (donnees.annonces.isEmpty)
          Text("Aucune annonce pour le moment.", style: AppTypography.bodySmall)
        else
          ...donnees.annonces.map(
            (annonce) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                child: Row(
                  children: [
                    const Icon(Symbols.campaign_rounded, color: AppColors.marine, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(annonce.titre, style: AppTypography.bodyLarge),
                          Text(annonce.date, style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
