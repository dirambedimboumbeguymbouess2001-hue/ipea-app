import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/auth/auth_state.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../../shared/widgets/error_state.dart';
import '../connexion/data/auth_repository.dart';
import 'data/profil_models.dart';
import 'data/profil_repository.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final _repository = ProfilRepository();
  final _authRepository = AuthRepository();

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

    await _repository.mettreAJourProfil(email: _emailController.text, telephone: _telephoneController.text);

    if (!mounted) return;
    setState(() {
      _enregistrementEnCours = false;
      _modeEdition = false;
      _profil = _profil?.copyWith(email: _emailController.text, telephone: _telephoneController.text);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil mis à jour avec succès.')));
  }

  Future<void> _seDeconnecter() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Déconnexion', style: TextStyle(color: AppColors.erreur)),
          ),
        ],
      ),
    );

    if (confirme == true) {
      // Révoque le token côté serveur avant de l'effacer localement.
      await _authRepository.deconnecter();
      await AuthState.instance.deconnecter();
      if (mounted) context.go('/connexion');
    }
  }

  void _ouvrirChangementMotDePasse() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.blanc,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge)),
      ),
      builder: (context) => _FormulaireChangementMotDePasse(repository: _repository),
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
            IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => setState(() => _modeEdition = true)),
        ],
      ),
      body: _construireContenu(),
    );
  }

  Widget _construireContenu() {
    if (_enErreur) return ErrorState(onRetry: _charger);

    if (_enChargement) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: LoadingSkeleton(height: 260, borderRadius: BorderRadius.all(Radius.circular(12))),
      );
    }

    final profil = _profil!;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
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
                    AppButton(label: 'Enregistrer', onPressed: _enregistrer, isLoading: _enregistrementEnCours),
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
        const SizedBox(height: AppSpacing.lg),

        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lock_outline, color: AppColors.marine),
                title: Text('Changer le mot de passe', style: AppTypography.bodyLarge),
                trailing: const Icon(Icons.chevron_right, color: AppColors.grisMoyen),
                onTap: _ouvrirChangementMotDePasse,
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.logout, color: AppColors.erreur),
                title: Text('Se déconnecter', style: AppTypography.bodyLarge.copyWith(color: AppColors.erreur)),
                onTap: _seDeconnecter,
              ),
            ],
          ),
        ),
      ],
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

class _FormulaireChangementMotDePasse extends StatefulWidget {
  final ProfilRepository repository;

  const _FormulaireChangementMotDePasse({required this.repository});

  @override
  State<_FormulaireChangementMotDePasse> createState() => _FormulaireChangementMotDePasseState();
}

class _FormulaireChangementMotDePasseState extends State<_FormulaireChangementMotDePasse> {
  final _actuelController = TextEditingController();
  final _nouveauController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _chargement = false;
  String? _erreurNouveau;
  String? _erreurConfirmation;
  String? _erreurGenerale;

  @override
  void dispose() {
    _actuelController.dispose();
    _nouveauController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _valider() async {
    setState(() {
      _erreurNouveau = _nouveauController.text.length < 6 ? 'Au moins 6 caractères' : null;
      _erreurConfirmation = _confirmationController.text != _nouveauController.text ? 'Ne correspond pas' : null;
      _erreurGenerale = null;
    });

    if (_erreurNouveau != null || _erreurConfirmation != null) return;

    setState(() => _chargement = true);

    try {
      await widget.repository.changerMotDePasse(
        motDePasseActuel: _actuelController.text,
        nouveauMotDePasse: _nouveauController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mot de passe modifié avec succès.')));
    } catch (_) {
      if (!mounted) return;
      setState(() => _erreurGenerale = 'Mot de passe actuel incorrect.');
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Changer le mot de passe', style: AppTypography.h2),
          const SizedBox(height: AppSpacing.lg),
          if (_erreurGenerale != null) ...[
            Text(_erreurGenerale!, style: AppTypography.bodySmall.copyWith(color: AppColors.erreur)),
            const SizedBox(height: AppSpacing.sm),
          ],
          AppTextField(label: 'Mot de passe actuel', controller: _actuelController, obscureText: true),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Nouveau mot de passe',
            controller: _nouveauController,
            obscureText: true,
            errorText: _erreurNouveau,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Confirmer le nouveau mot de passe',
            controller: _confirmationController,
            obscureText: true,
            errorText: _erreurConfirmation,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: 'Valider', onPressed: _valider, isLoading: _chargement),
        ],
      ),
    );
  }
}
