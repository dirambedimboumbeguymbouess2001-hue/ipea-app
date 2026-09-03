import '../../../core/network/api_client.dart';
import 'profil_models.dart';

/// Endpoints : GET /profile, PUT /profile, PUT /password (Sanctum).
/// Structure inchangée — prête à passer en réel dès validation de
/// l'encadrant (ApiFlags.profil). IMPORTANT : PUT /profile n'envoie
/// désormais plus jamais l'email (restriction demandée par
/// l'encadrant — l'étudiant ne peut plus le modifier). Le serveur
/// doit lui aussi refuser toute tentative de modification de l'email
/// par ce endpoint, même si un client malveillant tentait de l'envoyer.
class ProfilRepository {
  ProfilEtudiant? _profilEnCache;

  Future<ProfilEtudiant> obtenirProfil() async {
    if (!ApiFlags.profil) {
      await Future.delayed(const Duration(seconds: 1));
      _profilEnCache ??= const ProfilEtudiant(
        nomComplet: 'Guy Dirambe Di Mboumbe',
        email: 'guy.dirambe@ipea-etu.ga',
        telephone: '074 12 34 56',
        matricule: 'IPEA-L2-2026-0142',
      );
      return _profilEnCache!;
    }

    final reponse = await ApiClient.instance.dio.get('/profile');
    return ProfilEtudiant.fromJson(reponse.data);
  }

  /// Seul le téléphone est modifiable par l'étudiant — voir
  /// SPECIFICATION_API_V2.md, section Profil, pour la restriction
  /// exacte attendue côté serveur.
  Future<void> mettreAJourProfil({required String email, required String telephone}) async {
    if (!ApiFlags.profil) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (_profilEnCache != null) {
        _profilEnCache = _profilEnCache!.copyWith(telephone: telephone);
      }
      return;
    }

    await ApiClient.instance.dio.put('/profile', data: {
      'telephone': telephone,
    });
  }

  Future<void> changerMotDePasse({
    required String motDePasseActuel,
    required String nouveauMotDePasse,
  }) async {
    if (!ApiFlags.profil) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    await ApiClient.instance.dio.put('/password', data: {
      'mot_de_passe_actuel': motDePasseActuel,
      'nouveau_mot_de_passe': nouveauMotDePasse,
    });
  }
}
