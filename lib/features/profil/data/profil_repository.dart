import '../../../core/network/api_client.dart';
import 'profil_models.dart';

class ProfilRepository {
  /// Récupère le profil de l'étudiant connecté.
  Future<ProfilEtudiant> obtenirProfil() async {
    if (!ApiFlags.profil) {
      // --- SIMULATION TEMPORAIRE ---
      // boursier: valeur réellement observée en testant /mobile/active
      // avec un vrai matricule (voir QUESTIONS_API.md, point 1).
      // email: purement fictif - n'existe pas encore côté backend,
      // affiché uniquement pour illustrer le futur comportement.
      await Future.delayed(const Duration(milliseconds: 800));
      return const ProfilEtudiant(
        id: '1',
        matricule: 'IPEA-2024-0157',
        nom: 'Mbouess',
        prenom: 'Guy',
        telephone: '074 12 34 56',
        boursier: false,
        photo: null,
        email: 'guy.mbouess@ipea-gabon.ga',
      );
    }
    final reponse = await ApiClient.instance.dio.get('/profile');
    return ProfilEtudiant.fromJson(reponse.data['data'] as Map<String, dynamic>);
  }

  /// Met à jour le profil. Seul le téléphone est modifiable par l'étudiant :
  /// - l'email n'existe pas dans l'API (rien à envoyer)
  /// - la photo est techniquement acceptée par l'API mais réservée à
  ///   l'admin : on ne l'envoie donc jamais depuis cette méthode.
  Future<void> mettreAJourProfil({required String telephone}) async {
    if (!ApiFlags.profil) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(milliseconds: 800));
      return;
    }
    await ApiClient.instance.dio.put('/profile', data: {
      'telephone': telephone,
    });
  }

  /// Change le mot de passe. Pas de vérification de l'ancien mot de passe
  /// côté API (contrairement à ce qu'on avait supposé au départ) — mais
  /// `etudiant_id` est obligatoire dans le corps de la requête.
  Future<void> changerMotDePasse({
    required String etudiantId,
    required String nouveauMotDePasse,
    required String confirmation,
  }) async {
    if (!ApiFlags.profil) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(milliseconds: 800));
      return;
    }
    await ApiClient.instance.dio.put('/password', data: {
      'etudiant_id': etudiantId,
      'password': nouveauMotDePasse,
      'confirm': confirmation,
    });
  }
}