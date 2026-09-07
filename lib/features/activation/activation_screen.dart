import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../connexion/data/auth_repository.dart';

/// Écran d'activation, adapté à la vraie API : POST /mobile/active
/// n'attend officiellement qu'un `matricule`.
///
/// Le champ Email a été ajouté par anticipation d'une évolution encore
/// non confirmée par l'encadrant (voir QUESTIONS_API.md, point 2) : à
/// terme, le mot de passe généré serait envoyé à la fois par SMS (canal
/// réel, basé sur le téléphone déjà en base) et par email (canal proposé,
/// à faire ajouter côté backend).
class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final _repository = AuthRepository();
  final _matriculeController = TextEditingController();
  final _emailController = TextEditingController();

  bool _chargement = false;
  String? _erreurMatricule;
  String? _erreurEmail;
  String? _erreurGenerale;

  @override
  void dispose() {
    _matriculeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _emailValide(String valeur) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(valeur);
  }

  Future<void> _activerCompte() async {
    setState(() {
      _erreurMatricule = _matriculeController.text.trim().isEmpty ? 'Matricule requis' : null;
      _erreurEmail = !_emailValide(_emailController.text.trim()) ? 'Email invalide' : null;
      _erreurGenerale = null;
    });

    if (_erreurMatricule != null || _erreurEmail != null) return;

    setState(() => _chargement = true);

    try {
      await _repository.activerCompte(
        matricule: _matriculeController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Compte activé. Un mot de passe a été envoyé par SMS et par email.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
      context.go('/connexion');
    } catch (_) {
      if (!mounted) return;
      setState(() => _erreurGenerale = 'Matricule invalide. Vérifiez et réessayez.');
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      appBar: AppBar(title: const Text('Activation de compte')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('Activez votre compte', style: AppTypography.h1, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Renseignez votre matricule et votre email pour recevoir '
                'votre mot de passe par SMS et par email',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              if (_erreurGenerale != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.erreur.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: Text(
                    _erreurGenerale!,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.erreur),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              AppTextField(label: 'Matricule', controller: _matriculeController, errorText: _erreurMatricule),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Email',
                controller: _emailController,
                errorText: _erreurEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.xl),

              AppButton(label: 'Activer mon compte', onPressed: _activerCompte, isLoading: _chargement),
              const SizedBox(height: AppSpacing.md),

              Center(
                child: TextButton(
                  onPressed: () => context.go('/connexion'),
                  child: Text(
                    'Retour à la connexion',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.orFonce, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}