import '../../../core/network/api_client.dart';

/// Jeton temporaire pour les notifications push (fonctionnalité jamais
/// implémentée côté app — l'API l'exige quand même dans /login).
const String _fcmTokenTemporaire = 'flutter-app-fcm-non-integre';

class AuthRepository {
  /// Connecte l'étudiant avec son matricule et son mot de passe.
  /// Retourne le jeton de session (à stocker ensuite via AuthState).
  Future<String> connecter({
    required String matricule,
    required String motDePasse,
  }) async {
    if (!ApiFlags.authentification) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(seconds: 1));
      return 'faux-token-de-test';
    }
    final reponse = await ApiClient.instance.dio.post('/login', data: {
      'matricule': matricule,
      'password': motDePasse,
      'fcm_token': _fcmTokenTemporaire,
    });
    return reponse.data['data'] as String;
  }

  /// Active un compte étudiant à partir de son matricule et d'un email.
  ///
  /// IMPORTANT — état des lieux à la date d'écriture (voir
  /// QUESTIONS_API.md, point 2) :
  /// - Le canal SMS est basé sur un champ RÉEL : `telephone` existe déjà
  ///   dans `EtudiantResource` côté backend.
  /// - Le canal EMAIL est une PROPOSITION D'ÉVOLUTION : aucun champ email
  ///   n'existe aujourd'hui dans le modèle étudiant réel. On le collecte
  ///   déjà côté app pour ne rien perdre du parcours utilisateur, et on
  ///   l'envoie au serveur au cas où (Laravel ignore silencieusement un
  ///   champ non attendu par le endpoint) — mais tant que l'encadrant n'a
  ///   pas confirmé/ajouté la prise en charge de l'email côté backend,
  ///   rien ne garantit qu'il soit réellement utilisé pour l'envoi.
  Future<void> activerCompte({
    required String matricule,
    required String email,
  }) async {
    if (!ApiFlags.authentification) {
      // --- SIMULATION TEMPORAIRE ---
      // Simule l'attente d'un envoi par SMS (réel dans l'API) ET par
      // email (pas encore réel — en attente de l'encadrant).
      await Future.delayed(const Duration(seconds: 1));
      return;
    }
    await ApiClient.instance.dio.post('/active', data: {
      'matricule': matricule,
      // Champ ajouté par anticipation - voir le commentaire ci-dessus.
      'email': email,
    });
  }

  Future<void> deconnecter() async {
    if (!ApiFlags.authentification) return;
    await ApiClient.instance.dio.post('/logout');
  }
}