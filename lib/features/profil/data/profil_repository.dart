import 'profil_models.dart';

/// Porte d'accès unique au profil de l'étudiant.
///
/// IMPORTANT : seul le contenu de `obtenirProfil` et `mettreAJourProfil`
/// devra être remplacé une fois la documentation API disponible.
class ProfilRepository {
  // Stocke temporairement le profil "modifié" en mémoire, pour que la
  // simulation de mise à jour ait un effet visible pendant les tests.
  ProfilEtudiant? _profilEnCache;

  Future<ProfilEtudiant> obtenirProfil() async {
    // --- SIMULATION TEMPORAIRE ---
    await Future.delayed(const Duration(seconds: 1));

    _profilEnCache ??= const ProfilEtudiant(
      nomComplet: 'Guy Dirambe Di Mboumbe',
      email: 'guy.dirambe@ipea-etu.ga',
      telephone: '074 12 34 56',
      matricule: 'IPEA-L2-2026-0142',
    );

    return _profilEnCache!;

    // --- CE QUE ÇA DEVIENDRA AVEC L'API (exemple) ---
    // final reponse = await dio.get('/profile');
    // return ProfilEtudiant.fromJson(reponse.data);
  }

  Future<void> mettreAJourProfil({required String email, required String telephone}) async {
    // --- SIMULATION TEMPORAIRE ---
    await Future.delayed(const Duration(milliseconds: 800));

    if (_profilEnCache != null) {
      _profilEnCache = _profilEnCache!.copyWith(email: email, telephone: telephone);
    }

    // --- CE QUE ÇA DEVIENDRA AVEC L'API (exemple) ---
    // await dio.put('/profile', data: {'email': email, 'telephone': telephone});
  }
}
