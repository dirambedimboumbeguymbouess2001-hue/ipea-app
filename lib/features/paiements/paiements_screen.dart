import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class PaiementsScreen extends StatelessWidget {
  const PaiementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiements')),
      body: Center(
        child: Text('Écran paiements', style: AppTypography.h2),
      ),
    );
  }
}
