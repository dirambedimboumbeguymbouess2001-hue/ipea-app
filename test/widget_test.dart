// Test de démarrage de l'application IPEA.
//
// Vérifie que l'application se lance sans erreur, affiche bien
// l'écran de démarrage (fond marine, texte "IPEA"), puis redirige
// automatiquement vers l'écran de connexion après le délai prévu.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipea_app/main.dart';

void main() {
  testWidgets('L\'application démarre puis redirige vers la connexion', (WidgetTester tester) async {
    // Construit l'application et déclenche un premier rendu.
    await tester.pumpWidget(const IpeaApp());

    // Immédiatement après le lancement, on doit voir l'écran de démarrage.
    expect(find.text('IPEA'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);

    // Laisse le minuteur de redirection (1,2s) se terminer, pour que
    // le test se termine proprement sans minuteur encore en attente.
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    // Après la redirection, on doit être sur l'écran de connexion.
    expect(find.text('Connexion'), findsOneWidget);
  });
}