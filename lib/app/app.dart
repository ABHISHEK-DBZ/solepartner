import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';
import 'theme.dart';
import 'theme_controller.dart';

class KhataCopilotApp extends ConsumerStatefulWidget {
  const KhataCopilotApp({super.key, required this.onboarded});

  final bool onboarded;

  @override
  ConsumerState<KhataCopilotApp> createState() => _KhataCopilotAppState();
}

class _KhataCopilotAppState extends ConsumerState<KhataCopilotApp> {
  late final GoRouter _router = buildRouter(hasMerchant: widget.onboarded);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'KhataCopilot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('hi'),
      ],
      routerConfig: _router,
      builder: (BuildContext context, Widget? child) {
        return AnimatedThemeTransition(
          duration: const Duration(milliseconds: 400),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
