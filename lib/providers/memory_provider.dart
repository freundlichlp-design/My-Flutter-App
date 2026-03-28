import 'package:flutter/foundation.dart';

import '../models/memory_entry.dart';
import '../models/privacy_settings.dart';
import '../storage/memory_storage.dart';

class MemoryProvider extends ChangeNotifier {
  final MemoryStorage _memoryStorage = MemoryStorage();

  List<MemoryEntry> _memories = [];
  PrivacySettings _privacySettings = PrivacySettings();

  List<MemoryEntry> get memories => _memories;
  PrivacySettings get privacySettings => _privacySettings;
  int get memoryCount => _memories.length;

  List<MemoryEntry> getMemoriesByCategory(String category) {
    return _memories.where((m) => m.category == category).toList();
  }

  List<String> get categories {
    final cats = _memories.map((m) => m.category).toSet().toList();
    cats.sort();
    return cats;
  }

  void loadMemories() {
    _memories = _memoryStorage.getAllMemories();
    _privacySettings = _memoryStorage.getPrivacySettings();
    notifyListeners();
  }

  Future<void> deleteMemory(String id) async {
    await _memoryStorage.deleteMemory(id);
    loadMemories();
  }

  Future<void> clearAllMemories() async {
    await _memoryStorage.clearAllMemories();
    loadMemories();
  }

  Future<void> updatePrivacySettings(PrivacySettings settings) async {
    await _memoryStorage.savePrivacySettings(settings);
    _privacySettings = settings;
    notifyListeners();
  }

  Future<void> toggleMemoryEnabled(bool value) async {
    _privacySettings.memoryEnabled = value;
    await _memoryStorage.savePrivacySettings(_privacySettings);
    notifyListeners();
  }

  Future<void> toggleAutoExtractFacts(bool value) async {
    _privacySettings.autoExtractFacts = value;
    await _memoryStorage.savePrivacySettings(_privacySettings);
    notifyListeners();
  }

  Future<void> toggleStorePersonalInfo(bool value) async {
    _privacySettings.storePersonalInfo = value;
    await _memoryStorage.savePrivacySettings(_privacySettings);
    notifyListeners();
  }

  Future<void> toggleStorePreferences(bool value) async {
    _privacySettings.storePreferences = value;
    await _memoryStorage.savePrivacySettings(_privacySettings);
    notifyListeners();
  }

  Future<void> toggleStoreTechnicalFacts(bool value) async {
    _privacySettings.storeTechnicalFacts = value;
    await _memoryStorage.savePrivacySettings(_privacySettings);
    notifyListeners();
  }
}
