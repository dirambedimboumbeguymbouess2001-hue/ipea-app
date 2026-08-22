/// Une scolarité (parcours d'inscription) de l'étudiant pour une année donnée.
class Scolarite {
  final String id;
  final String filiere;
  final String niveau;
  final String annee;
  final String statut; // "Actif", "Terminé", "Suspendu"

  const Scolarite({
    required this.id,
    required this.filiere,
    required this.niveau,
    required this.annee,
    required this.statut,
  });

  factory Scolarite.fromJson(Map<String, dynamic> json) {
    return Scolarite(
      id: json['id'] as String,
      filiere: json['filiere'] as String,
      niveau: json['niveau'] as String,
      annee: json['annee'] as String,
      statut: json['statut'] as String,
    );
  }
}
