import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import 'data/scolarites_models.dart';
import 'data/scolarites_repository.dart';

class DetailInscriptionScreen extends StatefulWidget {
  final String inscriptionId;

  const DetailInscriptionScreen({super.key, required this.inscriptionId});

  @override
  State<DetailInscriptionScreen> createState() => _DetailInscriptionScreenState();
}

class _DetailInscriptionScreenState extends State<DetailInscriptionScreen> {
  final _repository = ScolaritesRepository();

  Scolarite? _scolarite;
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
      // Pour l'instant, on récupère toute la liste puis on filtre —
      // l'API réelle proposera probablement une route dédiée
      // GET /inscriptions/{id} qui renverra directement le bon élément.
      final toutes = await _repository.obtenirScolarites('etu-001');
      final trouvee = toutes.where((s) => s.id == widget.inscriptionId).firstOrNull;

      if (!mounted) return;
      setState(() {
        _scolarite = trouvee;
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
      case 'Actif':
        return StatusType.succes;
      case 'Suspendu':
        return StatusType.erreur;
      default:
        return StatusType.neutre;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grisClair,
      appBar: AppBar(title: const Text('Détail de l\'inscription')),
      body: _construireContenu(),
    );
  }

  Widget _construireContenu() {
    if (_enErreur) {
      return ErrorState(onRetry: _charger);
    }

    if (_enChargement) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: LoadingSkeleton(height: 200, borderRadius: BorderRadius.all(Radius.circular(12))),
      );
    }

    final scolarite = _scolarite;
    if (scolarite == null) {
      return const Center(child: Text('Inscription introuvable.'));
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(scolarite.niveau, style: AppTypography.h2),
                    StatusBadge(label: scolarite.statut, type: _typeSelonStatut(scolarite.statut)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _ligneInfo('Filière', scolarite.filiere),
                _ligneInfo('Année académique', scolarite.annee),
                _ligneInfo('Identifiant', scolarite.id),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            onTap: () => context.push('/scolarites/${scolarite.id}/enseignants'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people_outline, color: AppColors.marine),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Enseignants rattachés', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const Icon(Icons.chevron_right, color: AppColors.grisMoyen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ligneInfo(String label, String valeur) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.grisMoyen)),
          Text(valeur, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
