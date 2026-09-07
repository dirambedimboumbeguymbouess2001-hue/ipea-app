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
      nomEtudiant: profil.nomComplet,
      moyenneGenerale: moyenne,
      resteAPayer: situation.resteAPayer,
      scolariteNom: inscription?.libelle ?? '—',
      scolariteAnnee: '',
      scolariteStatut: 'En cours',
    );
  }
}
