import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Squelette de chargement réutilisable — à afficher pendant qu'un appel
/// API est en cours. La charte graphique interdit le spinner plein écran :
/// on affiche à la place des blocs gris animés, à la forme du contenu
/// attendu, pour donner une impression de continuité visuelle.
class LoadingSkeleton extends StatefulWidget {
  final double height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;

  const LoadingSkeleton({
    super.key,
    this.height = 16,
    this.width,
    this.borderRadius,
  });

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            color: Color.lerp(
              AppColors.grisClair,
              AppColors.grisMoyen.withValues(alpha: 0.3),
              _controller.value,
            ),
            borderRadius: widget.borderRadius ??
                BorderRadius.circular(AppSpacing.radiusSmall),
          ),
        );
      },
    );
  }
}
