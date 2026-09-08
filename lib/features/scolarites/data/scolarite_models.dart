/// Une note obtenue dans un module, pour un semestre donné.
/// Reste simulé (voir scolarite_repository.dart) tant que la forme réelle
/// de GET /notes/{inscription} n'est pas documentée par l'encadrant — y
/// compris la présence ou non d'un vrai champ "semestre" par module.
class Module {
  const Module({
    required this.nom,
    required this.note,
    required this.credits,
    required this.semestre,
  });

  final String nom;
  final double note;
  final int credits;

  /// Numéro de semestre (1 à 6). Simulé : calculé côté app à partir du
  /// code de la classe (règle IPEA : L1 -> 1-2, L2 -> 3-4, L3 -> 5-6),
  /// pas une vraie donnée renvoyée par l'API.
  final int semestre;
}

/// Une inscription de l'étudiant à une classe/année donnée.
///
/// La vraie API renvoie une liste PLATE de classes (une par année), sans
/// semestres imbriqués : la répartition en semestres se fait uniquement
/// au niveau de l'affichage des modules (voir Module.semestre ci-dessus).
class Inscription {
  const Inscription({
    required this.id,
    required this.idClasse,
    required this.libelle,
    required this.code,
  });

  final String id;
  final String idClasse;
  final String libelle;
  final String code;

  factory Inscription.fromJson(Map<String, dynamic> json) {
    return Inscription(
      id: json['id'].toString(),
      idClasse: json['id_classe'].toString(),
      libelle: json['libelle'] as String,
      code: json['code'] as String,
    );
  }
}
