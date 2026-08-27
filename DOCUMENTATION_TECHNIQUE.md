# Documentation technique — IPEA App

## 1. Architecture générale

L'application suit une architecture **feature-first** : chaque écran possède son propre dossier sous `lib/features/`, contenant son écran (`*_screen.dart`) et, pour les écrans connectés à des données, un sous-dossier `data/` avec :

- un **modèle** (`*_models.dart`) : structure de données, avec une méthode `fromJson` prête à recevoir la réponse de l'API
- un **repository** (`*_repository.dart`) : point d'accès unique aux données de cette fonctionnalité

Cette séparation permet de brancher l'API réelle **sans modifier le moindre écran**.

## 2. Système de thème (charte graphique)

Quatre fichiers centralisés dans `lib/core/theme/`, conformes au document `BTS-CG-2026-01` :

- `app_colors.dart` — palette de couleurs officielle
- `app_typography.dart` — échelle typographique (Poppins pour les titres, Inter pour le texte courant)
- `app_spacing.dart` — espacements et rayons de bordure (base 8pt)
- `app_theme.dart` — assemble les trois fichiers précédents en un `ThemeData` Material 3

**Règle impérative** : aucune couleur, taille de texte ou espacement ne doit être codé en dur dans un écran — toujours passer par ces fichiers.

## 3. Navigation

Gérée par `go_router`, configurée dans `lib/core/router/app_router.dart`.

- Les écrans **Démarrage, Connexion, Activation** sont des routes de premier niveau, en plein écran
- Les écrans **Tableau de bord, Scolarités, Notes, Profil** sont regroupés dans un `StatefulShellRoute`, avec une barre de navigation basse persistante (`lib/core/router/main_shell.dart`)
- L'écran **Paiements** est accessible en poussant une route par-dessus (`context.push`), sans faire partie de la barre de navigation
- **Garde de route** : le callback `redirect` du routeur consulte `AuthState.instance.estConnecte` pour bloquer l'accès aux écrans protégés, et empêcher un utilisateur déjà connecté de revenir sur les écrans de connexion/activation

## 4. Authentification

`lib/core/auth/auth_state.dart` — singleton `ChangeNotifier`, source unique de vérité pour l'état de connexion.

- `AuthState.instance.connecter()` — à appeler après une connexion réussie
- `AuthState.instance.deconnecter()` — à appeler pour se déconnecter
- La session est persistée via `shared_preferences`, relue au démarrage de l'app (`initialiser()`, appelée dans `main()` avant `runApp`)

**Point d'attention pour le branchement API** : `AuthState` ne stocke actuellement qu'un booléen (`estConnecte`). Si l'API utilise un système de token (JWT ou autre), il faudra étendre cette classe pour stocker et exposer également le token, probablement en l'ajoutant aux en-têtes des requêtes `dio` via un intercepteur.

## 5. Composants réutilisables

Dans `lib/shared/widgets/` :

| Composant | Usage |
|---|---|
| `AppButton` | Bouton (variantes primaire/secondaire, état de chargement intégré) |
| `AppTextField` | Champ de texte avec label et gestion d'erreur |
| `AppCard` | Conteneur de contenu, arrondi, avec ombre légère |
| `StatusBadge` | Badge de statut coloré (succès/erreur/avertissement/neutre) |
| `EmptyState` | État "aucune donnée" |
| `ErrorState` | État d'erreur avec bouton de réessai |
| `LoadingSkeleton` | Squelette de chargement animé (jamais de spinner plein écran) |

## 6. ⚠️ Branchement de l'API réelle — marche à suivre

C'est l'étape la plus importante restant à réaliser. Pour chaque fonctionnalité concernée :

### Étape 1 — Ouvrir le repository concerné

Exemple avec `lib/features/notes/data/notes_repository.dart` :

```dart
class NotesRepository {
  Future<List<NoteMatiere>> obtenirNotes(String etudiantId) async {
    // --- SIMULATION TEMPORAIRE ---
    await Future.delayed(const Duration(seconds: 1));
    return const [ /* données fictives */ ];
  }
}
```

### Étape 2 — Remplacer uniquement le contenu de la méthode

```dart
class NotesRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api-ipea.exemple.com'));

  Future<List<NoteMatiere>> obtenirNotes(String etudiantId) async {
    final reponse = await _dio.get('/notes/$etudiantId');
    return (reponse.data as List)
        .map((json) => NoteMatiere.fromJson(json))
        .toList();
  }
}
```

**Aucune autre modification n'est nécessaire** — l'écran (`notes_screen.dart`) continue d'appeler `_repository.obtenirNotes(...)` exactement comme avant ; les états de chargement, d'erreur et de succès déjà en place géreront automatiquement la vraie réponse de l'API (le `try/catch` déjà présent dans chaque écran capture nativement les erreurs `dio`).

### Repositories à mettre à jour, dans l'ordre de priorité du chronogramme

1. `lib/features/connexion/connexion_screen.dart` — remplacer la simulation par un vrai appel de connexion, appeler `AuthState.instance.connecter()` uniquement en cas de succès réel
2. `lib/features/notes/data/notes_repository.dart`
3. `lib/features/paiements/data/paiements_repository.dart`
4. `lib/features/scolarites/data/scolarites_repository.dart`
5. `lib/features/tableau_de_bord/data/tableau_de_bord_repository.dart`
6. `lib/features/profil/data/profil_repository.dart`
7. `lib/features/scolarites/enseignants_screen.dart` (repository non extrait dans un fichier séparé — à faire à cette occasion si souhaité)
8. `lib/features/activation/activation_screen.dart`

### Identifiant étudiant

Actuellement, l'identifiant `'etu-001'` est codé en dur dans plusieurs écrans (Notes, Paiements, Scolarités). Une fois l'authentification réelle branchée, il faudra le récupérer dynamiquement (probablement renvoyé par l'API lors de la connexion, à stocker dans `AuthState` ou une classe dédiée `UtilisateurCourant`).

## 7. Tests réalisés

- Analyse statique (`flutter analyze`) : aucun problème détecté
- Test automatisé de démarrage (`flutter test`) : validé
- Tests manuels sur deux terminaux :
  - Samsung Galaxy S10+ (physique), Android 12
  - Émulateur Pixel 6, Android 17
- Build release (`flutter build apk --release`) : généré et testé avec succès (49,7 Mo)

## 8. Limitations connues

- Toutes les données affichées sont actuellement fictives (voir section 6)
- L'authentification ne vérifie pas réellement de mot de passe (toute saisie non vide est acceptée)
- Icône d'application générée pour Android uniquement (iOS non requis pour ce projet)
