import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/empty_state.dart';
import 'data/notes_models.dart';
import 'data/notes_repository.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _repository = NotesRepository();

  List<NoteMatiere>? _notes;
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
      // "etu-001" est un identifiant temporaire — sera remplacé par
      // le véritable identifiant de l'étudiant connecté, une fois
      // l'authentification branchée à la vraie API.
      final notes = await _repository.obtenirNotes('etu-001');
      if (!mounted) return;
      setState(() {
        _notes = notes;
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

  /// Indique la couleur du badge selon le niveau de la moyenne —
  /// simple repère visuel pour l'étudiant, pas une règle officielle.
  StatusType _typeSelonMoyenne(double moyenne) {
    if (moyenne >= 14) return StatusType.succes;
    if (moyenne >= 10) return StatusType.avertissement;
    return StatusType.erreur;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grisClair,
      appBar: AppBar(title: const Text('Mes notes')),
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
          3,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: LoadingSkeleton(height: 90, borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
      );
    }

    final notes = _notes!;

    // État VIDE — aucune note disponible pour l'instant
    if (notes.isEmpty) {
      return EmptyState(
        icon: Icons.grade_outlined,
        message: 'Aucune note disponible pour le moment.',
        actionLabel: 'Actualiser',
        onAction: _charger,
      );
    }

    // État SUCCÈS
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: notes.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final matiere = notes[index];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      matiere.nomMatiere,
                      style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  StatusBadge(
                    label: '${matiere.moyenne}/20',
                    type: _typeSelonMoyenne(matiere.moyenne),
                  ),
                ],
              ),
              Text(
                'Coefficient ${matiere.coefficient.toStringAsFixed(0)}',
                style: AppTypography.bodySmall,
              ),
              const Divider(height: AppSpacing.lg),
              ...matiere.evaluations.map(
                (eval) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(eval.intitule, style: AppTypography.bodyMedium),
                      Text(
                        '${eval.valeur.toStringAsFixed(0)}/${eval.bareme.toStringAsFixed(0)}',
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
