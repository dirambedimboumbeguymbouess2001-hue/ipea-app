import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/loading_skeleton.dart';
import 'data/scolarite_models.dart';
import 'data/scolarite_repository.dart';

/// Onglet "Scolarité" : liste simple des inscriptions de l'étudiant
/// (une par classe/année). Taper une ligne ouvre le détail des modules
/// (voir inscription_detail_screen.dart).
class ScolaritesScreen extends StatefulWidget {
  const ScolaritesScreen({super.key});

  @override
  State<ScolaritesScreen> createState() => _ScolaritesScreenState();
}

class _ScolaritesScreenState extends State<ScolaritesScreen> {
  final ScolariteRepository _repository = ScolariteRepository();

  late Future<List<Inscription>> _futureInscriptions;

  @override
  void initState() {
    super.initState();
    _futureInscriptions = _repository.obtenirInscriptions();
  }

  Future<void> _recharger() async {
    setState(() {
      _futureInscriptions = _repository.obtenirInscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondApplication,
      appBar: AppBar(title: const Text('Scolarité')),
      body: FutureBuilder<List<Inscription>>(
        future: _futureInscriptions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSkeleton();
          }

          if (snapshot.hasError) {
            return ErrorState(
              message: 'Impossible de charger la scolarité.',
              onRetry: _recharger,
            );
          }

          final inscriptions = snapshot.data ?? const <Inscription>[];

          if (inscriptions.isEmpty) {
            return const EmptyState(
              icon: Symbols.school_rounded,
              message: "Aucune inscription n'a été trouvée pour ce compte.",
            );
          }

          // La plus récente en premier.
          final tri = inscriptions.reversed.toList();

          return RefreshIndicator(
            onRefresh: _recharger,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: tri.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final inscription = tri[index];
                return AppCard(
                  onTap: () => context.push('/scolarites/${inscription.id}', extra: inscription),
                  child: Row(
                    children: [
                      const Icon(Symbols.menu_book_rounded, color: AppColors.orFonce),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(inscription.libelle, style: AppTypography.h3),
                            Text(inscription.code, style: AppTypography.libelle),
                          ],
                        ),
                      ),
                      const Icon(Symbols.chevron_right_rounded),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
