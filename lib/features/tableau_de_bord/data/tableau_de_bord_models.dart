/// Une annonce affichée sur le tableau de bord.
///
/// ⚠️ SIMULATION PERMANENTE : contrairement aux autres données de cette
/// classe, il n'existe AUCUN endpoint "annonces" dans la vraie API
/// (vérifié dans document.json - aucune route ne correspond). Cette
/// fonctionnalité ne pourra pas être branchée sans qu'un endpoint dédié
/// soit d'abord créé côté backend — voir QUESTIONS_API.md, point 6.
class Annonce {
  const Annonce({required this.titre, required this.date});
  final String titre;
  final String date;
}

/// Données affichées sur le tableau de bord, assemblées à partir des
/// repositories réels de chaque fonctionnalité (profil, scolarité,
/// paiements) plutôt que dupliquées ici — une seule source de vérité
/// par donnée.
///
/// Pas de champ "moyenne générale" : retiré volontairement, la donnée
/// simulée était ambiguë (quel semestre ? quelle année ?) et risquait
/// d'induire en erreur tant qu'aucun relevé de notes réel n'existe.
class TableauDeBordData {
  final String prenomEtudiant;
  final bool boursier;
  final int resteAPayer;
  final String? scolariteId;
  final String scolariteNom;
  final String scolariteCode;
  final List<Annonce> annonces;

  const TableauDeBordData({
    required this.prenomEtudiant,
    required this.boursier,
    required this.resteAPayer,
    required this.scolariteId,
    required this.scolariteNom,
    required this.scolariteCode,
    required this.annonces,
  });
}
