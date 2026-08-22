import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/empty_state.dart';
import 'data/scolarites_models.dart';
import 'data/scolarites_repository.dart';

class ScolaritesScreen extends StatefulWidget {
  const ScolaritesScreen({super.key});

  @override
  State<ScolaritesScreen> createState() => _ScolaritesScreenState();
}

class _ScolaritesScreenState extends State<ScolaritesScreen> {
  final _repository = ScolaritesRepository();

  List<Scolarite>? _scolarites;
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
      final scolarites = await _repository.obtenirScolarites('etu-001');
      if (!mounted) return;
      setState(() {
        _scolarites = scolarites;
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
      appBar: AppBar(title: const Text('Mes scolarités')),
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
        children: List.generate(
          2,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: LoadingSkeleton(height: 80, borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
      );
    }

    final scolarites = _scolarites!;

    if (scolarites.isEmpty) {
      return EmptyState(
        icon: Icons.school_outlined,
        message: 'Aucune scolarité enregistrée pour le moment.',
        actionLabel: 'Actualiser',
        onAction: _charger,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: scolarites.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final scolarite = scolarites[index];
        return AppCard(
          // Navigue vers l'écran de détail, en restant dans le même
          // onglet grâce à la structure StatefulShellRoute déjà en place.
          onTap: () => context.push('/scolarites/${scolarite.id}'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${scolarite.niveau} — ${scolarite.filiere}',
                      style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text('Année ${scolarite.annee}', style: AppTypography.bodySmall),
                  ],
                ),
              ),
              StatusBadge(label: scolarite.statut, type: _typeSelonStatut(scolarite.statut)),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right, color: AppColors.grisMoyen),
            ],
          ),
        );
      },
    );
  }
}
