import '../../../core/network/api_client.dart';

/// Endpoint exact : POST /login (public). Non modifié depuis la note
/// de cadrage d'origine — prêt à passer en réel dès validation de
/// l'encadrant (ApiFlags.authentification).
class AuthRepository {
  Future<String> connecter({required String identifiant, required String motDePasse}) async {
    if (!ApiFlags.authentification) {
      await Future.delayed(const Duration(seconds: 1));
      return 'faux-token-de-test';
    }

    final reponse = await ApiClient.instance.dio.post('/login', data: {
      'identifiant': identifiant,
      'mot_de_passe': motDePasse,
    });

    return reponse.data['token'] as String;
  }

  Future<void> activerCompte({
    required String matricule,
    required String code,
    required String nouveauMotDePasse,
  }) async {
    if (!ApiFlags.authentification) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    await ApiClient.instance.dio.post('/active', data: {
      'matricule': matricule,
      'code': code,
      'mot_de_passe': nouveauMotDePasse,
    });
  }

  Future<void> deconnecter() async {
    if (!ApiFlags.authentification) return;
    await ApiClient.instance.dio.post('/logout');
  }
}
