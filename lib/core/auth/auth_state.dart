import 'package:flutter/foundation.dart';
import '../network/api_client.dart';

/// État d'authentification global. Le token Sanctum est désormais stocké
/// via flutter_secure_storage (chiffré), conformément à la note de
/// cadrage — shared_preferences reste réservé aux préférences simples,
/// jamais à des données sensibles comme un token d'accès.
class AuthState extends ChangeNotifier {
  AuthState._();
  static final AuthState instance = AuthState._();

  bool _estConnecte = false;
  bool _estInitialise = false;

  bool get estConnecte => _estConnecte;
  bool get estInitialise => _estInitialise;

  Future<void> initialiser() async {
    final token = await ApiClient.lireToken();
    _estConnecte = token != null;
    _estInitialise = true;
    notifyListeners();
  }

  /// À appeler uniquement après une réponse de connexion réussie de
  /// l'API (POST /login), avec le token Sanctum reçu.
  Future<void> connecter(String token) async {
    await ApiClient.enregistrerToken(token);
    _estConnecte = true;
    notifyListeners();
  }

  Future<void> deconnecter() async {
    await ApiClient.effacerToken();
    _estConnecte = false;
    notifyListeners();
  }
}
