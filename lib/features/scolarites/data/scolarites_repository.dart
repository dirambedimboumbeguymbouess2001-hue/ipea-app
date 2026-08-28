import '../../../core/network/api_client.dart';
import 'scolarites_models.dart';

/// Endpoints exacts d'après la note de cadrage :
/// - GET /api/mobile/scolarites (Sanctum) — liste
/// - GET /api/mobile/inscriptions/{id} (Sanctum) — détail
class ScolaritesRepository {
  Future<List<Scolarite>> obtenirScolarites() async {
    if (!kUtiliserApiReelle) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(seconds: 1));
      return const [
        Scolarite(id: '1', filiere: 'Informatique', niveau: 'Licence 2', annee: '2025-2026', statut: 'Actif'),
        Scolarite(id: '2', filiere: 'Informatique', niveau: 'Licence 1', annee: '2024-2025', statut: 'Terminé'),
      ];
    }

    final reponse = await ApiClient.instance.dio.get('/scolarites');
    return (reponse.data as List).map((j) => Scolarite.fromJson(j)).toList();
  }

  Future<Scolarite?> obtenirDetail(String inscriptionId) async {
    if (!kUtiliserApiReelle) {
      final toutes = await obtenirScolarites();
      return toutes.where((s) => s.id == inscriptionId).firstOrNull;
    }

    final reponse = await ApiClient.instance.dio.get('/inscriptions/$inscriptionId');
    return Scolarite.fromJson(reponse.data);
  }

  /// Pratique pour le tableau de bord : renvoie la scolarité marquée
  /// "Actif" parmi la liste, ou la première si aucune ne l'est.
  Future<Scolarite?> obtenirScolariteActive() async {
    final toutes = await obtenirScolarites();
    if (toutes.isEmpty) return null;
    return toutes.where((s) => s.statut == 'Actif').firstOrNull ?? toutes.first;
  }
}
