import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class DemarrageScreen extends StatefulWidget {
  const DemarrageScreen({super.key});

  @override
  State<DemarrageScreen> createState() => _DemarrageScreenState();
}

class _DemarrageScreenState extends State<DemarrageScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) context.go('/connexion');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.marine,
      body: Center(
        child: Text(
          'IPEA Gabon',
          style: AppTypography.h1.copyWith(color: AppColors.blanc),
        ),
      ),
    );
  }
}
