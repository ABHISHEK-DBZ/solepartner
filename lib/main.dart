import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'data/db/app_database.dart';
import 'data/db/database_provider.dart';
import 'data/db/seed_data.dart';
import 'services/solana_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('[FLUTTER_ERROR] ${details.exceptionAsString()}');
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('[PLATFORM_ERROR] $error\n$stack');
    return true;
  };

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);

  final AppDatabase database = AppDatabase();
  bool onboarded = false;
  try {
    await DatabaseSeeder.seedIfEmpty(database);
    final merchant = await database.merchant;
    onboarded = merchant != null;
  } catch (e, stack) {
    debugPrint('[DB_INIT_ERROR] $e\n$stack');
    onboarded = false;
  }

  try {
    await SolanaService.initializeWalletAdapter();
  } catch (e) {
    debugPrint('[WALLET_INIT_WARNING] $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: KhataCopilotApp(onboarded: onboarded),
    ),
  );
}
