import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'providers/article_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/settings_provider.dart';
import 'storage/hive_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();
  await initDependencies();

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
