import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes notes')),
      body: Center(
        child: Text('Écran notes', style: AppTypography.h2),
      ),
    );
  }
}
