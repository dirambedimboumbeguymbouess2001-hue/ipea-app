import '../../../core/network/api_client.dart';
import 'scolarite_models.dart';

class ScolariteRepository {
  /// Retourne la liste des inscriptions de l'étudiant, la plus récente en
  /// premier n'est PAS garantie ici : c'est l'écran (scolarites_screen.dart)
  /// qui applique `.reversed` pour l'affichage.
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

  /// Modules (notes) d'une inscription donnée.
  /// Reste TOUJOURS simulé : la forme réelle de GET /notes/{inscription}
  /// n'est pas documentée dans le fichier OpenAPI fourni (Scramble n'a pas
  /// pu l'analyser). Ne pas activer de flag ici tant qu'on n'a pas
  /// d'exemple JSON concret de l'encadrant.
  Future<List<Module>> obtenirModules(String inscriptionId) async {
    // --- SIMULATION TEMPORAIRE ---
    await Future.delayed(const Duration(milliseconds: 800));
    return const [
      Module(nom: 'Algorithmique avancée', note: 15.5, credits: 6),
      Module(nom: 'Bases de données', note: 13.0, credits: 5),
      Module(nom: 'Réseaux', note: 11.5, credits: 4),
      Module(nom: 'Anglais technique', note: 16.0, credits: 3),
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
