import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/article_provider.dart';

class ArticleDetailPage extends StatefulWidget {
  static const String routeName = '/article-detail';

  const ArticleDetailPage({super.key});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final articleId = ModalRoute.of(context)!.settings.arguments as int;
    context.read<ArticleProvider>().loadArticle(articleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Detail'),
      ),
      body: Consumer<ArticleProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case ArticleState.initial:
            case ArticleState.loading:
              return const Center(child: CircularProgressIndicator());
            case ArticleState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${provider.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final articleId =
                            ModalRoute.of(context)!.settings.arguments as int;
                        provider.loadArticle(articleId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            case ArticleState.success:
              final article = provider.selectedArticle;
              if (article == null) {
                return const Center(child: Text('Article not found'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'By User ${article.userId}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      article.body,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
