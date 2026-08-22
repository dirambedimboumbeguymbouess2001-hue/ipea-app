import 'tableau_de_bord_models.dart';

/// Porte d'accès unique aux données du tableau de bord.
///
/// IMPORTANT : quand la documentation de l'API sera disponible, seul le
/// contenu de la méthode `obtenirDonnees` devra être modifié (remplacer
/// la simulation ci-dessous par un vrai appel Dio vers l'API). Aucun
/// autre fichier du projet — en particulier l'écran — n'aura besoin
/// d'être touché.
class TableauDeBordRepository {
  Future<TableauDeBordData> obtenirDonnees() async {
    // --- SIMULATION TEMPORAIRE, en attendant la documentation API ---
    // Le délai artificiel imite le temps d'un vrai appel réseau, pour
    // pouvoir tester l'état de chargement dès maintenant.
    await Future.delayed(const Duration(seconds: 1));

    return const TableauDeBordData(
      nomEtudiant: 'Guy Dirambe',
      moyenneGenerale: 14.2,
      resteAPayer: 85000,
      scolariteNom: 'Licence 2 Informatique',
      scolariteAnnee: '2025-2026',
      scolariteStatut: 'Actif',
    );

    // --- CE QUE ÇA DEVIENDRA UNE FOIS L'API DISPONIBLE (exemple) ---
    // final reponse = await dio.get('/tableau-de-bord');
    // return TableauDeBordData.fromJson(reponse.data);
  }
}
