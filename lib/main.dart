import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/auth/auth_state.dart';

void main() async {
  // Nécessaire car on utilise `await` avant runApp()
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  // Lit la session éventuellement déjà enregistrée avant même d'afficher
  // le premier écran, pour que la garde de route soit fiable dès le départ.
  await AuthState.instance.initialiser();

  runApp(const IpeaApp());
}

class IpeaApp extends StatelessWidget {
  const IpeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IPEA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.creerRouteur(AuthState.instance),
    );
  }
}
