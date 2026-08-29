import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../connexion/data/auth_repository.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final _repository = AuthRepository();
  final _matriculeController = TextEditingController();
  final _codeController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _confirmationController = TextEditingController();

  bool _motDePasseVisible = false;
  bool _chargement = false;

  String? _erreurMatricule;
  String? _erreurCode;
  String? _erreurMotDePasse;
  String? _erreurConfirmation;
  String? _erreurGenerale;

  @override
  void dispose() {
    _matriculeController.dispose();
    _codeController.dispose();
    _motDePasseController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  bool _validerFormulaire() {
    setState(() {
      _erreurMatricule = _matriculeController.text.trim().isEmpty ? 'Matricule requis' : null;
      _erreurCode = _codeController.text.trim().isEmpty ? 'Code d\'activation requis' : null;
      _erreurMotDePasse = _motDePasseController.text.length < 6 ? 'Au moins 6 caractères' : null;
      _erreurConfirmation =
          _confirmationController.text != _motDePasseController.text ? 'Les mots de passe ne correspondent pas' : null;
    });

    return _erreurMatricule == null &&
        _erreurCode == null &&
        _erreurMotDePasse == null &&
        _erreurConfirmation == null;
  }

  Future<void> _activerCompte() async {
    setState(() => _erreurGenerale = null);
    if (!_validerFormulaire()) return;

    setState(() => _chargement = true);

    try {
      await _repository.activerCompte(
        matricule: _matriculeController.text.trim(),
        code: _codeController.text.trim(),
        nouveauMotDePasse: _motDePasseController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte activé avec succès. Vous pouvez vous connecter.')),
      );
      context.go('/connexion');
    } catch (_) {
      if (!mounted) return;
      setState(() => _erreurGenerale = 'Matricule ou code invalide. Vérifiez et réessayez.');
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
                'Renseignez votre matricule et le code reçu pour créer votre mot de passe',
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
                label: 'Code d\'activation',
                controller: _codeController,
                errorText: _erreurCode,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Nouveau mot de passe',
                controller: _motDePasseController,
                errorText: _erreurMotDePasse,
                obscureText: !_motDePasseVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _motDePasseVisible ? Symbols.visibility_off_rounded : Symbols.visibility_rounded,
                    color: AppColors.grisMoyen,
                  ),
                  onPressed: () => setState(() => _motDePasseVisible = !_motDePasseVisible),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Confirmer le mot de passe',
                controller: _confirmationController,
                errorText: _erreurConfirmation,
                obscureText: !_motDePasseVisible,
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