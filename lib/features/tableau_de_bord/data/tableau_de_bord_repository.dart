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

    double moyenne = 0;
    if (inscription != null) {
      final modules = await _scolariteRepository.obtenirModules(inscription.id);
      moyenne = _scolariteRepository.calculerMoyenne(modules);
    }

    return TableauDeBordData(
      prenomEtudiant: profil.prenom,
      boursier: profil.boursier,
      moyenneGenerale: moyenne,
      resteAPayer: situation.resteAPayer,
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