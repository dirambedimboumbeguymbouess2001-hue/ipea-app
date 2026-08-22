import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Coquille de navigation principale : affiche la barre de navigation basse
/// (Accueil, Scolarité, Notes, Profil) en permanence, tout en conservant
/// l'état de chaque onglet lors du changement (grâce à StatefulShellRoute).
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
          // goBranch avec initialLocation:true réinitialise l'onglet
          // si on retape sur celui déjà actif (comportement standard)
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
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.marine),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: const Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school, color: AppColors.marine),
            label: 'Scolarité',
          ),
          NavigationDestination(
            icon: const Icon(Icons.grade_outlined),
            selectedIcon: Icon(Icons.grade, color: AppColors.marine),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.marine),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
