import 'package:go_router/go_router.dart';
import '../../features/demarrage/demarrage_screen.dart';
import '../../features/connexion/connexion_screen.dart';
import '../../features/activation/activation_screen.dart';
import '../../features/tableau_de_bord/tableau_de_bord_screen.dart';
import '../../features/scolarites/scolarites_screen.dart';
import '../../features/scolarites/detail_inscription_screen.dart';
import '../../features/notes/notes_screen.dart';
import '../../features/paiements/paiements_screen.dart';
import '../../features/profil/profil_screen.dart';

/// Routeur centralisé de l'application. Toutes les routes de navigation
/// sont déclarées ici — aucun écran ne doit naviguer "en dur" sans
/// passer par les chemins définis dans ce fichier.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DemarrageScreen(),
      ),
      GoRoute(
        path: '/connexion',
        builder: (context, state) => const ConnexionScreen(),
      ),
      GoRoute(
        path: '/activation',
        builder: (context, state) => const ActivationScreen(),
      ),
      GoRoute(
        path: '/tableau-de-bord',
        builder: (context, state) => const TableauDeBordScreen(),
      ),
      GoRoute(
        path: '/scolarites',
        builder: (context, state) => const ScolaritesScreen(),
      ),
      GoRoute(
        // ":id" est un paramètre dynamique — l'identifiant de l'inscription
        // concernée est récupéré via state.pathParameters['id']
        path: '/scolarites/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailInscriptionScreen(inscriptionId: id);
        },
      ),
      GoRoute(
        path: '/notes',
        builder: (context, state) => const NotesScreen(),
      ),
      GoRoute(
        path: '/paiements',
        builder: (context, state) => const PaiementsScreen(),
      ),
      GoRoute(
        path: '/profil',
        builder: (context, state) => const ProfilScreen(),
      ),
    ],
  );
}
