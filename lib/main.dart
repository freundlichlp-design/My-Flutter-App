import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'providers/article_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/memory_provider.dart';
import 'providers/settings_provider.dart';
import 'storage/hive_storage.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();
  await initDependencies();

  sl<MemoryProvider>().loadMemories();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>.value(
          value: sl<SettingsProvider>(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => sl<ChatProvider>(),
        ),
        ChangeNotifierProvider<ArticleProvider>(
          create: (_) => sl<ArticleProvider>(),
        ),
        ChangeNotifierProvider<MemoryProvider>.value(
          value: sl<MemoryProvider>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kali Chat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
