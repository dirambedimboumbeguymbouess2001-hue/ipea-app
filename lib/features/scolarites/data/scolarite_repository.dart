import '../../../core/network/api_client.dart';
import 'scolarite_models.dart';

/// Structure Classe > Semestre > Modules — nouvelle forme de réponse,
/// pas encore implémentée côté serveur. Reste en simulation
/// (ApiFlags.scolarite) tant que l'encadrant n'a pas codé cette
/// nouvelle version de l'endpoint /scolarites — voir
/// SPECIFICATION_API_V2.md pour le contrat attendu exact.
class ScolariteRepository {
  Future<List<Classe>> obtenirClasses() async {
    if (!ApiFlags.scolarite) {
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

  Future<(Classe, Semestre)?> obtenirClasseEtSemestreActuels() async {
    final classes = await obtenirClasses();
    if (classes.isEmpty) return null;
    final classeActuelle = classes.last;
    if (classeActuelle.semestres.isEmpty) return null;
    return (classeActuelle, classeActuelle.semestres.last);
  }
}
