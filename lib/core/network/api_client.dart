import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Adresse de base réelle de l'API Mobile, communiquée par l'encadrant.
const String kApiBaseUrl = 'https://api.ipea-gabon.ga/api/mobile';

/// Adresse de base de l'authentification "back-office" (staff/admin),
/// distincte de l'API mobile étudiante — utilisée uniquement par
/// l'espace administration (voir lib/features/administration/).
const String kApiAuthBaseUrl = 'https://api.ipea-gabon.ga/api/auth';

/// Interrupteurs indépendants par domaine fonctionnel.
///
/// Contrairement à un seul interrupteur global, chaque domaine peut être
/// activé séparément dès que sa partie de l'API est prête côté serveur —
/// utile ici car certains endpoints n'ont pas changé (Authentification,
/// Paiements, Profil), tandis que d'autres attendent encore une nouvelle
/// implémentation côté encadrant suite à la fusion Scolarité/Notes et à
/// l'ajout de l'Accueil enrichi / de l'espace administration.
class ApiFlags {
  ApiFlags._();

  /// POST /login, POST /active, POST /logout — endpoints inchangés,
  /// déjà documentés dans la note de cadrage d'origine (BTS-NC-2026-01).
  static const bool authentification = false;

  /// GET /paiements — endpoint inchangé.
  static const bool paiements = false;

  /// GET /profile, PUT /profile, PUT /password — endpoints inchangés
  /// dans leur principe (seule la restriction "email non modifiable"
  /// doit être appliquée côté serveur, voir SPECIFICATION_API_V2.md).
  static const bool profil = false;

  /// Structure Classe > Semestre > Modules — nouvelle forme de réponse
  /// attendue, à faire coder par l'encadrant (voir SPECIFICATION_API_V2.md).
  /// Reste à false tant que cette nouvelle API n'existe pas.
  static const bool scolarite = false;

  /// Annonces de l'établissement sur l'écran d'accueil — endpoint qui
  /// n'existe pas encore du tout, à créer (voir SPECIFICATION_API_V2.md).
  static const bool accueil = false;

  /// Espace administration (annonces, comptes, photos) — endpoints à
  /// créer entièrement (voir SPECIFICATION_API_V2.md).
  static const bool administration = false;
}

const _storage = FlutterSecureStorage();
const _cleToken = 'token_sanctum';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final Dio dio = Dio(BaseOptions(
    baseUrl: kApiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await lireToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

  static Future<String?> lireToken() => _storage.read(key: _cleToken);

  static Future<void> enregistrerToken(String token) =>
      _storage.write(key: _cleToken, value: token);

  static Future<void> effacerToken() => _storage.delete(key: _cleToken);
}
