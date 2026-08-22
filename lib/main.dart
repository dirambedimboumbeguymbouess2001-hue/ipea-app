import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() {
  usePathUrlStrategy(); // Active les URLs propres (sans #) sur le web
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
      routerConfig: AppRouter.router,
    );
  }
}
