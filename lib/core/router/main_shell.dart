import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Coquille de navigation principale : affiche la barre de navigation basse
/// (Accueil, Scolarité, Notes, Profil) en permanence, tout en conservant
/// l'état de chaque onglet lors du changement (grâce à StatefulShellRoute).
///
/// Icônes en Material Symbols Rounded, conformément à la charte graphique
/// (section technique, BTS-CG-2026-01).
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: AppColors.blanc,
        indicatorColor: AppColors.marine.withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.all(
          AppTypography.libelle.copyWith(fontSize: 11),
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Symbols.home_rounded),
            selectedIcon: Icon(Symbols.home_rounded, color: AppColors.marine, fill: 1),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: const Icon(Symbols.school_rounded),
            selectedIcon: Icon(Symbols.school_rounded, color: AppColors.marine, fill: 1),
            label: 'Scolarité',
          ),
          NavigationDestination(
            icon: const Icon(Symbols.grade_rounded),
            selectedIcon: Icon(Symbols.grade_rounded, color: AppColors.marine, fill: 1),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: const Icon(Symbols.person_rounded),
            selectedIcon: Icon(Symbols.person_rounded, color: AppColors.marine, fill: 1),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
