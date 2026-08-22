import 'scolarites_models.dart';

/// Porte d'accès unique aux scolarités (parcours) de l'étudiant.
///
/// IMPORTANT : seul le contenu de `obtenirScolarites` devra être remplacé
/// une fois la documentation API disponible.
class ScolaritesRepository {
  Future<List<Scolarite>> obtenirScolarites(String etudiantId) async {
    // --- SIMULATION TEMPORAIRE ---
    await Future.delayed(const Duration(seconds: 1));

    return const [
      Scolarite(
        id: '1',
        filiere: 'Informatique',
        niveau: 'Licence 2',
        annee: '2025-2026',
        statut: 'Actif',
      ),
      Scolarite(
        id: '2',
        filiere: 'Informatique',
        niveau: 'Licence 1',
        annee: '2024-2025',
        statut: 'Terminé',
      ),
    ];

    // --- CE QUE ÇA DEVIENDRA AVEC L'API (exemple) ---
    // final reponse = await dio.get('/inscriptions/$etudiantId');
    // return (reponse.data as List).map((j) => Scolarite.fromJson(j)).toList();
  }
}
