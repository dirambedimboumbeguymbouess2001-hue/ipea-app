import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';

/// Formulaire de publication d'annonce, avec pièce jointe optionnelle
/// (PDF, document) pour les informations urgentes.
///
/// ⚠️ NON FONCTIONNEL EN L'ÉTAT — honnêteté délibérée : contrairement
/// aux autres écrans de l'app, ce formulaire n'a AUCUN endpoint pour
/// enregistrer réellement une annonce, ni a fortiori pour y joindre un
/// fichier (vérifié dans document.json, aucune route ne correspond -
/// voir QUESTIONS_API.md, point 6). Un vrai endpoint d'upload
/// (multipart/form-data) serait nécessaire côté backend pour la pièce
/// jointe, en plus de l'endpoint de publication lui-même. Plutôt que de
/// simuler un faux succès trompeur, le bouton affiche clairement que la
/// fonctionnalité attend un développement côté backend.
class AdministrationAnnonceScreen extends StatefulWidget {
  const AdministrationAnnonceScreen({super.key});

  @override
  State<AdministrationAnnonceScreen> createState() => _AdministrationAnnonceScreenState();
}

class _AdministrationAnnonceScreenState extends State<AdministrationAnnonceScreen> {
  final _titreController = TextEditingController();
  final _contenuController = TextEditingController();
  PlatformFile? _fichierJoint;

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  Future<void> _choisirFichier() async {
    // file_picker v12 : architecture "federated plugin", API statique
    // directe (FilePicker.platform a disparu). pickFile() renvoie
    // directement un PlatformFile? pour une sélection unique.
    final fichier = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (fichier != null) {
      setState(() => _fichierJoint = fichier);
    }
  }

  void _retirerFichier() {
    setState(() => _fichierJoint = null);
  }

  void _tenterPublication() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fonctionnalité indisponible'),
        content: Text(
          "Aucun endpoint n'existe encore côté serveur pour enregistrer une "
          "annonce${_fichierJoint != null ? ' ni y joindre un fichier' : ''}. "
          "Ce formulaire est prêt côté application, mais la publication "
          "réelle attend un développement backend (voir QUESTIONS_API.md).",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Compris')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      appBar: AppBar(title: const Text('Publier une annonce')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.avertissement.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(Symbols.warning_rounded, color: AppColors.avertissement, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Pas encore connecté à un vrai serveur - formulaire de démonstration',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.avertissement),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(label: 'Titre', controller: _titreController),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Contenu', controller: _contenuController),
              const SizedBox(height: AppSpacing.lg),

              Text('Pièce jointe (optionnel)', style: AppTypography.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              if (_fichierJoint == null)
                OutlinedButton.icon(
                  onPressed: _choisirFichier,
                  icon: const Icon(Symbols.attach_file_rounded),
                  label: const Text('Joindre un fichier (PDF, document, image)'),
                )
              else
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.grisClair,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      const Icon(Symbols.description_rounded, color: AppColors.marine),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_fichierJoint!.name, style: AppTypography.bodyMedium, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Symbols.close_rounded, size: 20),
                        onPressed: _retirerFichier,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),
              AppButton(label: 'Publier', onPressed: _tenterPublication),
            ],
          ),
        ),
      ),
    );
  }
}
