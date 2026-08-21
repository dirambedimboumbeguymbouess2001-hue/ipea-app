import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class TableauDeBordScreen extends StatelessWidget {
  const TableauDeBordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord')),
      body: Center(
        child: Text('Écran tableau de bord', style: AppTypography.h2),
      ),
    );
  }
}
