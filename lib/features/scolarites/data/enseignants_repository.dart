import '../../../core/network/api_client.dart';

class Enseignant {
  final String nom;
  final String matiere;
  final String email;

  const Enseignant({required this.nom, required this.matiere, required this.email});

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      nom: json['nom'] as String,
      matiere: json['matiere'] as String,
      email: json['email'] as String,
    );
  }
}

/// Endpoint exact d'après la note de cadrage : GET /api/mobile/enseignants/{id} (Sanctum)
class EnseignantsRepository {
  Future<List<Enseignant>> obtenirEnseignants(String inscriptionId) async {
    if (!kUtiliserApiReelle) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(seconds: 1));
      return const [
        Enseignant(nom: 'M. Obiang Ndong', matiere: 'Mathématiques', email: 'obiang.ndong@ipea.ga'),
        Enseignant(nom: 'Mme Bibang Ella', matiere: 'Programmation Flutter', email: 'bibang.ella@ipea.ga'),
        Enseignant(nom: 'M. Mba Allogho', matiere: 'Anglais', email: 'mba.allogho@ipea.ga'),
      ];
    }

    final reponse = await ApiClient.instance.dio.get('/enseignants/$inscriptionId');
    return (reponse.data as List).map((j) => Enseignant.fromJson(j)).toList();
  }
}
