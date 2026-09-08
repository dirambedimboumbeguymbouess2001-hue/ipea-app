import '../../../core/network/api_client.dart';
import 'scolarite_models.dart';

class ScolariteRepository {
  /// Retourne la liste des inscriptions de l'étudiant.
  Future<List<Inscription>> obtenirInscriptions() async {
    if (!ApiFlags.scolarite) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(milliseconds: 800));
      return const [
        Inscription(id: '1', idClasse: '2', libelle: 'Terminale D', code: 'TLE-D'),
        Inscription(id: '2', idClasse: '8', libelle: 'L1 Informatique', code: 'L1-INFO'),
        Inscription(id: '3', idClasse: '12', libelle: 'L2 Informatique', code: 'L2-INFO'),
      ];
    }
    final reponse = await ApiClient.instance.dio.get('/scolarites');
    final liste = reponse.data['data'] as List;
    return liste
        .map((e) => Inscription.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// L'inscription "en cours" utilisée sur le tableau de bord : par
  /// convention la dernière de la liste (la plus récente).
  Future<Inscription?> obtenirInscriptionActuelle() async {
    final inscriptions = await obtenirInscriptions();
    if (inscriptions.isEmpty) return null;
    return inscriptions.last;
  }

  /// Calcule les deux numéros de semestre correspondant à un niveau,
  /// selon la règle interne de l'IPEA : L1 -> semestres 1 et 2,
  /// L2 -> semestres 3 et 4, L3 -> semestres 5 et 6.
  ///
  /// Se base sur le CODE réel de la classe (ex: "L2-INFO", "L1-INFO") -
  /// c'est une vraie donnée de l'API. Le résultat sert uniquement à
  /// étiqueter/regrouper les modules simulés (voir obtenirModules) tant
  /// que la vraie structure des notes n'est pas connue.
  (int premier, int second) semestresPourNiveau(String code) {
    final normalise = code.toUpperCase();
    if (normalise.startsWith('L1')) return (1, 2);
    if (normalise.startsWith('L2')) return (3, 4);
    if (normalise.startsWith('L3')) return (5, 6);
    // Repli par défaut si le code ne suit pas le format L<niveau>-...
    return (1, 2);
  }

  /// Modules (notes) d'une inscription, répartis sur ses deux semestres.
  ///
  /// Reste TOUJOURS simulé : la forme réelle de GET /notes/{inscription}
  /// n'est pas documentée dans le fichier OpenAPI fourni (typée comme un
  /// simple `string` - Scramble n'a rien pu déduire). On ne sait donc pas
  /// si un vrai champ "semestre" existe par module - voir
  /// QUESTIONS_API.md, point 3.
  Future<List<Module>> obtenirModules(
    String inscriptionId, {
    required int premierSemestre,
    required int deuxiemeSemestre,
  }) async {
    // --- SIMULATION TEMPORAIRE ---
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      Module(nom: 'Algorithmique avancée', note: 15.5, credits: 6, semestre: premierSemestre),
      Module(nom: 'Bases de données', note: 13.0, credits: 5, semestre: premierSemestre),
      Module(nom: 'Anglais technique', note: 16.0, credits: 3, semestre: premierSemestre),
      Module(nom: 'Réseaux', note: 11.5, credits: 4, semestre: deuxiemeSemestre),
      Module(nom: 'Génie logiciel', note: 14.0, credits: 6, semestre: deuxiemeSemestre),
      Module(nom: 'Anglais technique 2', note: 15.0, credits: 3, semestre: deuxiemeSemestre),
    ];
  }

  /// Moyenne pondérée par les crédits.
  double calculerMoyenne(List<Module> modules) {
    if (modules.isEmpty) return 0;
    final totalPondere = modules.fold<double>(
      0,
      (somme, module) => somme + module.note * module.credits,
    );
    final totalCredits = calculerTotalCredits(modules);
    if (totalCredits == 0) return 0;
    return totalPondere / totalCredits;
  }

  int calculerTotalCredits(List<Module> modules) {
    return modules.fold<int>(0, (somme, module) => somme + module.credits);
  }
}
