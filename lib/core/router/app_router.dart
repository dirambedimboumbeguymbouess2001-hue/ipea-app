import 'package:go_router/go_router.dart';
import '../auth/auth_state.dart';
import '../../features/demarrage/demarrage_screen.dart';
import '../../features/connexion/connexion_screen.dart';
import '../../features/activation/activation_screen.dart';
import '../../features/tableau_de_bord/tableau_de_bord_screen.dart';
import '../../features/scolarites/scolarites_screen.dart';
import '../../features/scolarites/inscription_detail_screen.dart';
import '../../features/scolarites/data/scolarite_models.dart';
import '../../features/paiements/paiements_screen.dart';
import '../../features/profil/profil_screen.dart';
import '../../features/administration/administration_connexion_screen.dart';
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
/// (2 niveaux : Inscription -> Modules, ces derniers étant eux-mêmes
/// regroupés par semestre à l'affichage - voir inscription_detail_screen.dart).
class AppRouter {
  AppRouter._();

  static GoRouter creerRouteur(AuthState authState) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authState,
      redirect: (context, state) {
        // L'espace administration a sa PROPRE connexion (staff, pas
        // étudiant) - il ne doit jamais passer par la garde de route
        // étudiante ci-dessous.
        if (state.matchedLocation.startsWith('/administration')) return null;

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
        // Point d'entrée unique de l'espace administration - le reste de
        // la navigation (accueil admin, activation, annonce) se fait en
        // Navigator.push classique depuis AdministrationConnexionScreen,
        // pas via go_router (section volontairement isolée du reste).
        GoRoute(
          path: '/administration',
          builder: (context, state) => const AdministrationConnexionScreen(),
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
                    // `extra` transporte l'Inscription complète quand
                    // l'écran appelant l'a déjà en mémoire (évite un
                    // appel réseau superflu) - reste optionnel.
                    GoRoute(
                      path: ':id',
                      builder: (context, state) {
                        final id = state.pathParameters['id']!;
                        final inscription = state.extra as Inscription?;
                        return InscriptionDetailScreen(
                          inscriptionId: id,
                          inscription: inscription,
                        );
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
