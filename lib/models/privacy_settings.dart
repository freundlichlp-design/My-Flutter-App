import 'package:hive/hive.dart';

part 'privacy_settings.g.dart';

@HiveType(typeId: 3)
class PrivacySettings extends HiveObject {
  @HiveField(0)
  bool memoryEnabled;

  @HiveField(1)
  bool autoExtractFacts;

  @HiveField(2)
  bool storePersonalInfo;

  @HiveField(3)
  bool storePreferences;

  @HiveField(4)
  bool storeTechnicalFacts;

  @HiveField(5)
  int maxMemoryEntries;

  PrivacySettings({
    this.memoryEnabled = true,
    this.autoExtractFacts = true,
    this.storePersonalInfo = false,
    this.storePreferences = true,
    this.storeTechnicalFacts = true,
    this.maxMemoryEntries = 500,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      memoryEnabled: json['memoryEnabled'] as bool? ?? true,
      autoExtractFacts: json['autoExtractFacts'] as bool? ?? true,
      storePersonalInfo: json['storePersonalInfo'] as bool? ?? false,
      storePreferences: json['storePreferences'] as bool? ?? true,
      storeTechnicalFacts: json['storeTechnicalFacts'] as bool? ?? true,
      maxMemoryEntries: json['maxMemoryEntries'] as int? ?? 500,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memoryEnabled': memoryEnabled,
      'autoExtractFacts': autoExtractFacts,
      'storePersonalInfo': storePersonalInfo,
      'storePreferences': storePreferences,
      'storeTechnicalFacts': storeTechnicalFacts,
      'maxMemoryEntries': maxMemoryEntries,
    };
  }
}
