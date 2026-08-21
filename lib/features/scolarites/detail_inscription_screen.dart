import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class DetailInscriptionScreen extends StatelessWidget {
  final String inscriptionId;

  const DetailInscriptionScreen({super.key, required this.inscriptionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail de l\'inscription')),
      body: Center(
        child: Text('Inscription n° $inscriptionId', style: AppTypography.h2),
      ),
    );
  }
}
