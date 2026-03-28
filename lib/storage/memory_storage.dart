import 'package:hive_flutter/hive_flutter.dart';

import '../models/memory_entry.dart';
import '../models/privacy_settings.dart';

class MemoryStorage {
  static const String memoryBox = 'memory_entries';
  static const String privacyBox = 'privacy_settings';
  static const String privacyKey = 'privacy_settings';

  static final MemoryStorage _instance = MemoryStorage._internal();

  factory MemoryStorage() => _instance;

  MemoryStorage._internal();

  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MemoryEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(PrivacySettingsAdapter());
    }
    await Hive.openBox<MemoryEntry>(memoryBox);
    await Hive.openBox<PrivacySettings>(privacyBox);
  }

  Box<MemoryEntry> get _memoryBox => Hive.box<MemoryEntry>(memoryBox);
  Box<PrivacySettings> get _privacyBox =>
      Hive.box<PrivacySettings>(privacyBox);

  // Memory CRUD
  List<MemoryEntry> getAllMemories() {
    final list = _memoryBox.values.toList();
    list.sort((a, b) => b.extractedAt.compareTo(a.extractedAt));
    return list;
  }

  List<MemoryEntry> getMemoriesByCategory(String category) {
    return _memoryBox.values
        .where((m) => m.category == category)
        .toList()
      ..sort((a, b) => b.extractedAt.compareTo(a.extractedAt));
  }

  List<MemoryEntry> getPublicMemories() {
    return _memoryBox.values
        .where((m) => !m.isPrivate)
        .toList()
      ..sort((a, b) => b.extractedAt.compareTo(a.extractedAt));
  }

  Future<void> saveMemory(MemoryEntry entry) async {
    await _memoryBox.put(entry.id, entry);
  }

  Future<void> saveMemories(List<MemoryEntry> entries) async {
    for (final entry in entries) {
      await _memoryBox.put(entry.id, entry);
    }
  }

  Future<void> deleteMemory(String id) async {
    await _memoryBox.delete(id);
  }

  Future<void> clearAllMemories() async {
    await _memoryBox.clear();
  }

  int get memoryCount => _memoryBox.length;

  // Privacy Settings
  PrivacySettings getPrivacySettings() {
    return _privacyBox.get(privacyKey) ?? PrivacySettings();
  }

  Future<void> savePrivacySettings(PrivacySettings settings) async {
    await _privacyBox.put(privacyKey, settings);
  }

  // Enforce max entries limit
  Future<void> enforceMemoryLimit(int maxEntries) async {
    final all = getAllMemories();
    if (all.length > maxEntries) {
      final toRemove = all.sublist(maxEntries);
      for (final entry in toRemove) {
        await entry.delete();
      }
    }
  }
}
