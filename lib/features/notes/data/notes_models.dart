/// Une évaluation individuelle au sein d'une matière (ex: un devoir, un examen).
class Evaluation {
  final String intitule;
  final double valeur;
  final double bareme;

  const Evaluation({
    required this.intitule,
    required this.valeur,
    required this.bareme,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      intitule: json['intitule'] as String,
      valeur: (json['valeur'] as num).toDouble(),
      bareme: (json['bareme'] as num).toDouble(),
    );
  }
}

/// Regroupe toutes les évaluations d'une matière, avec sa moyenne.
class NoteMatiere {
  final String nomMatiere;
  final double coefficient;
  final double moyenne;
  final List<Evaluation> evaluations;

  const NoteMatiere({
    required this.nomMatiere,
    required this.coefficient,
    required this.moyenne,
    required this.evaluations,
  });

  factory NoteMatiere.fromJson(Map<String, dynamic> json) {
    return NoteMatiere(
      nomMatiere: json['nom_matiere'] as String,
      coefficient: (json['coefficient'] as num).toDouble(),
      moyenne: (json['moyenne'] as num).toDouble(),
      evaluations: (json['evaluations'] as List)
          .map((e) => Evaluation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
