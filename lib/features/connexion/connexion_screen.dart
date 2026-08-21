import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class ConnexionScreen extends StatelessWidget {
  const ConnexionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Center(
        child: Text('Écran de connexion', style: AppTypography.h2),
      ),
    );
  }
}
