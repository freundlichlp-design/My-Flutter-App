import 'package:get_it/get_it.dart';

import '../../providers/chat_provider.dart';
import '../../providers/settings_provider.dart';
import '../../storage/hive_storage.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerSingleton<HiveStorage>(HiveStorage());
  sl.registerSingleton<SettingsProvider>(SettingsProvider());

  await sl<SettingsProvider>().loadSettings(notify: false);

  sl.registerFactory<ChatProvider>(
    () => ChatProvider(
      storage: sl<HiveStorage>(),
      settingsProvider: sl<SettingsProvider>(),
    ),
  );
}
