import 'package:get_it/get_it.dart';

import '../../features/articles/data/datasources/article_remote_datasource.dart';
import '../../features/articles/data/repositories/article_repository_impl.dart';
import '../../features/articles/domain/repositories/article_repository.dart';
import '../../features/articles/domain/usecases/fetch_article_detail.dart';
import '../../features/articles/domain/usecases/fetch_articles.dart';
import '../../features/chat/data/datasources/chat_local_datasource.dart';
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/chat_get_history.dart';
import '../../features/chat/domain/usecases/chat_send_message.dart';
import '../../features/chat/domain/usecases/create_conversation.dart';
import '../../features/chat/domain/usecases/delete_conversation.dart';
import '../../features/chat/domain/usecases/load_conversations.dart';
import '../../features/chat/domain/usecases/stream_response.dart';
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings.dart';
import '../../features/settings/domain/usecases/save_api_key.dart';
import '../../features/settings/domain/usecases/save_personality.dart';
import '../../features/settings/domain/usecases/settings_get_api_key.dart';
import '../../features/settings/domain/usecases/update_provider_config.dart';
import '../../providers/article_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/memory_provider.dart';
import '../../providers/settings_provider.dart';
import '../../storage/hive_storage.dart';
import '../../storage/memory_storage.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Storage
  sl.registerSingleton<HiveStorage>(HiveStorage());
  sl.registerSingleton<MemoryStorage>(MemoryStorage());

  // Datasources (concrete implementations bound to abstract types)
  sl.registerLazySingleton<ChatLocalDatasource>(
      () => ChatLocalDatasourceImpl());
  sl.registerLazySingleton<ChatRemoteDatasource>(
      () => ChatRemoteDatasourceImpl());
  sl.registerLazySingleton<ArticleRemoteDatasource>(
      () => ArticleRemoteDatasource());
  sl.registerLazySingleton<SettingsLocalDatasource>(
      () => SettingsLocalDatasourceImpl());

  // Repositories
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      localDatasource: sl<ChatLocalDatasource>(),
      remoteDatasource: sl<ChatRemoteDatasource>(),
    ),
  );
  sl.registerLazySingleton<ArticleRepository>(
    () => ArticleRepositoryImpl(
      remoteDatasource: sl<ArticleRemoteDatasource>(),
    ),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      localDatasource: sl<SettingsLocalDatasource>(),
    ),
  );

  // UseCases - Chat
  sl.registerLazySingleton(() => LoadConversations(sl<ChatRepository>()));
  sl.registerLazySingleton(() => CreateConversation(sl<ChatRepository>()));
  sl.registerLazySingleton(() => DeleteConversation(sl<ChatRepository>()));
  sl.registerLazySingleton(() => ChatSendMessage(sl<ChatRepository>()));
  sl.registerLazySingleton(() => ChatGetHistory(sl<ChatRepository>()));
  sl.registerLazySingleton(() => StreamResponse(sl<ChatRepository>()));

  // UseCases - Articles
  sl.registerLazySingleton(() => FetchArticles(sl<ArticleRepository>()));
  sl.registerLazySingleton(() => FetchArticleDetail(sl<ArticleRepository>()));

  // UseCases - Settings
  sl.registerLazySingleton(() => GetSettings(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => SaveApiKey(sl<SettingsRepository>()));
  sl.registerLazySingleton(
      () => UpdateProviderConfig(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => SavePersonality(sl<SettingsRepository>()));
  sl.registerLazySingleton(
      () => SettingsGetApiKey(sl<SettingsRepository>()));

  // Providers
  sl.registerLazySingleton<SettingsProvider>(
    () => SettingsProvider(
      getSettings: sl<GetSettings>(),
      saveApiKey: sl<SaveApiKey>(),
      updateProviderConfig: sl<UpdateProviderConfig>(),
      savePersonality: sl<SavePersonality>(),
    ),
  );

  await sl<SettingsProvider>().loadSettings(notify: false);

  sl.registerFactory<ChatProvider>(
    () => ChatProvider(
      loadConversations: sl<LoadConversations>(),
      createConversation: sl<CreateConversation>(),
      deleteConversation: sl<DeleteConversation>(),
      sendMessage: sl<ChatSendMessage>(),
      streamResponse: sl<StreamResponse>(),
    ),
  );

  sl.registerFactory<ArticleProvider>(
    () => ArticleProvider(
      fetchArticles: sl<FetchArticles>(),
      fetchArticleDetail: sl<FetchArticleDetail>(),
    ),
  );

  sl.registerLazySingleton<MemoryProvider>(
    () => MemoryProvider(),
  );
}
