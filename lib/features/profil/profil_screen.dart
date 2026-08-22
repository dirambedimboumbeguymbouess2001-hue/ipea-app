import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import 'data/profil_models.dart';
import 'data/profil_repository.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final _repository = ProfilRepository();

  ProfilEtudiant? _profil;
  bool _enErreur = false;
  bool _enChargement = true;
  bool _modeEdition = false;
  bool _enregistrementEnCours = false;

  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _charger() async {
    setState(() {
      _enChargement = true;
      _enErreur = false;
    });

    try {
      final profil = await _repository.obtenirProfil();
      if (!mounted) return;
      setState(() {
        _profil = profil;
        _emailController.text = profil.email;
        _telephoneController.text = profil.telephone;
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

  Future<void> _enregistrer() async {
    setState(() => _enregistrementEnCours = true);

    await _repository.mettreAJourProfil(
      email: _emailController.text,
      telephone: _telephoneController.text,
    );

    if (!mounted) return;
    setState(() {
      _enregistrementEnCours = false;
      _modeEdition = false;
      _profil = _profil?.copyWith(
        email: _emailController.text,
        telephone: _telephoneController.text,
      );
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil mis à jour avec succès.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grisClair,
      appBar: AppBar(
        title: const Text('Mon profil'),
        actions: [
          if (!_enChargement && !_enErreur && !_modeEdition)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _modeEdition = true),
            ),
        ],
      ),
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
        child: LoadingSkeleton(height: 260, borderRadius: BorderRadius.all(Radius.circular(12))),
      );
    }

    final profil = _profil!;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Avatar + nom, jamais modifiables directement ici
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.marine,
                  child: Text(
                    profil.nomComplet.split(' ').map((m) => m[0]).take(2).join(),
                    style: AppTypography.h1.copyWith(color: AppColors.blanc),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(profil.nomComplet, style: AppTypography.h2, textAlign: TextAlign.center),
                Text(profil.matricule, style: AppTypography.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          AppCard(
            child: _modeEdition
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(label: 'Téléphone', controller: _telephoneController, keyboardType: TextInputType.phone),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Enregistrer',
                        onPressed: _enregistrer,
                        isLoading: _enregistrementEnCours,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        label: 'Annuler',
                        variant: AppButtonVariant.secondaire,
                        onPressed: _enregistrementEnCours
                            ? null
                            : () {
                                setState(() {
                                  _modeEdition = false;
                                  _emailController.text = profil.email;
                                  _telephoneController.text = profil.telephone;
                                });
                              },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _ligneInfo(Icons.email_outlined, 'Email', profil.email),
                      const Divider(height: AppSpacing.lg),
                      _ligneInfo(Icons.phone_outlined, 'Téléphone', profil.telephone),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _ligneInfo(IconData icon, String label, String valeur) {
    return Row(
      children: [
        Icon(icon, color: AppColors.grisMoyen, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodySmall),
              Text(valeur, style: AppTypography.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
