import '../../scolarites/data/scolarite_repository.dart';
import '../../paiements/data/paiements_repository.dart';
import '../../profil/data/profil_repository.dart';
import 'tableau_de_bord_models.dart';

/// Compose les données du tableau de bord depuis trois sources
/// distinctes (aucun endpoint dédié dans la note de cadrage) :
/// - GET /profile (nom de l'étudiant)
/// - GET /scolarites (classe et semestre actuels, moyenne)
/// - GET /paiements (reste à payer)
class TableauDeBordRepository {
  final _scolariteRepository = ScolariteRepository();
  final _paiementsRepository = PaiementsRepository();
  final _profilRepository = ProfilRepository();

  Future<TableauDeBordData> obtenirDonnees() async {
    final profil = await _profilRepository.obtenirProfil();
    final situation = await _paiementsRepository.obtenirSituation();
    final actuel = await _scolariteRepository.obtenirClasseEtSemestreActuels();

    return TableauDeBordData(
      nomEtudiant: profil.nomComplet,
      moyenneGenerale: actuel?.$2.moyenne ?? 0,
      resteAPayer: situation.resteAPayer,
      scolariteNom: actuel != null ? '${actuel.$1.nom} — ${actuel.$2.nom}' : '—',
      scolariteAnnee: '', // Non pertinent avec la nouvelle structure Classe/Semestre
      scolariteStatut: 'En cours',
    );
  }
}
