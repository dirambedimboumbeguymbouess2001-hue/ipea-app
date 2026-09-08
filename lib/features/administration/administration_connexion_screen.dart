import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import 'data/administration_repository.dart';
import 'administration_home_screen.dart';

/// Porte d'entrée de l'espace administration (staff IPEA), distincte de
/// la connexion étudiante. Accessible uniquement en tapant l'URL/le lien
/// dédié - volontairement non mise en avant dans la navigation
/// étudiante.
class AdministrationConnexionScreen extends StatefulWidget {
  const AdministrationConnexionScreen({super.key});

  @override
  State<AdministrationConnexionScreen> createState() => _AdministrationConnexionScreenState();
}

class _AdministrationConnexionScreenState extends State<AdministrationConnexionScreen> {
  final _repository = AdministrationRepository();
  final _emailController = TextEditingController();
  final _motDePasseController = TextEditingController();
  bool _chargement = false;
  String? _erreur;

  @override
  void dispose() {
    _emailController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });

    try {
      await _repository.connecter(
        email: _emailController.text.trim(),
        motDePasse: _motDePasseController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdministrationHomeScreen()),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _erreur = 'Email ou mot de passe incorrect.');
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blanc,
      appBar: AppBar(title: const Text('Espace administration')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Text('Connexion staff', style: AppTypography.h1, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              Text('Réservé au personnel administratif de l\'IPEA', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xl),

              if (_erreur != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.erreur.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: Text(_erreur!, style: AppTypography.bodySmall.copyWith(color: AppColors.erreur), textAlign: TextAlign.center),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              AppTextField(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Mot de passe', controller: _motDePasseController, obscureText: true),
              const SizedBox(height: AppSpacing.xl),

              AppButton(label: 'Se connecter', onPressed: _seConnecter, isLoading: _chargement),
            ],
          ),
        ),
      ),
    );
  }
}
