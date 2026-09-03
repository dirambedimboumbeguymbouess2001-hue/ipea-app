import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import 'data/scolarite_models.dart';
import 'data/scolarite_repository.dart';

class SemestreDetailScreen extends StatefulWidget {
  final String classeId;
  final String semestreId;

  const SemestreDetailScreen({super.key, required this.classeId, required this.semestreId});

  @override
  State<SemestreDetailScreen> createState() => _SemestreDetailScreenState();
}

class _SemestreDetailScreenState extends State<SemestreDetailScreen> {
  final _repository = ScolariteRepository();

  Classe? _classe;
  Semestre? _semestre;
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
      final classe = classes.where((c) => c.id == widget.classeId).firstOrNull;
      final semestre = classe?.semestres.where((s) => s.id == widget.semestreId).firstOrNull;

      if (!mounted) return;
      setState(() {
        _classe = classe;
        _semestre = semestre;
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

  Color _couleurNote(double note) {
    if (note >= 14) return AppColors.succes;
    if (note >= 10) return AppColors.orFonce;
    return AppColors.erreur;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grisClair,
      appBar: AppBar(title: Text(_semestre != null ? '${_classe!.nom} — ${_semestre!.nom}' : 'Semestre')),
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
        child: LoadingSkeleton(height: 240, borderRadius: BorderRadius.all(Radius.circular(12))),
      );
    }

    final semestre = _semestre;
    if (semestre == null) {
      return const Center(child: Text('Semestre introuvable.'));
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // En-tête du tableau
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text('Module', style: AppTypography.libelle)),
                    Expanded(flex: 1, child: Text('Note', style: AppTypography.libelle, textAlign: TextAlign.right)),
                    Expanded(flex: 1, child: Text('Crédits', style: AppTypography.libelle, textAlign: TextAlign.right)),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...semestre.modules.map((module) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text(module.nom, style: AppTypography.bodyMedium)),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${module.note.toStringAsFixed(0)}/20',
                          textAlign: TextAlign.right,
                          style: AppTypography.bodyMedium.copyWith(
                            color: _couleurNote(module.note),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('${module.credits}', textAlign: TextAlign.right, style: AppTypography.bodyMedium),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Totaux du semestre
        AppCard(
          backgroundColor: AppColors.marine,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Moyenne du semestre', style: AppTypography.bodySmall.copyWith(color: AppColors.blanc.withValues(alpha: 0.8))),
                  Text('${semestre.moyenne}/20', style: AppTypography.h2.copyWith(color: AppColors.blanc)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Crédits obtenus', style: AppTypography.bodySmall.copyWith(color: AppColors.blanc.withValues(alpha: 0.8))),
                  Text('${semestre.totalCredits}', style: AppTypography.h2.copyWith(color: AppColors.blanc)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
