/// Informations de profil de l'étudiant connecté.
///
/// Pas de champ `email` : il n'existe pas dans la vraie API
/// (EtudiantResource). Ne jamais le réintroduire sans confirmation
/// contraire de l'encadrant.
class ProfilEtudiant {
  const ProfilEtudiant({
    required this.id,
    required this.matricule,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.photo,
  });

  final String id;
  final String matricule;
  final String nom;
  final String prenom;
  final String telephone;
  final String? photo;

  /// Nom et prénom assemblés, prêts à afficher.
  String get nomComplet => '$prenom $nom';

  factory ProfilEtudiant.fromJson(Map<String, dynamic> json) {
    return ProfilEtudiant(
      id: json['id'].toString(),
      matricule: json['matricule'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      telephone: (json['telephone'] ?? '').toString(),
      photo: json['photo'] as String?,
    );
  }

  /// Crée une copie du profil avec le téléphone modifié — pratique pour
  /// mettre à jour l'affichage sans tout recréer à la main.
  ProfilEtudiant copyWith({String? telephone}) {
    return ProfilEtudiant(
      id: id,
      matricule: matricule,
      nom: nom,
      prenom: prenom,
      telephone: telephone ?? this.telephone,
      photo: photo,
    );
  }
}