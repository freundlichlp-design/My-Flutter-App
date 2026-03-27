import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/article_provider.dart';
import 'screens/article_detail_page.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ArticleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFlutterApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        ArticleDetailPage.routeName: (_) => const ArticleDetailPage(),
      },
    );
  }
}
