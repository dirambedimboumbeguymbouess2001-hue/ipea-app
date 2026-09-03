import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/auth/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await AuthState.instance.initialiser();
  runApp(const IpeaApp());
}

class IpeaApp extends StatelessWidget {
  const IpeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IPEA Gabon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.creerRouteur(AuthState.instance),
    );
  }
}
