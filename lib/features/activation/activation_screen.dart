import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class ActivationScreen extends StatelessWidget {
  const ActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activation de compte')),
      body: Center(
        child: Text('Écran d\'activation', style: AppTypography.h2),
      ),
    );
  }
}
