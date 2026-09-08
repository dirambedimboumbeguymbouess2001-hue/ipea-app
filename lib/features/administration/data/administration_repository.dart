import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

/// Repository de l'espace administration (staff IPEA).
///
/// Utilise une authentification DISTINCTE de celle des étudiants
/// (POST /auth/login, email + password, à la racine `/api/auth` et non
/// `/api/mobile`) — voir QUESTIONS_API.md, point 5.
///
/// ⚠️ Le champ "role" renvoyé par cette route (confirmant qu'il s'agit
/// bien de l'authentification staff, et distinguant les niveaux d'accès)
/// n'a jamais été confirmé par l'encadrant. Cette connexion sert donc
/// aujourd'hui de simple porte d'entrée (email+password valides = accès
/// à l'espace administration), sans distinction de rôle.
class AdministrationRepository {
  /// Connecte un membre du staff. Ne stocke PAS de jeton de façon
  /// persistante : contrairement à AuthState (étudiant), la session
  /// admin ne survit pas à la fermeture de l'app pour l'instant - à
  /// discuter si un vrai usage prolongé est nécessaire.
  Future<void> connecter({
    required String email,
    required String motDePasse,
  }) async {
    if (!ApiFlags.administration) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    final dio = Dio();
    final reponse = await dio.post(
      '$kApiAuthBaseUrl/login',
      data: {'email': email, 'password': motDePasse},
    );

    if (reponse.data['success'] != true) {
      throw Exception('Échec de la connexion administration');
    }
  }
}
