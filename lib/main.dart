import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';

void main() {
  runApp(const IpeaApp());
}

class IpeaApp extends StatelessWidget {
  const IpeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPEA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const PlaceholderHomePage(),
    );
  }
}

/// Écran temporaire, uniquement pour vérifier que le thème s'applique
/// correctement. Sera remplacé par le véritable écran de démarrage
/// une fois qu'on l'aura construit.
class PlaceholderHomePage extends StatelessWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IPEA'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Thème IPEA appliqué', style: AppTypography.h1),
            const SizedBox(height: 16),
            Text('Texte courant en Inter', style: AppTypography.bodyLarge),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.marine,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Bloc en marine IPEA',
                style: AppTypography.bouton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}