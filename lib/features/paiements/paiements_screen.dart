import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import 'data/paiements_models.dart';
import 'data/paiements_repository.dart';

class PaiementsScreen extends StatefulWidget {
  const PaiementsScreen({super.key});

  @override
  State<PaiementsScreen> createState() => _PaiementsScreenState();
}

class _PaiementsScreenState extends State<PaiementsScreen> {
  final _repository = PaiementsRepository();

  SituationPaiements? _situation;
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
      final situation = await _repository.obtenirSituation('etu-001');
      if (!mounted) return;
      setState(() {
        _situation = situation;
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

  StatusType _typeSelonStatut(String statut) {
    switch (statut) {
      case 'Payé':
        return StatusType.succes;
      case 'En retard':
        return StatusType.erreur;
      default:
        return StatusType.avertissement;
    }
  }

  String _formaterMontant(int montant) {
    // Ajoute un espace tous les 3 chiffres (ex: 85000 -> "85 000")
    final chaine = montant.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < chaine.length; i++) {
      if (i > 0 && (chaine.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(chaine[i]);
    }
    return '${buffer.toString()} FCFA';
  }

  String _formaterDate(DateTime date) {
    const mois = [
      'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
    ];
    return '${date.day} ${mois[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grisClair,
      appBar: AppBar(title: const Text('Paiements')),
      body: RefreshIndicator(
        onRefresh: _charger,
        child: _construireContenu(),
      ),
    );
  }

  Widget _construireContenu() {
    if (_enErreur) {
      return ErrorState(onRetry: _charger);
    }

    if (_enChargement) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const LoadingSkeleton(height: 130, borderRadius: BorderRadius.all(Radius.circular(12))),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: LoadingSkeleton(height: 60, borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
        ],
      );
    }

    final situation = _situation!;
    final progression = situation.montantPaye / situation.montantTotal;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Résumé avec barre de progression
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reste à payer', style: AppTypography.bodySmall),
              const SizedBox(height: 4),
              Text(
                _formaterMontant(situation.resteAPayer),
                style: AppTypography.h1.copyWith(color: AppColors.marine),
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                child: LinearProgressIndicator(
                  value: progression,
                  minHeight: 8,
                  backgroundColor: AppColors.grisClair,
                  valueColor: const AlwaysStoppedAnimation(AppColors.succes),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_formaterMontant(situation.montantPaye)} payés',
                    style: AppTypography.bodySmall,
                  ),
                  Text(
                    'Total : ${_formaterMontant(situation.montantTotal)}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        Text('Historique', style: AppTypography.h3),
        const SizedBox(height: AppSpacing.sm),
        ...situation.historique.map(
          (paiement) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(paiement.libelle, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                      Text(_formaterDate(paiement.date), style: AppTypography.bodySmall),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_formaterMontant(paiement.montant), style: AppTypography.bodyMedium),
                      const SizedBox(height: 4),
                      StatusBadge(label: paiement.statut, type: _typeSelonStatut(paiement.statut)),
                    ],
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
