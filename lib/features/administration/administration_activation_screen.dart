import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../connexion/data/auth_repository.dart';

/// Permet à un membre du staff d'activer le compte d'un étudiant à
/// partir de son seul matricule (pas besoin de l'email de l'étudiant,
/// contrairement au parcours d'auto-activation étudiant).
///
/// Réutilise directement AuthRepository.activerCompte : c'est le MÊME
/// endpoint POST /mobile/active, qui ne demande aucune authentification
/// particulière - la connexion admin sert ici de porte d'entrée à
/// l'écran, pas de jeton technique nécessaire pour cet appel précis.
class AdministrationActivationScreen extends StatefulWidget {
  const AdministrationActivationScreen({super.key});

  @override
  State<AdministrationActivationScreen> createState() => _AdministrationActivationScreenState();
}

class _AdministrationActivationScreenState extends State<AdministrationActivationScreen> {
  final _repository = AuthRepository();
  final _matriculeController = TextEditingController();
  bool _chargement = false;
  String? _erreur;
  bool _succes = false;

  @override
  void dispose() {
    _matriculeController.dispose();
    super.dispose();
  }

  Future<void> _activer() async {
    setState(() {
      _chargement = true;
      _erreur = null;
      _succes = false;
    });

    try {
      await _repository.activerCompte(matricule: _matriculeController.text.trim());
      if (!mounted) return;
      setState(() => _succes = true);
      _matriculeController.clear();
    } catch (_) {
      if (!mounted) return;
      setState(() => _erreur = "Impossible d'activer ce matricule.");
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      appBar: AppBar(title: const Text('Activer un compte')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Matricule de l\'étudiant', style: AppTypography.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(label: 'Matricule', controller: _matriculeController),
              if (_erreur != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(_erreur!, style: AppTypography.bodySmall.copyWith(color: AppColors.erreur)),
              ],
              if (_succes) ...[
                const SizedBox(height: AppSpacing.sm),
                Text('Compte activé avec succès.', style: AppTypography.bodySmall.copyWith(color: AppColors.succes)),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: 'Activer', onPressed: _activer, isLoading: _chargement),
            ],
          ),
        ),
      ),
    );
  }
}
