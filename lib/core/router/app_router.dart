import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/articles/presentation/pages/article_detail_page.dart';
import '../../features/articles/presentation/pages/home_page.dart';
import '../../features/chat/presentation/pages/chat_screen.dart';
import '../../features/chat/presentation/pages/conversations_screen.dart';
import '../../features/memory/presentation/pages/memory_settings_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ConversationsScreen(),
    ),
    GoRoute(
      path: '/chat',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/settings/memory',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MemorySettingsScreen(),
    ),
    GoRoute(
      path: '/articles',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/articles/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ArticleDetailPage(articleId: id);
      },
    ),
  ],
);
