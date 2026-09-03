/// Un module (matière) au sein d'un semestre, avec sa note et ses crédits.
class Module {
  final String nom;
  final double note;
  final int credits;

  const Module({required this.nom, required this.note, required this.credits});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      nom: json['nom'] as String,
      note: (json['note'] as num).toDouble(),
      credits: json['credits'] as int,
    );
  }
}

/// Un semestre au sein d'une classe, regroupant ses modules.
class Semestre {
  final String id;
  final String nom;
  final List<Module> modules;

  const Semestre({required this.id, required this.nom, required this.modules});

  /// Moyenne simple du semestre (non pondérée par les crédits, pour
  /// rester lisible pour l'étudiant — à ajuster si l'IPEA applique
  /// une autre règle de calcul officielle).
  double get moyenne {
    if (modules.isEmpty) return 0;
    final somme = modules.fold<double>(0, (s, m) => s + m.note);
    return double.parse((somme / modules.length).toStringAsFixed(1));
  }

  int get totalCredits => modules.fold(0, (s, m) => s + m.credits);

  factory Semestre.fromJson(Map<String, dynamic> json) {
    return Semestre(
      id: json['id'] as String,
      nom: json['nom'] as String,
      modules: (json['modules'] as List).map((j) => Module.fromJson(j)).toList(),
    );
  }
}

/// Une classe/année académique effectuée par l'étudiant (ex: "Licence 1"),
/// regroupant ses semestres.
class Classe {
  final String id;
  final String nom;
  final List<Semestre> semestres;

  const Classe({required this.id, required this.nom, required this.semestres});

  factory Classe.fromJson(Map<String, dynamic> json) {
    return Classe(
      id: json['id'] as String,
      nom: json['nom'] as String,
      semestres: (json['semestres'] as List).map((j) => Semestre.fromJson(j)).toList(),
    );
  }
}
