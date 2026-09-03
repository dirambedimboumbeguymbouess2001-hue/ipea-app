import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/empty_state.dart';
import 'data/scolarite_models.dart';
import 'data/scolarite_repository.dart';

class ScolaritesScreen extends StatefulWidget {
  const ScolaritesScreen({super.key});

  @override
  State<ScolaritesScreen> createState() => _ScolaritesScreenState();
}

class _ScolaritesScreenState extends State<ScolaritesScreen> {
  final _repository = ScolariteRepository();

  List<Classe>? _classes;
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
      final classes = await _repository.obtenirClasses();
      if (!mounted) return;
      setState(() {
        _classes = classes;
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
      appBar: AppBar(title: const Text('Ma scolarité')),
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
            child: LoadingSkeleton(height: 56, borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
      );
    }

    final classes = _classes!.reversed.toList();

    if (classes.isEmpty) {
      return EmptyState(
        icon: Symbols.school_rounded,
        message: 'Aucune classe enregistrée pour le moment.',
        actionLabel: 'Actualiser',
        onAction: _charger,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: classes.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final classe = classes[index];
        return AppCard(
          padding: EdgeInsets.zero,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(classe.nom, style: AppTypography.h3),
              subtitle: Text('${classe.semestres.length} semestre(s)', style: AppTypography.bodySmall),
              iconColor: AppColors.marine,
              collapsedIconColor: AppColors.grisMoyen,
              childrenPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
              children: classe.semestres.map((semestre) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  title: Text(semestre.nom, style: AppTypography.bodyLarge),
                  subtitle: Text(
                    'Moyenne ${semestre.moyenne}/20 · ${semestre.totalCredits} crédits',
                    style: AppTypography.bodySmall,
                  ),
                  trailing: const Icon(Symbols.chevron_right_rounded, color: AppColors.grisMoyen),
                  onTap: () => context.push('/scolarites/${classe.id}/${semestre.id}'),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
