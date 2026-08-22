import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Champ de texte standard de l'application. Toujours utiliser ce widget
/// plutôt qu'un TextField/TextFormField nu, pour garantir un style
/// uniforme (label au-dessus, fond gris clair, message d'erreur).
class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.libelle),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            errorText: errorText,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.grisClair,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.marine, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              borderSide: const BorderSide(color: AppColors.erreur, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
        ),
      ],
    );
  }
}
