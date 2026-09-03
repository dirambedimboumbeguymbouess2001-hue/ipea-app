import '../../../core/network/api_client.dart';
import 'scolarite_models.dart';

/// Repository fusionné : remplace les anciens ScolaritesRepository et
/// NotesRepository, suite à la fusion des écrans Scolarité et Notes
/// demandée par l'encadrant.
///
/// IMPORTANT : cette hiérarchie (Classe > Semestre > Modules) ne
/// correspond plus exactement aux 11 endpoints d'origine de la note
/// de cadrage (BTS-NC-2026-01), qui prévoyaient des scolarités "plates"
/// (une par année) et des notes groupées par matière. Une clarification
/// sur la structure réelle de l'API sera nécessaire avec l'encadrant
/// avant le branchement réel — à ce stade, seule l'interface est prête.
class ScolariteRepository {
  Future<List<Classe>> obtenirClasses() async {
    if (!kUtiliserApiReelle) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(seconds: 1));
      return const [
        Classe(
          id: 'l1',
          nom: 'Licence 1',
          semestres: [
            Semestre(
              id: 'l1-s1',
              nom: 'Semestre 1',
              modules: [
                Module(nom: 'Mathématiques', note: 14, credits: 5),
                Module(nom: 'Algorithmique', note: 15, credits: 5),
                Module(nom: 'Anglais', note: 12, credits: 3),
              ],
            ),
            Semestre(
              id: 'l1-s2',
              nom: 'Semestre 2',
              modules: [
                Module(nom: 'Bases de données', note: 13, credits: 5),
                Module(nom: 'Réseaux', note: 11, credits: 4),
                Module(nom: 'Anglais', note: 14, credits: 3),
              ],
            ),
          ],
        ),
        Classe(
          id: 'l2',
          nom: 'Licence 2',
          semestres: [
            Semestre(
              id: 'l2-s1',
              nom: 'Semestre 1',
              modules: [
                Module(nom: 'Module 1', note: 15, credits: 5),
                Module(nom: 'Module 2', note: 13, credits: 4),
                Module(nom: 'Module 3', note: 16, credits: 3),
              ],
            ),
            Semestre(
              id: 'l2-s2',
              nom: 'Semestre 2',
              modules: [
                Module(nom: 'Programmation Flutter', note: 17, credits: 6),
                Module(nom: 'Anglais', note: 12, credits: 3),
              ],
            ),
          ],
        ),
      ];
    }

    final reponse = await ApiClient.instance.dio.get('/scolarites');
    return (reponse.data as List).map((j) => Classe.fromJson(j)).toList();
  }

  /// Pratique pour le tableau de bord : renvoie la dernière classe et
  /// son dernier semestre (par convention, considérés comme "actuels"
  /// en l'absence d'un indicateur explicite côté API).
  Future<(Classe, Semestre)?> obtenirClasseEtSemestreActuels() async {
    final classes = await obtenirClasses();
    if (classes.isEmpty) return null;
    final classeActuelle = classes.last;
    if (classeActuelle.semestres.isEmpty) return null;
    return (classeActuelle, classeActuelle.semestres.last);
  }
}
