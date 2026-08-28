import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Interrupteur central : tant que `false`, tous les repositories
/// continuent d'utiliser leurs données fictives. Une fois l'adresse
/// de l'environnement de recette obtenue auprès de l'encadrant,
/// passer à `true` et renseigner [kApiBaseUrl] ci-dessous.
const bool kUtiliserApiReelle = false;

/// Adresse de base de l'API Mobile (module Laravel Sanctum), telle que
/// décrite dans la note de cadrage BTS-NC-2026-01 (section 4).
/// TODO : remplacer par l'adresse réelle de l'environnement de recette
/// fournie par l'encadrant.
const String kApiBaseUrl = 'https://TODO-A-COMPLETER.exemple.com/api/mobile';

const _storage = FlutterSecureStorage();
const _cleToken = 'token_sanctum';

/// Client Dio unique, partagé par tous les repositories. Ajoute
/// automatiquement le token Sanctum (Bearer) à chaque requête sortante,
/// et stocke le token de façon chiffrée via flutter_secure_storage,
/// conformément à la note de cadrage (section 6).
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
