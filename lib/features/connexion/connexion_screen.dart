import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
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
  final _matriculeControleur = TextEditingController();
  final _motDePasseControleur = TextEditingController();

  bool _enChargement = false;
  String? _erreur;

  @override
  void dispose() {
    _matriculeControleur.dispose();
    _motDePasseControleur.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    setState(() {
      _enChargement = true;
      _erreur = null;
    });

    try {
      final token = await _repository.connecter(
        matricule: _matriculeControleur.text.trim(),
        motDePasse: _motDePasseControleur.text,
      );
      await AuthState.instance.connecter(token);
      if (mounted) context.go('/tableau-de-bord');
    } catch (_) {
      setState(() {
        _erreur = 'Matricule ou mot de passe incorrect.';
      });
    } finally {
      if (mounted) setState(() => _enChargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondApplication,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Connexion', style: AppTypography.h2),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Connectez-vous avec votre matricule IPEA.',
                style: AppTypography.libelle,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Matricule',
                controller: _matriculeControleur,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Mot de passe',
                controller: _motDePasseControleur,
                obscureText: true,
              ),
              if (_erreur != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _erreur!,
                  style: AppTypography.libelle.copyWith(color: AppColors.erreur),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Se connecter',
                isLoading: _enChargement,
                onPressed: _seConnecter,
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Vous n'avez pas encore de compte ?",
                      style: AppTypography.libelle,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      "Rendez-vous au secrétariat de l'IPEA avec votre "
                      "matricule pour activer votre accès à l'application.",
                      textAlign: TextAlign.center,
                      style: AppTypography.libelle,
                    ),
                    TextButton(
                      onPressed: () => context.push('/activation'),
                      child: const Text("J'ai déjà un matricule, activer mon compte"),
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
