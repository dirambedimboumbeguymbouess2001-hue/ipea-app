import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/empty_state.dart';
import 'data/enseignants_repository.dart';

class EnseignantsScreen extends StatefulWidget {
  final String inscriptionId;

  const EnseignantsScreen({super.key, required this.inscriptionId});

  @override
  State<EnseignantsScreen> createState() => _EnseignantsScreenState();
}

class _EnseignantsScreenState extends State<EnseignantsScreen> {
  final _repository = EnseignantsRepository();

  List<Enseignant>? _enseignants;
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
      final enseignants = await _repository.obtenirEnseignants(widget.inscriptionId);
      if (!mounted) return;
      setState(() {
        _enseignants = enseignants;
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
      appBar: AppBar(title: const Text('Enseignants')),
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
        children: List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: LoadingSkeleton(height: 64, borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
      );
    }

    final enseignants = _enseignants!;
    if (enseignants.isEmpty) {
      return const EmptyState(
        icon: Symbols.group_rounded,
        message: 'Aucun enseignant rattaché à cette inscription pour le moment.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: enseignants.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final enseignant = enseignants[index];
        return AppCard(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.marine,
                child: Text(
                  enseignant.nom.split(' ').last[0],
                  style: AppTypography.bouton.copyWith(fontSize: 14),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(enseignant.nom, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                    Text(enseignant.matiere, style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}