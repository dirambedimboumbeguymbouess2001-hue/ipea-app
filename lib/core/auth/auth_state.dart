import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// État d'authentification global de l'application, accessible partout
/// via `AuthState.instance`. Gère la session de l'étudiant et sa
/// persistance entre deux lancements de l'application (via SharedPreferences).
///
/// C'est un ChangeNotifier : GoRouter peut "l'écouter" (refreshListenable)
/// pour réévaluer automatiquement les routes autorisées à chaque
/// changement d'état de connexion.
class AuthState extends ChangeNotifier {
  AuthState._();
  static final AuthState instance = AuthState._();

  bool _estConnecte = false;
  bool _estInitialise = false;

  bool get estConnecte => _estConnecte;

  /// Tant que estInitialise est false, on ne sait pas encore si une
  /// session existait déjà (lecture de SharedPreferences en cours) —
  /// le routeur doit attendre avant de rediriger quoi que ce soit.
  bool get estInitialise => _estInitialise;

  Future<void> initialiser() async {
    final prefs = await SharedPreferences.getInstance();
    _estConnecte = prefs.getBool('est_connecte') ?? false;
    _estInitialise = true;
    notifyListeners();
  }

  Future<void> connecter() async {
    _estConnecte = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('est_connecte', true);
  }

  Future<void> deconnecter() async {
    _estConnecte = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('est_connecte', false);
  }
}
