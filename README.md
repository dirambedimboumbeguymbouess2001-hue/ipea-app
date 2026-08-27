# IPEA App

Application mobile Flutter destinée aux étudiants de l'**Institut Panafricain d'Études Appliquées (IPEA)**, permettant la consultation de leur scolarité, de leurs notes et de leurs paiements.

Projet réalisé dans le cadre d'un stage chez **BI-TECH Services**, sous la supervision de M. Bibang Befene Joseph Donovan.

## Fonctionnalités

- Connexion et activation de compte
- Tableau de bord personnel (vue d'ensemble : moyenne, reste à payer, scolarité active)
- Consultation des scolarités et de leurs détails
- Consultation des enseignants rattachés à une inscription
- Consultation des notes, regroupées par matière
- Suivi des paiements (historique, progression)
- Gestion du profil (consultation, modification des coordonnées, changement de mot de passe)
- Session persistante entre deux lancements de l'application

## Stack technique

| Élément | Choix |
|---|---|
| Framework | Flutter (Dart) |
| Navigation | go_router (navigation déclarative, garde de route, barre de navigation persistante) |
| Appels réseau | dio |
| Persistance locale | shared_preferences |
| Typographie | google_fonts (Poppins + Inter) |

## Structure du projet

```
lib/
├── core/
│   ├── auth/       # État d'authentification global et garde de route
│   ├── router/     # Configuration centralisée de la navigation (GoRouter)
│   └── theme/      # Couleurs, typographie, espacements (charte graphique)
├── features/       # Un dossier par écran/fonctionnalité
│   └── <feature>/
│       ├── data/           # Modèles + repository (accès aux données)
│       └── <feature>_screen.dart
├── shared/
│   └── widgets/    # Composants réutilisables (bouton, carte, badge, états...)
└── main.dart
```

## État d'avancement

L'ensemble de l'interface et de la navigation est fonctionnel. **Les données affichées sont actuellement fictives** (générées par les classes `Repository` de chaque fonctionnalité), en l'attente de la documentation de l'API backend. Voir `DOCUMENTATION_TECHNIQUE.md` pour le détail du fonctionnement et de la marche à suivre pour le branchement de l'API réelle.

## Lancer le projet en local

```bash
flutter pub get
flutter run
```

## Générer l'APK

```bash
flutter build apk --release
```

L'APK est généré dans `build/app/outputs/flutter-apk/app-release.apk`.
