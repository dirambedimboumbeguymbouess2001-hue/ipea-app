import '../../scolarites/data/scolarite_repository.dart';
import '../../paiements/data/paiements_repository.dart';
import '../../profil/data/profil_repository.dart';
import 'tableau_de_bord_models.dart';

class TableauDeBordRepository {
  final _scolariteRepository = ScolariteRepository();
  final _paiementsRepository = PaiementsRepository();
  final _profilRepository = ProfilRepository();

  Future<TableauDeBordData> obtenirDonnees() async {
    final profil = await _profilRepository.obtenirProfil();
    final situation = await _paiementsRepository.obtenirSituation();
    final inscription = await _scolariteRepository.obtenirInscriptionActuelle();

    // Règle métier demandée : un étudiant boursier a sa scolarité prise
    // en charge automatiquement, donc pas de reste à payer affiché.
    // ⚠️ HYPOTHÈSE NON CONFIRMÉE PAR L'API - voir QUESTIONS_API.md,
    // point 7. Une vraie bourse partielle pourrait laisser un reste à
    // charge ; à valider avec l'encadrant avant le vrai branchement.
    final resteAPayer = profil.boursier ? 0 : situation.resteAPayer;

    return TableauDeBordData(
      prenomEtudiant: profil.prenom,
      boursier: profil.boursier,
      resteAPayer: resteAPayer,
      scolariteId: inscription?.id,
      scolariteNom: inscription?.libelle ?? 'Aucune inscription',
      scolariteCode: inscription?.code ?? '',
      annonces: _annoncesSimulees(),
    );
  }

  /// --- SIMULATION PERMANENTE, voir tableau_de_bord_models.dart ---
  List<Annonce> _annoncesSimulees() {
    return const [
      Annonce(titre: 'Reprise des cours le 15 septembre', date: '01/09/2026'),
      Annonce(titre: "Clôture des inscriptions administratives", date: '10/09/2026'),
    ];
  }
}
