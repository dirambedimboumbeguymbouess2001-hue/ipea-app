/// Une ligne de paiement individuelle (un versement effectué ou attendu).
class Paiement {
  final String libelle;
  final int montant;
  final DateTime date;
  final String statut; // "Payé", "En attente", "En retard"

  const Paiement({
    required this.libelle,
    required this.montant,
    required this.date,
    required this.statut,
  });

  factory Paiement.fromJson(Map<String, dynamic> json) {
    return Paiement(
      libelle: json['libelle'] as String,
      montant: json['montant'] as int,
      date: DateTime.parse(json['date'] as String),
      statut: json['statut'] as String,
    );
  }
}

/// Résumé global de la situation financière de l'étudiant, avec l'historique.
class SituationPaiements {
  final int montantTotal;
  final int montantPaye;
  final int resteAPayer;
  final List<Paiement> historique;

  const SituationPaiements({
    required this.montantTotal,
    required this.montantPaye,
    required this.resteAPayer,
    required this.historique,
  });

  factory SituationPaiements.fromJson(Map<String, dynamic> json) {
    return SituationPaiements(
      montantTotal: json['montant_total'] as int,
      montantPaye: json['montant_paye'] as int,
      resteAPayer: json['reste_a_payer'] as int,
      historique: (json['historique'] as List)
          .map((e) => Paiement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
