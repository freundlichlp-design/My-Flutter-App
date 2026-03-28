import '../models/memory_entry.dart';
import '../models/privacy_settings.dart';

class FactExtractor {
  static final List<_FactPattern> _patterns = [
    // Preferences
    _FactPattern(
      regex: RegExp(
        r'(?:ich mag|ich liebe|ich bevorzuge|ich hasse|ich mag nicht|my favorite|i love|i prefer|i hate|i don\'?t like|i enjoy)\s+(.+)',
        caseSensitive: false,
      ),
      category: 'preference',
    ),
    // Personal info
    _FactPattern(
      regex: RegExp(
        r'(?:mein name ist|ich heiße|my name is|i\'?m called|call me|i am)\s+(.+)',
        caseSensitive: false,
      ),
      category: 'personal',
    ),
    // Work/Technical
    _FactPattern(
      regex: RegExp(
        r'(?:ich arbeite als|ich arbeite bei|my job is|i work as|i work at|ich bin)\s+(.+)',
        caseSensitive: false,
      ),
      category: 'work',
    ),
    // Location
    _FactPattern(
      regex: RegExp(
        r'(?:ich wohne in|ich lebe in|i live in|my city is|meine stadt ist)\s+(.+)',
        caseSensitive: false,
      ),
      category: 'location',
    ),
    // Language
    _FactPattern(
      regex: RegExp(
        r'(?:ich spreche|meine sprache ist|i speak|my language is)\s+(.+)',
        caseSensitive: false,
      ),
      category: 'language',
    ),
    // Programming/Tech
    _FactPattern(
      regex: RegExp(
        r'(?:ich programmiere|meine sprache|my stack is|i code in|i use|ich nutze|ich verwende)\s+(.+)',
        caseSensitive: false,
      ),
      category: 'technical',
    ),
    // Goals
    _FactPattern(
      regex: RegExp(
        r'(?:ich will|ich möchte|mein ziel ist|my goal is|i want to|i plan to|ich plane)\s+(.+)',
        caseSensitive: false,
      ),
      category: 'goal',
    ),
    // General facts with "remember" / "merken"
    _FactPattern(
      regex: RegExp(
        r'(?:merke dir|remember that|notiere|keep in mind|fyi)\s+(.+)',
        caseSensitive: false,
      ),
      category: 'general',
    ),
  ];

  static List<MemoryEntry> extractFacts({
    required String messageContent,
    required String conversationId,
    required PrivacySettings privacySettings,
  }) {
    if (!privacySettings.autoExtractFacts) return [];

    final facts = <MemoryEntry>[];
    final lines = messageContent.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      for (final pattern in _patterns) {
        final match = pattern.regex.firstMatch(trimmed);
        if (match != null) {
          final factText = match.group(1)?.trim();
          if (factText != null && factText.length > 2 && factText.length < 500) {
            if (_isAllowedCategory(pattern.category, privacySettings)) {
              facts.add(
                MemoryEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString() +
                      '_${facts.length}',
                  fact: _cleanFact(factText),
                  category: pattern.category,
                  sourceConversationId: conversationId,
                  extractedAt: DateTime.now(),
                  isPrivate: pattern.category == 'personal',
                ),
              );
            }
          }
        }
      }
    }

    return facts;
  }

  static bool _isAllowedCategory(String category, PrivacySettings settings) {
    switch (category) {
      case 'personal':
        return settings.storePersonalInfo;
      case 'preference':
      case 'goal':
        return settings.storePreferences;
      case 'technical':
      case 'work':
        return settings.storeTechnicalFacts;
      default:
        return true;
    }
  }

  static String _cleanFact(String fact) {
    return fact
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String buildMemoryContext(List<MemoryEntry> memories) {
    if (memories.isEmpty) return '';

    final buffer = StringBuffer();
    buffer.writeln('Bekannte Fakten über den User:');
    for (final memory in memories) {
      buffer.writeln('- [${memory.category}] ${memory.fact}');
    }
    return buffer.toString();
  }
}

class _FactPattern {
  final RegExp regex;
  final String category;

  _FactPattern({required this.regex, required this.category});
}
