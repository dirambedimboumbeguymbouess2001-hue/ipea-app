/// Représente les données affichées sur le tableau de bord.
/// Cette classe ne change jamais, que les données viennent de fausses
/// valeurs (aujourd'hui) ou de l'API réelle (plus tard).
class TableauDeBordData {
  final String nomEtudiant;
  final double moyenneGenerale;
  final int resteAPayer;
  final String scolariteNom;
  final String scolariteAnnee;
  final String scolariteStatut;

  const TableauDeBordData({
    required this.nomEtudiant,
    required this.moyenneGenerale,
    required this.resteAPayer,
    required this.scolariteNom,
    required this.scolariteAnnee,
    required this.scolariteStatut,
  });

  /// Construit l'objet à partir d'un JSON — utilisé quand l'API sera branchée.
  factory TableauDeBordData.fromJson(Map<String, dynamic> json) {
    return TableauDeBordData(
      nomEtudiant: json['nom_etudiant'] as String,
      moyenneGenerale: (json['moyenne_generale'] as num).toDouble(),
      resteAPayer: json['reste_a_payer'] as int,
      scolariteNom: json['scolarite_nom'] as String,
      scolariteAnnee: json['scolarite_annee'] as String,
      scolariteStatut: json['scolarite_statut'] as String,
    );
  }
}
