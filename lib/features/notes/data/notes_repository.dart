import '../../../core/network/api_client.dart';
import 'notes_models.dart';

/// Endpoint exact d'après la note de cadrage : GET /api/mobile/notes/{id} (Sanctum)
class NotesRepository {
  Future<List<NoteMatiere>> obtenirNotes(String inscriptionId) async {
    if (!kUtiliserApiReelle) {
      // --- SIMULATION TEMPORAIRE ---
      await Future.delayed(const Duration(seconds: 1));
      return const [
        NoteMatiere(
          nomMatiere: 'Mathématiques',
          coefficient: 3,
          moyenne: 15.5,
          evaluations: [
            Evaluation(intitule: 'Devoir 1', valeur: 14, bareme: 20),
            Evaluation(intitule: 'Examen', valeur: 16, bareme: 20),
          ],
        ),
        NoteMatiere(
          nomMatiere: 'Programmation Flutter',
          coefficient: 4,
          moyenne: 17,
          evaluations: [
            Evaluation(intitule: 'Projet', valeur: 18, bareme: 20),
            Evaluation(intitule: 'Contrôle continu', valeur: 16, bareme: 20),
          ],
        ),
        NoteMatiere(
          nomMatiere: 'Anglais',
          coefficient: 2,
          moyenne: 9.5,
          evaluations: [
            Evaluation(intitule: 'Oral', valeur: 10, bareme: 20),
            Evaluation(intitule: 'Écrit', valeur: 9, bareme: 20),
          ],
        ),
      ];
    }

    final reponse = await ApiClient.instance.dio.get('/notes/$inscriptionId');
    return (reponse.data as List).map((j) => NoteMatiere.fromJson(j)).toList();
  }
}
