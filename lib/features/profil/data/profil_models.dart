/// Informations de profil de l'étudiant connecté.
///
/// `email` reste nullable et n'est pas encore renvoyé par la vraie API
/// (EtudiantResource n'a pas ce champ à ce jour) — voir QUESTIONS_API.md,
/// point 2. Le champ est prévu ici par anticipation, pour ne pas avoir à
/// retoucher le modèle une fois le backend mis à jour.
class ProfilEtudiant {
  const ProfilEtudiant({
    required this.id,
    required this.matricule,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.boursier,
    this.photo,
    this.email,
  });

  final String id;
  final String matricule;
  final String nom;
  final String prenom;
  final String telephone;
  final bool boursier;
  final String? photo;
  final String? email;

  /// Nom et prénom assemblés, prêts à afficher.
  String get nomComplet => '$prenom $nom';

  factory ProfilEtudiant.fromJson(Map<String, dynamic> json) {
    return ProfilEtudiant(
      id: json['id'].toString(),
      matricule: json['matricule'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      telephone: (json['telephone'] ?? '').toString(),
      boursier: json['boursier'] == 'oui',
      photo: json['photo'] as String?,
      // Absent de la vraie API aujourd'hui - lecture défensive pour le
      // jour où le champ sera ajouté côté backend.
      email: json['email'] as String?,
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
      boursier: boursier,
      photo: photo,
      email: email,
    );
  }
}