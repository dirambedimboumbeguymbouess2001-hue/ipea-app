import 'package:go_router/go_router.dart';
import '../auth/auth_state.dart';
import '../../features/demarrage/demarrage_screen.dart';
import '../../features/connexion/connexion_screen.dart';
import '../../features/activation/activation_screen.dart';
import '../../features/tableau_de_bord/tableau_de_bord_screen.dart';
import '../../features/scolarites/scolarites_screen.dart';
import '../../features/scolarites/inscription_detail_screen.dart';
import '../../features/paiements/paiements_screen.dart';
import '../../features/profil/profil_screen.dart';
import 'main_shell.dart';

/// Routeur centralisé de l'application, avec garde de route.
///
/// L'écran Notes a été fusionné dans Scolarité — la route /notes et
/// l'onglet correspondant n'existent plus. L'accès aux enseignants a
/// également été retiré à la demande de l'encadrant.
///
/// La vraie API renvoie une liste PLATE de scolarités (pas de semestres
/// imbriqués) : la route imbriquée est donc passée de
/// /scolarites/:classeId/:semestreId (3 niveaux) à /scolarites/:id
/// (2 niveaux : Inscription -> Modules).
class AppRouter {
  AppRouter._();

  static GoRouter creerRouteur(AuthState authState) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authState,
      redirect: (context, state) {
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
                    // Route imbriquée : /scolarites/:id
                    GoRoute(
                      path: ':id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        return InscriptionDetailScreen(inscriptionId: id);
                      },
                    ),
                  ],
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
