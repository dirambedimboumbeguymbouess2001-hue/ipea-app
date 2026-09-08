import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/auth/auth_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/loading_skeleton.dart';
import '../connexion/data/auth_repository.dart';
import 'data/profil_models.dart';
import 'data/profil_repository.dart';

/// Onglet "Profil" : avatar à initiales avec badge "boursier" (donnée
/// réelle), mode édition via l'icône crayon, ligne email en lecture
/// seule (donnée SIMULÉE, en attente du backend - voir
/// QUESTIONS_API.md), changement de mot de passe en feuille modale,
/// déconnexion avec confirmation.
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

  final _telephoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  @override
  void dispose() {
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

    await _repository.mettreAJourProfil(telephone: _telephoneController.text);

    if (!mounted) return;
    setState(() {
      _enregistrementEnCours = false;
      _modeEdition = false;
      _profil = _profil?.copyWith(telephone: _telephoneController.text);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil mis à jour avec succès.')),
    );
  }

  Future<void> _seDeconnecter() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Déconnexion', style: TextStyle(color: AppColors.erreur)),
          ),
        ],
      ),
    );

    if (confirme == true) {
      await _authRepository.deconnecter();
      await AuthState.instance.deconnecter();
      if (mounted) context.go('/connexion');
    }
  }

  void _ouvrirChangementMotDePasse() {
    if (_profil == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.blanc,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge)),
      ),
      builder: (context) => _FormulaireChangementMotDePasse(
        repository: _repository,
        etudiantId: _profil!.id,
      ),
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
              icon: const Icon(Symbols.edit_rounded),
              onPressed: () => setState(() => _modeEdition = true),
            ),
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
        child: LoadingSkeleton(
          height: 260,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      );
    }

    final profil = _profil!;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Center(
          child: Column(
            children: [
              // Avatar à initiales + badge boursier (donnée réelle de
              // l'API). L'étudiant ne peut ni ajouter ni modifier de
              // photo - seule l'administration en a la possibilité.
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.marine,
                    child: Text(
                      profil.nomComplet.trim().split(' ').where((m) => m.isNotEmpty).map((m) => m[0]).take(2).join(),
                      style: AppTypography.h1.copyWith(color: AppColors.blanc),
                    ),
                  ),
                  if (profil.boursier)
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Tooltip(
                        message: 'Étudiant boursier',
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.or,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.blanc, width: 2),
                          ),
                          child: const Icon(
                            Symbols.workspace_premium_rounded,
                            size: 16,
                            color: AppColors.marine,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(profil.nomComplet, style: AppTypography.h2, textAlign: TextAlign.center),
              Text(profil.matricule, style: AppTypography.bodySmall),
              if (profil.boursier) ...[
                const SizedBox(height: AppSpacing.xs),
                Text('Étudiant boursier', style: AppTypography.bodySmall.copyWith(color: AppColors.orFonce)),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        AppCard(
          child: _modeEdition
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Téléphone',
                      controller: _telephoneController,
                      keyboardType: TextInputType.phone,
                    ),
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
                                _telephoneController.text = profil.telephone;
                              });
                            },
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ligneInfo(Symbols.call_rounded, 'Téléphone', profil.telephone),
                    if (profil.email != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(child: _ligneInfo(Symbols.mail_rounded, 'Email', profil.email!)),
                          Tooltip(
                            message: 'Fonctionnalité en cours d\'intégration côté serveur - '
                                'valeur affichée à titre indicatif',
                            child: Icon(Symbols.lock_rounded, size: 16, color: AppColors.grisMoyen),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
        ),
        const SizedBox(height: AppSpacing.lg),

        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Symbols.lock_rounded, color: AppColors.marine),
                title: Text('Changer le mot de passe', style: AppTypography.bodyLarge),
                trailing: const Icon(Symbols.chevron_right_rounded, color: AppColors.grisMoyen),
                onTap: _ouvrirChangementMotDePasse,
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Symbols.logout_rounded, color: AppColors.erreur),
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
  final String etudiantId;

  const _FormulaireChangementMotDePasse({
    required this.repository,
    required this.etudiantId,
  });

  @override
  State<_FormulaireChangementMotDePasse> createState() => _FormulaireChangementMotDePasseState();
}

class _FormulaireChangementMotDePasseState extends State<_FormulaireChangementMotDePasse> {
  final _nouveauController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _chargement = false;
  String? _erreurNouveau;
  String? _erreurConfirmation;
  String? _erreurGenerale;

  @override
  void dispose() {
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
        etudiantId: widget.etudiantId,
        nouveauMotDePasse: _nouveauController.text,
        confirmation: _confirmationController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot de passe modifié avec succès.')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _erreurGenerale = "Une erreur est survenue. Réessayez.");
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