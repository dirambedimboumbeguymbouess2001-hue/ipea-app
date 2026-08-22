/// Informations de profil de l'étudiant connecté.
class ProfilEtudiant {
  final String nomComplet;
  final String email;
  final String telephone;
  final String matricule;

  const ProfilEtudiant({
    required this.nomComplet,
    required this.email,
    required this.telephone,
    required this.matricule,
  });

  factory ProfilEtudiant.fromJson(Map<String, dynamic> json) {
    return ProfilEtudiant(
      nomComplet: json['nom_complet'] as String,
      email: json['email'] as String,
      telephone: json['telephone'] as String,
      matricule: json['matricule'] as String,
    );
  }

  /// Crée une copie du profil avec certains champs modifiés — pratique
  /// pour appliquer une modification sans recréer tout l'objet à la main.
  ProfilEtudiant copyWith({String? email, String? telephone}) {
    return ProfilEtudiant(
      nomComplet: nomComplet,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      matricule: matricule,
    );
  }
}
