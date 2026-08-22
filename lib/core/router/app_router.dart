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
import 'main_shell.dart';

/// Routeur centralisé de l'application.
///
/// Deux catégories de routes :
/// - Routes "hors coquille" (démarrage, connexion, activation) : plein écran,
///   sans barre de navigation, avant que l'utilisateur soit connecté.
/// - Routes "dans la coquille" (tableau de bord, scolarités, notes, profil) :
///   affichées avec la barre de navigation basse persistante, via
///   StatefulShellRoute, qui conserve l'état de chaque onglet.
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

      // Paiements reste accessible en poussant un nouvel écran par-dessus
      // (depuis le tableau de bord ou les scolarités), sans faire partie
      // de la barre de navigation basse — comme prévu par la maquette.
      GoRoute(
        path: '/paiements',
        builder: (context, state) => const PaiementsScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Onglet 1 : Accueil / Tableau de bord
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tableau-de-bord',
                builder: (context, state) => const TableauDeBordScreen(),
              ),
            ],
          ),
          // Onglet 2 : Scolarité
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/scolarites',
                builder: (context, state) => const ScolaritesScreen(),
                routes: [
                  // Route imbriquée : /scolarites/:id, reste dans le même onglet
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return DetailInscriptionScreen(inscriptionId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Onglet 3 : Notes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notes',
                builder: (context, state) => const NotesScreen(),
              ),
            ],
          ),
          // Onglet 4 : Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profil',
                builder: (context, state) => const ProfilScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
