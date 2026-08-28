import '../../../core/network/api_client.dart';

/// Repository de connexion — endpoint exact d'après la note de cadrage :
/// POST /api/mobile/login (public)
class AuthRepository {
  /// Retourne le token Sanctum en cas de succès. Lève une exception
  /// en cas d'échec (identifiants invalides, réseau, etc.) — l'écran
  /// appelant doit l'attraper pour afficher un message d'erreur adapté.
  Future<String> connecter({required String identifiant, required String motDePasse}) async {
    if (!kUtiliserApiReelle) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(seconds: 1));
      return 'faux-token-de-test';
    }

    final reponse = await ApiClient.instance.dio.post('/login', data: {
      'identifiant': identifiant,
      'mot_de_passe': motDePasse,
    });

    // Le nom exact du champ contenant le token dans la réponse JSON
    // (ex: 'token', 'access_token'...) n'est pas précisé dans la note
    // de cadrage — à ajuster une fois la réponse réelle de l'API connue.
    return reponse.data['token'] as String;
  }

  /// POST /api/mobile/active (public)
  Future<void> activerCompte({
    required String matricule,
    required String code,
    required String nouveauMotDePasse,
  }) async {
    if (!kUtiliserApiReelle) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    await ApiClient.instance.dio.post('/active', data: {
      'matricule': matricule,
      'code': code,
      'mot_de_passe': nouveauMotDePasse,
    });
  }

  /// POST /api/mobile/logout (Sanctum) — révoque le token côté serveur.
  Future<void> deconnecter() async {
    if (!kUtiliserApiReelle) return;

    await ApiClient.instance.dio.post('/logout');
  }
}
