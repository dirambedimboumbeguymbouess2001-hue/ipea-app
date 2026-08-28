import '../../scolarites/data/scolarites_repository.dart';
import '../../paiements/data/paiements_repository.dart';
import '../../notes/data/notes_repository.dart';
import '../../profil/data/profil_repository.dart';
import 'tableau_de_bord_models.dart';

/// IMPORTANT : la note de cadrage (BTS-NC-2026-01) ne prévoit aucun
/// endpoint dédié "tableau de bord" parmi les 11 points d'accès —
/// ces données sont donc composées à partir de quatre appels distincts
/// déjà utilisés ailleurs dans l'application :
/// - GET /profile (pour le nom de l'étudiant)
/// - GET /scolarites (pour la scolarité active)
/// - GET /paiements (pour le reste à payer)
/// - GET /notes/{id} (pour la moyenne générale)
class TableauDeBordRepository {
  final _scolaritesRepository = ScolaritesRepository();
  final _paiementsRepository = PaiementsRepository();
  final _notesRepository = NotesRepository();
  final _profilRepository = ProfilRepository();

  Future<TableauDeBordData> obtenirDonnees() async {
    final profil = await _profilRepository.obtenirProfil();
    final scolariteActive = await _scolaritesRepository.obtenirScolariteActive();
    final situation = await _paiementsRepository.obtenirSituation();

    double moyenneGenerale = 0;
    if (scolariteActive != null) {
      final notes = await _notesRepository.obtenirNotes(scolariteActive.id);
      if (notes.isNotEmpty) {
        // Moyenne pondérée par coefficient, simple et standard.
        final sommePonderee = notes.fold<double>(0, (s, n) => s + n.moyenne * n.coefficient);
        final sommeCoefficients = notes.fold<double>(0, (s, n) => s + n.coefficient);
        moyenneGenerale = sommeCoefficients > 0 ? sommePonderee / sommeCoefficients : 0;
      }
    }

    return TableauDeBordData(
      nomEtudiant: profil.nomComplet,
      moyenneGenerale: double.parse(moyenneGenerale.toStringAsFixed(1)),
      resteAPayer: situation.resteAPayer,
      scolariteNom: scolariteActive != null ? '${scolariteActive.niveau} — ${scolariteActive.filiere}' : '—',
      scolariteAnnee: scolariteActive?.annee ?? '—',
      scolariteStatut: scolariteActive?.statut ?? '—',
    );
  }
}
