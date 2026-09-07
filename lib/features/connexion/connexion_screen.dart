import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
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
  final _matriculeController = TextEditingController();
  final _motDePasseController = TextEditingController();
  bool _motDePasseVisible = false;
  bool _chargement = false;
  String? _erreurMatricule;
  String? _erreurGenerale;

  @override
  void dispose() {
    _matriculeController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    setState(() {
      _erreurMatricule = _matriculeController.text.trim().isEmpty ? 'Matricule requis' : null;
      _erreurGenerale = null;
    });

    if (_erreurMatricule != null) return;

    setState(() => _chargement = true);

    try {
      final token = await _repository.connecter(
        matricule: _matriculeController.text.trim(),
        motDePasse: _motDePasseController.text,
      );

      await AuthState.instance.connecter(token);

      if (!mounted) return;
      context.go('/tableau-de-bord');
    } catch (_) {
      if (!mounted) return;
      setState(() => _erreurGenerale = 'Matricule ou mot de passe incorrect.');
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
              const SizedBox(height: AppSpacing.xl),
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
              Text('IPEA Gabon', style: AppTypography.h1, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              Text('Accédez à votre espace étudiant', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
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

              AppTextField(
                label: 'Matricule',
                controller: _matriculeController,
                errorText: _erreurMatricule,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Mot de passe',
                controller: _motDePasseController,
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

              const SizedBox(height: AppSpacing.xl),
              const Divider(),
              const SizedBox(height: AppSpacing.md),

              // Explication d'obtention de compte, ajoutée en bas de l'écran
              // de connexion à la demande de l'encadrant.
              // NB : le texte ne mentionne plus le "code à 4 chiffres" -
              // la vraie API n'en attend aucun (voir QUESTIONS_API.md).
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.grisClair,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Symbols.info_rounded, color: AppColors.marine, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Vous n\'avez pas encore de compte ?',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.texteFPrincipal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Si vous êtes inscrit à l\'IPEA, rendez-vous au secrétariat avec votre '
                      'matricule étudiant pour activer votre accès à l\'application.',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}