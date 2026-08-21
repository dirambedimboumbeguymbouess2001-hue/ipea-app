import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class ScolaritesScreen extends StatelessWidget {
  const ScolaritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes scolarités')),
      body: Center(
        child: Text('Écran scolarités', style: AppTypography.h2),
      ),
    );
  }
}
