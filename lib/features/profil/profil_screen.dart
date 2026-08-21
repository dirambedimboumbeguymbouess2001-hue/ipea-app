import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: Center(
        child: Text('Écran profil', style: AppTypography.h2),
      ),
    );
  }
}
