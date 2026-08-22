import 'paiements_models.dart';

/// Porte d'accès unique à la situation financière de l'étudiant.
///
/// IMPORTANT : seul le contenu de `obtenirSituation` devra être remplacé
/// une fois la documentation API disponible.
class PaiementsRepository {
  Future<SituationPaiements> obtenirSituation(String etudiantId) async {
    // --- SIMULATION TEMPORAIRE ---
    await Future.delayed(const Duration(seconds: 1));

    return SituationPaiements(
      montantTotal: 450000,
      montantPaye: 365000,
      resteAPayer: 85000,
      historique: [
        Paiement(
          libelle: 'Acompte 1',
          montant: 200000,
          date: DateTime(2026, 9, 15),
          statut: 'Payé',
        ),
        Paiement(
          libelle: 'Acompte 2',
          montant: 165000,
          date: DateTime(2026, 11, 10),
          statut: 'Payé',
        ),
        Paiement(
          libelle: 'Solde final',
          montant: 85000,
          date: DateTime(2027, 1, 20),
          statut: 'En attente',
        ),
      ],
    );

    // --- CE QUE ÇA DEVIENDRA AVEC L'API (exemple) ---
    // final reponse = await dio.get('/paiements/$etudiantId');
    // return SituationPaiements.fromJson(reponse.data);
  }
}
