import '../models/message.dart';

class EmotionContext {
  final bool isFrustrated;
  final bool isRepetitive;
  final bool isComplexTopic;
  final String? detectedFrustrationKeyword;
  final int repetitiveQuestionCount;

  const EmotionContext({
    this.isFrustrated = false,
    this.isRepetitive = false,
    this.isComplexTopic = false,
    this.detectedFrustrationKeyword,
    this.repetitiveQuestionCount = 0,
  });

  bool get hasAnySignal => isFrustrated || isRepetitive || isComplexTopic;
}

class EmotionEngine {
  static const List<String> _frustrationKeywords = [
    'nicht verstehen',
    'falsch',
    'blöd',
    'sinnlos',
    'warum nicht',
    'das hilft nicht',
    'immer noch nicht',
    'schon wieder',
    'nervt',
    'mach einfach',
    'hör auf',
    'egal',
    'komplett falsch',
    'wrong',
    'stupid',
    'doesn\'t work',
    'not working',
    'frustrated',
    'annoying',
    'useless',
    'doesn\'t help',
    'doesn\'t make sense',
    'give up',
    'whatever',
    'forget it',
    'not what i asked',
  ];

  static const List<String> _complexTopicKeywords = [
    'architektur',
    'algorithmus',
    'database design',
    'system design',
    'distributed',
    'microservice',
    'authentication',
    'encryption',
    'machine learning',
    'neural network',
    'kubernetes',
    'docker compose',
    'ci/cd pipeline',
    'design pattern',
    'clean architecture',
    'refactor',
    'migration',
    'scaling',
    'concurrency',
    'threading',
    'security',
  ];

  static EmotionContext analyze(List<Message> history) {
    if (history.isEmpty) return const EmotionContext();

    final userMessages = history.where((m) => m.isUser).toList();
    if (userMessages.isEmpty) return const EmotionContext();

    final lastUserMessage = userMessages.last.content.toLowerCase();

    final frustrationResult = _detectFrustration(lastUserMessage);
    final repetitiveResult = _detectRepetitive(userMessages);
    final complexResult = _detectComplexTopic(lastUserMessage);

    return EmotionContext(
      isFrustrated: frustrationResult != null,
      detectedFrustrationKeyword: frustrationResult,
      isRepetitive: repetitiveResult >= 2,
      repetitiveQuestionCount: repetitiveResult,
      isComplexTopic: complexResult,
    );
  }

  static String? _detectFrustration(String message) {
    for (final keyword in _frustrationKeywords) {
      if (message.contains(keyword)) return keyword;
    }
    return null;
  }

  static int _detectRepetitive(List<Message> userMessages) {
    if (userMessages.length < 2) return 0;

    final lastMessage = userMessages.last.content.toLowerCase().trim();
    int matchCount = 0;

    for (int i = 0; i < userMessages.length - 1; i++) {
      final previous = userMessages[i].content.toLowerCase().trim();
      if (_isSimilarQuestion(previous, lastMessage)) {
        matchCount++;
      }
    }

    return matchCount;
  }

  static bool _isSimilarQuestion(String a, String b) {
    if (a == b) return true;

    final wordsA = a.split(RegExp(r'\s+')).where((w) => w.length > 3).toSet();
    final wordsB = b.split(RegExp(r'\s+')).where((w) => w.length > 3).toSet();

    if (wordsA.isEmpty || wordsB.isEmpty) return false;

    final intersection = wordsA.intersection(wordsB);
    final similarity = intersection.length / wordsA.length;

    return similarity > 0.6;
  }

  static bool _detectComplexTopic(String message) {
    for (final keyword in _complexTopicKeywords) {
      if (message.contains(keyword)) return true;
    }
    return false;
  }

  static String buildEmotionalContext(EmotionContext context) {
    if (!context.hasAnySignal) return '';

    final parts = <String>[];

    if (context.isFrustrated) {
      parts.add(
        'EMOTION SIGNAL: Der User wirkt frustriert (Keyword: "${context.detectedFrustrationKeyword}"). '
        'Sei besonders geduldig. Bestätige das Problem. Biete eine klare, einfache Lösung.',
      );
    }

    if (context.isRepetitive) {
      parts.add(
        'EMOTION SIGNAL: Der User wiederholt eine Frage (${context.repetitiveQuestionCount}x). '
        'Erkläre das Thema neu — anders, einfacher. Nutze ein konkretes Beispiel. '
        'Frag ob die Erklärung klar war.',
      );
    }

    if (context.isComplexTopic) {
      parts.add(
        'EMOTION SIGNAL: Komplexes Thema erkannt. '
        'Strukturiere deine Antwort: Schritt für Schritt. Nutze Code-Beispiele. '
        'Fasse am Ende zusammen.',
      );
    }

    return parts.join('\n');
  }
}
