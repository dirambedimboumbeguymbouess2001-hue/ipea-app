/// Une note obtenue dans un module, pour une inscription donnée.
/// Reste simulé (voir scolarite_repository.dart) tant que la forme réelle
/// de GET /notes/{inscription} n'est pas documentée par l'encadrant.
class Module {
  const Module({
    required this.nom,
    required this.note,
    required this.credits,
  });

  final String nom;
  final double note;
  final int credits;
}

/// Une inscription de l'étudiant à une classe/année donnée.
///
/// Remplace l'ancien couple Classe/Semestre imbriqué : la vraie API renvoie
/// une liste PLATE de classes (ClasseMobileResource), sans semestres
/// imbriqués. D'où la structure à 2 niveaux : Inscription -> Modules.
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
