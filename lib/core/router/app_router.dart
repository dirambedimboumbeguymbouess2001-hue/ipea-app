import 'package:go_router/go_router.dart';
import '../auth/auth_state.dart';
import '../../features/demarrage/demarrage_screen.dart';
import '../../features/connexion/connexion_screen.dart';
import '../../features/activation/activation_screen.dart';
import '../../features/tableau_de_bord/tableau_de_bord_screen.dart';
import '../../features/scolarites/scolarites_screen.dart';
import '../../features/scolarites/detail_inscription_screen.dart';
import '../../features/scolarites/enseignants_screen.dart';
import '../../features/notes/notes_screen.dart';
import '../../features/paiements/paiements_screen.dart';
import '../../features/profil/profil_screen.dart';
import 'main_shell.dart';

/// Routeur centralisé de l'application, avec garde de route :
/// - Un utilisateur non connecté ne peut accéder qu'à /, /connexion, /activation
/// - Un utilisateur connecté est automatiquement renvoyé vers le tableau
///   de bord s'il tente d'accéder à ces routes "publiques"
class AppRouter {
  AppRouter._();

  static GoRouter creerRouteur(AuthState authState) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authState,
      redirect: (context, state) {
        // Tant que SharedPreferences n'a pas fini d'être lu, on ne
        // redirige rien, pour éviter un aller-retour visuel trompeur.
        if (!authState.estInitialise) return null;

        final chemin = state.matchedLocation;
        final routesPubliques = chemin == '/connexion' || chemin == '/activation';
        final estSurDemarrage = chemin == '/';

        if (!authState.estConnecte && !routesPubliques && !estSurDemarrage) {
          return '/connexion';
        }

        if (authState.estConnecte && routesPubliques) {
          return '/tableau-de-bord';
        }

        return null;
      },
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
          path: '/paiements',
          builder: (context, state) => const PaiementsScreen(),
        ),

        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/tableau-de-bord',
                  builder: (context, state) => const TableauDeBordScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/scolarites',
                  builder: (context, state) => const ScolaritesScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return DetailInscriptionScreen(inscriptionId: id);
                      },
                      routes: [
                        // Route imbriquée : /scolarites/:id/enseignants
                        GoRoute(
                          path: 'enseignants',
                          builder: (context, state) {
                            final id = state.pathParameters['id']!;
                            return EnseignantsScreen(inscriptionId: id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/notes',
                  builder: (context, state) => const NotesScreen(),
                ),
              ],
            ),
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
}
