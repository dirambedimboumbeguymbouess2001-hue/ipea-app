import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/auth/auth_state.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import 'data/auth_repository.dart';

class ConnexionScreen extends StatefulWidget {
  const ConnexionScreen({super.key});

  @override
  State<ConnexionScreen> createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  final _repository = AuthRepository();
  final _identifiantController = TextEditingController();
  final _motDePasseController = TextEditingController();
  bool _motDePasseVisible = false;
  bool _chargement = false;
  String? _erreurIdentifiant;
  String? _erreurGenerale;

  @override
  void dispose() {
    _identifiantController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    setState(() {
      _erreurIdentifiant = _identifiantController.text.isEmpty ? 'Identifiant requis' : null;
      _erreurGenerale = null;
    });

    if (_erreurIdentifiant != null) return;

    setState(() => _chargement = true);

    try {
      final token = await _repository.connecter(
        identifiant: _identifiantController.text,
        motDePasse: _motDePasseController.text,
      );

      await AuthState.instance.connecter(token);

      if (!mounted) return;
      context.go('/tableau-de-bord');
    } catch (_) {
      if (!mounted) return;
      setState(() => _erreurGenerale = 'Identifiant ou mot de passe incorrect.');
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.or,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                  alignment: Alignment.center,
                  child: Text('IPEA', style: AppTypography.bouton.copyWith(color: AppColors.marine)),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Connexion', style: AppTypography.h1, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              Text('Accédez à votre espace étudiant', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xxl),

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

              AppTextField(
                label: 'Identifiant',
                controller: _identifiantController,
                errorText: _erreurIdentifiant,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Mot de passe',
                controller: _motDePasseController,
                obscureText: !_motDePasseVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _motDePasseVisible ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grisMoyen,
                  ),
                  onPressed: () => setState(() => _motDePasseVisible = !_motDePasseVisible),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Mot de passe oublié ?',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.orFonce, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              AppButton(label: 'Se connecter', onPressed: _seConnecter, isLoading: _chargement),
              const SizedBox(height: AppSpacing.md),

              Center(
                child: TextButton(
                  onPressed: () => context.go('/activation'),
                  child: Text(
                    'Activer mon compte',
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
