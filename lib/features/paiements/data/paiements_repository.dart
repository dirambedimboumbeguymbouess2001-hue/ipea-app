import '../../../core/network/api_client.dart';
import 'paiements_models.dart';

/// Endpoint exact d'après la note de cadrage : GET /api/mobile/paiements
/// (Sanctum) — pas de paramètre d'identifiant, le token identifie
/// déjà l'étudiant côté serveur.
class PaiementsRepository {
  Future<SituationPaiements> obtenirSituation() async {
    if (!kUtiliserApiReelle) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(seconds: 1));
      return SituationPaiements(
        montantTotal: 450000,
        montantPaye: 365000,
        resteAPayer: 85000,
        historique: [
          Paiement(libelle: 'Acompte 1', montant: 200000, date: DateTime(2026, 9, 15), statut: 'Payé'),
          Paiement(libelle: 'Acompte 2', montant: 165000, date: DateTime(2026, 11, 10), statut: 'Payé'),
          Paiement(libelle: 'Solde final', montant: 85000, date: DateTime(2027, 1, 20), statut: 'En attente'),
        ],
      );
    }

    final reponse = await ApiClient.instance.dio.get('/paiements');
    return SituationPaiements.fromJson(reponse.data);
  }
}
