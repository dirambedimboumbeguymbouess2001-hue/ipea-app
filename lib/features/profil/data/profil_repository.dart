import '../../../core/network/api_client.dart';
import 'profil_models.dart';

/// Endpoints exacts d'après la note de cadrage :
/// - GET /api/mobile/profile (Sanctum)
/// - PUT /api/mobile/profile (Sanctum)
/// - PUT /api/mobile/password (Sanctum)
class ProfilRepository {
  ProfilEtudiant? _profilEnCache;

  Future<ProfilEtudiant> obtenirProfil() async {
    if (!kUtiliserApiReelle) {
      // --- SIMULATION TEMPORAIRE ---
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

  Future<void> mettreAJourProfil({required String email, required String telephone}) async {
    if (!kUtiliserApiReelle) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (_profilEnCache != null) {
        _profilEnCache = _profilEnCache!.copyWith(email: email, telephone: telephone);
      }
      return;
    }

    await ApiClient.instance.dio.put('/profile', data: {
      'email': email,
      'telephone': telephone,
    });
  }

  Future<void> changerMotDePasse({
    required String motDePasseActuel,
    required String nouveauMotDePasse,
  }) async {
    if (!kUtiliserApiReelle) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    await ApiClient.instance.dio.put('/password', data: {
      'mot_de_passe_actuel': motDePasseActuel,
      'nouveau_mot_de_passe': nouveauMotDePasse,
    });
  }
}
