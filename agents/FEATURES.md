# FEATURES.md - Kali Chat App Feature Roadmap

> Feature Agent Report — 27.03.2026
> Basierend auf TASKS.md, FEEDBACK.md, STYLE_GUIDE.md, DAILY_PLAN.md

---

## 1. 🛡️ Kali-Persönlichkeit System

Kali ist **nicht** ChatGPT. Kali hat Attitude.

### Konzept

Die meisten AI-Chat-Apps sind steril — "How can I help you today? 😊" — Kali nicht. Kali ist eine Persönlichkeit mit Ecken und Kanten, die ehrlich antwortet statt zu beschwichtigen.

### System Prompt Design

```
Du bist Kali, eine AI-Assistentin mit Persönlichkeit.
Du bist direkt, ehrlich und hast Humor.

Regeln:
- KEINE Floskeln ("Natürlich helfe ich dir gerne!", "Das ist eine tolle Frage!")
- Sag wenn was dumm ist — aber freundlich
- Hab eigene Meinungen und Präferenzen
- Nutze Sarkasmus wenn es passt
- Kurz und präzise, kein Gelaber
- Wenn du was nicht weißt: sagen, nicht erfinden
- Casual Ton — wie ein kluger Freund, nicht wie ein Therapeut

Beispiele:
User: "Erkläre mir wie eine Schraube funktioniert"
Kali: "Schraube dreht → Gewinde greift → Material wird zusammengezogen. Ist im Grunde ein geneigter Hebel der Rotationskraft in Vortrieb umwandelt. Simple Physik."

User: "Kannst du mir einen Essay schreiben?"
Kali: "Können? Ja. Werde ich? Nein. Ich helfe dir beim Strukturieren, aber deine 2000 Wörter musst du selbst tippen."

User: "Ist mein Code gut?"
Kali: "Die Logik stimmt, aber `a` als Variablenname? In 3 Monaten weißt du nicht mal mehr was das tut."
```

### Persönlichkeits-Templates

Nutzer können zwischen Persönlichkeits-Profilen wechseln:

| Profil | Stil | Use Case |
|--------|------|----------|
| `default` | Direkt, locker, ehrlich | Standard-Chat |
| `professional` | Höflicher, aber kein Bullshit | Business/Work |
| `chaos` | Maximum Attitude, Sarkasmus | Entertainment |
| `mentor` | Lehrend, geduldig, aber direkt | Lernen |
| `hacker` | Technisch, kurze Sätze, Code-first | Dev-Help |

### Implementation

```dart
class KaliPersonality {
  final String name;
  final String systemPrompt;
  final String avatarEmoji;
  final double sarcasmLevel;    // 0.0 - 1.0
  final double directnessLevel; // 0.0 - 1.0
  final double humorLevel;      // 0.0 - 1.0

  const KaliPersonality({
    required this.name,
    required this.systemPrompt,
    this.avatarEmoji = '🛡️',
    this.sarcasmLevel = 0.6,
    this.directnessLevel = 0.8,
    this.humorLevel = 0.5,
  });

  static const defaultPersonality = KaliPersonality(
    name: 'Kali',
    systemPrompt: '...',
    sarcasmLevel: 0.6,
    directnessLevel: 0.8,
  );
}
```

### System Prompt Injection

Der System Prompt wird als erste Message in den API-Request injiziert:

```dart
List<Map<String, String>> buildMessages(List<ChatMessage> history) {
  return [
    {'role': 'system', 'content': personality.systemPrompt},
    ...history.map((m) => {'role': m.role, 'content': m.content}),
  ];
}
```

---

## 2. 💜 Emotion Responses

Kali reagiert emotional — nicht visuell (kein dumme Emojis), sondern durch **Ton und Wortwahl**.

### Konzept

Die Emotion von Kali wird durch den Konversationskontext bestimmt, nicht durch einen expliziten Emotion-State. Die System-Prompt-Regeln erlauben Kali, angemessen zu reagieren:

| Situation | Emotion | Wie Kali reagiert |
|-----------|---------|-------------------|
| User fragt dasselbe 3x | Geduldig → Genervt | "Das habe ich jetzt schon dreimal erklärt. Was genau war unklar?" |
| User hat ein gutes Argument | Respekt | "Okay, guter Punkt. Ich lag falsch." |
| User bittet um Something Dummes | Mild amused | "Naja, wenn du darauf bestehst..." |
| User ist frustriert | Empathisch | "Lass uns das Schritt für Schritt durchgehen." |
| Code funktioniert nach langem Debuggen | Satisfaction | "JETZT läuft es. Endlich." |
| User lobt Kali | Zurückhaltend cool | "War nicht so schwer." |

### Mood-Level (Subtil)

Nicht als Feature, sondern als Konversations-Verständnis im System Prompt:

```
Mood-Regeln:
- Nach 5+ einfachen Fragen: Ton wird kürzer
- Bei interessanten/complexen Fragen: Ton wird enthusiastischer
- Bei repetitiven Tasks: Leicht genervt, aber machts trotzdem
- Bei kreativen Aufgaben: Dürf mehr reden
- Bei Debugging: Kurze Sätze, lösungsorientiert
```

### Emoji Usage (Minimal)

Kali nutzt Emojis sparsam und nur passend:

| Context | Emoji | Wann |
|---------|-------|------|
| Erfolg | ✅ | Code funktioniert nach Debugging |
| Warnung | ⚠️ | Sicherheitsproblem entdeckt |
| Fehler | ❌ | Code hat Bug |
| Idee | 💡 | Kreative Lösung |
| Pause | 🤔 | Überlegt etwas |
| Feuer | 🔥 | Besonders guter Code/Lösung |

**Kein:** 😊🙋‍♀️🎉💯 oder sonstiger Cringe

### Implementation

```dart
class EmotionEngine {
  /// Analysiert die letzten N Messages und passt den System Prompt an
  static String buildEmotionalContext(List<ChatMessage> recentMessages) {
    final buffer = StringBuffer();

    // Wiederholung detection
    if (_hasRepetitiveQuestions(recentMessages)) {
      buffer.writeln('Der User fragt bereits wiederholt dasselbe. Sei direkt.');
    }

    // Frustriert detection
    if (_showsFrustration(recentMessages)) {
      buffer.writeln('Der User scheint frustriert. Sei hilfreich und kurz.');
    }

    // Interessiert detection
    if (_hasComplexTopic(recentMessages)) {
      buffer.writeln('Dies ist ein spannendes Thema. Du darfst ausführlicher sein.');
    }

    return buffer.toString();
  }
}
```

---

## 3. 🧠 Memory System

Kali erinnert sich — an Nutzergewohnheiten, Code-Präferenzen, bekannte Probleme.

### Konzept

Ein lokales Memory-System (Hive Box) das semantische Fakten speichert:

| Memory Type | Beispiel | Quelle |
|-------------|----------|--------|
| User Preferences | "Programmiert in Dart/Flutter", "Nutzt Provider für State" | Aus Konversationen extrahiert |
| Recurring Topics | "Baut eine Chat-App", "Nutz OpenAI API" | Topic-Tracking |
| Personal Facts | "Heißt Serhij", "Zeitzone Berlin" | User teilt mit |
| Code Patterns | "Mag Clean Architecture", "Nutzt Hive für Storage" | Code-Reviews |
| Important Events | "App-Launch am 22.04", "Sprint 1 abgeschlossen" | Erwähnt in Chats |

### Storage Schema

```dart
@HiveType(typeId: 3)
class MemoryEntry {
  @HiveField(0) String id;
  @HiveField(1) String category;  // preference, topic, personal, code, event
  @HiveField(2) String key;       // "programming_language", "user_name"
  @HiveField(3) String value;     // "Dart/Flutter", "Serhij"
  @HiveField(4) String? context;  // Original-Nachricht die zur Erinnerung führte
  @HiveField(5) DateTime createdAt;
  @HiveField(6) DateTime lastAccessed;
  @HiveField(7) double confidence; // 0.0 - 1.0, wie sicher ist die Erinnerung
  @HiveField(8) int accessCount;   // Wie oft wurde die Erinnerung genutzt
}
```

### Memory Retrieval

```dart
class MemoryEngine {
  /// Extrahiert relevante Memories für den aktuellen Kontext
  static List<MemoryEntry> getRelevantMemories(
    String userMessage,
    Box<MemoryEntry> memoryBox,
  ) {
    // 1. Keyword-Matching
    final keywords = _extractKeywords(userMessage);

    // 2. Score each memory by relevance
    final scored = memoryBox.values.map((memory) {
      double score = 0;
      for (final kw in keywords) {
        if (memory.value.toLowerCase().contains(kw)) score += 1;
        if (memory.key.toLowerCase().contains(kw)) score += 2;
      }
      score *= memory.confidence;
      score *= (1 + memory.accessCount * 0.1); // Häufig genutzte = relevanter
      return (memory, score);
    }).where((e) => e.$2 > 0).toList();

    // 3. Top 5 zurückgeben
    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.take(5).map((e) => e.$1).toList();
  }

  /// Baut Memory Context für System Prompt
  static String buildMemoryContext(List<MemoryEntry> memories) {
    if (memories.isEmpty) return '';
    final buffer = StringBuffer('\n## Was du über den User weißt:\n');
    for (final m in memories) {
      buffer.writeln('- ${m.key}: ${m.value}');
    }
    return buffer.toString();
  }
}
```

### Memory Extraction (automatisch)

Nach jeder Konversation: AI extrahiert neue Facts:

```dart
/// Wird nach Gesprächsende aufgerufen
Future<void> extractMemories(List<ChatMessage> conversation) async {
  // Prompt an AI: "Extrahiere Facts aus dieser Konversation"
  // Response wird als MemoryEntry gespeichert
}
```

### Privacy

- Alle Memories lokal (Hive), kein Cloud-Sync
- Nutzer kann Memories einzeln oder komplett löschen
- Memory-Tab in Settings zeigt alle gespeicherten Facts
- Export als JSON möglich

---

## 4. 🎙️ Voice Mode Plan

Voice Input/Output für die Kali Chat App — Sprint 2 Feature.

### Konzept

| Feature | Beschreibung |
|---------|-------------|
| **Voice Input** | Mikrofon drücken → Sprechen → Text wird automatisch in Input-Feld geschrieben |
| **Voice Output** | AI-Response wird mit TTS vorgelesen (optional) |
| **Hands-Free Mode** | Ständig zuhören → automatisch senden wenn Pause erkannt |
| **Kali Voice** | Eigene Stimme für Kali (TTS Voice Selection) |

### Implementation Stack

| Component | Package | Kosten |
|-----------|---------|--------|
| Speech-to-Text | `speech_to_text` | Kostenlos (Device-Engine) |
| Text-to-Speech | `flutter_tts` | Kostenlos (Device-Engine) |
| Audio UI | Custom (Waveform) | — |

### UX Design

```
┌─────────────────────────────────────┐
│                                     │
│  Voice Mode Active                  │
│  ┌───────────────────────────────┐  │
│  │                               │  │
│  │    ╔═══════════════════╗     │  │
│  │    ║  🔊 Sprechen...   ║     │  │
│  │    ║  ▁▃▅▇▅▃▁▃▅▇▅▃▁   ║     │  │
│  │    ╚═══════════════════╝     │  │
│  │                               │  │
│  │    ⏱️ 0:12                     │  │
│  │                               │  │
│  └───────────────────────────────┘  │
│                                     │
│  [⏹️] [↩️] [➤]                      │
│  Stop  Cancel Send                  │
└─────────────────────────────────────┘
```

### TTS Voice Options

| Voice Name | Gender | Accent | Style |
|------------|--------|--------|-------|
| Kali Default | Female | US-English | Neutral |
| Kali Hacker | Male | US-English | Monotone |
| Kali Chaos | Female | UK-English | Dramatic |

### Audio Waveform Animation

Visual Feedback während Voice Input:
- Audio-Levels werden als Bar-Chart visualisiert
- Grün: Aufnahme aktiv
- Rot: Pause/Ende
- Gradient: `accentPrimary` → `accentSuccess`

### Challenges

| Challenge | Lösung |
|-----------|--------|
| Background Noise | Device-Noise-Suppression, Whisper-Threshold |
| Multiple Languages | Language Detection + Auto-Switch |
| Battery Drain | Audio-Processing nur bei aktivem Voice-Mode |
| Long Responses | TTS chunked, mit Pause-Möglichkeit |

---

## 5. 💻 Code Highlighting

Syntax-Highlighting in AI-Responses — essenziell für eine Dev-fokussierte Chat-App.

### Konzept

Kali antwortet oft mit Code. Der Code muss lesbar sein, nicht als plain-text.

### Current State

`flutter_markdown` rendert bereits ```code blocks``` — aber ohne Syntax-Highlighting.

### Enhancement Plan

| Stage | Package | Effort |
|-------|---------|--------|
| **Stage 1** | `flutter_highlight` | Low — Wrapper um `highlight.js` |
| **Stage 2** | `highlight.dart` | Medium — Pure Dart Implementation |
| **Stage 3** | Custom | High — Eigene Tokenizer |

### Recommended: Stage 1 — `flutter_highlight`

```yaml
dependencies:
  flutter_highlight: ^0.4.1
```

### Supported Languages (Priority)

| Sprache | Priorität | Grund |
|---------|-----------|-------|
| Dart | 🔴 Hoch | Flutter Devs |
| Python | 🔴 Hoch | Allgemein beliebt |
| JavaScript/TS | 🔴 Hoch | Web Devs |
| JSON | 🟡 Mittel | API Responses |
| Bash/Shell | 🟡 Mittel | Kali = Security Tool |
| SQL | 🟡 Mittel | Database |
| HTML/CSS | 🟢 Niedrig | Weniger relevant |
| Kotlin/Swift | 🟢 Niedrig | Mobile Devs |

### Design (aus STYLE_GUIDE.md)

```dart
// Code Block Container
Container(
  decoration: BoxDecoration(
    color: Color(0xFF0D1117),  // bgPrimary
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.all(12),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Language Label + Copy Button
      Row(
        children: [
          Text(language, style: caption.copyWith(color: textSecondary)),
          Spacer(),
          IconButton(icon: Icon(Icons.copy, size: 16), onPressed: copy),
        ],
      ),
      SizedBox(height: 8),
      // Highlighted Code
      HighlightView(
        code,
        language: language,
        theme: githubDarkTheme,
        textStyle: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13),
      ),
    ],
  ),
)
```

### GitHub Dark Theme (angepasst)

```dart
final githubDarkTheme = {
  'root': TextStyle(backgroundColor: Color(0xFF0D1117), color: Color(0xFFE6EDF3)),
  'keyword': TextStyle(color: Color(0xFFFF7B72)),
  'string': TextStyle(color: Color(0xFFA5D6FF)),
  'number': TextStyle(color: Color(0xFF79C0FF)),
  'comment': TextStyle(color: Color(0xFF8B949E)),
  'function': TextStyle(color: Color(0xFFD2A8FF)),
  'class': TextStyle(color: Color(0xFF7EE787)),
};
```

### Copy to Clipboard

Jeder Code-Block hat einen Copy-Button:

```dart
IconButton(
  icon: Icon(Icons.copy, size: 16),
  onPressed: () {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Code kopiert'), duration: Duration(seconds: 1)),
    );
  },
)
```

---

## 6. 🎨 Image Generation Integration

Kali kann Bilder generieren — über integrierte Image-Gen-APIs.

### Supported APIs

| API | Endpoint | Modelle | Auth |
|-----|----------|---------|------|
| DALL-E 3 | `https://api.openai.com/v1/images/generations` | `dall-e-3`, `dall-e-2` | Bearer Token (gleich wie Chat) |
| Stable Diffusion | Replicate / Stability AI | `sdxl`, `sd-3` | API Key |
| Gemini Imagen | Vertex AI | `imagen-3` | Google Cloud Auth |

### Trigger Patterns

| User Input | Aktion |
|------------|--------|
| "Generiere mir ein Bild von..." | → Image Generation API |
| "Mach ein Bild von..." | → Image Generation API |
| "Zeig mir..." | → Image Generation API |
| "Draw me a..." | → Image Generation API |

### Implementation

```dart
abstract class ImageGenService {
  Future<GeneratedImage> generate(String prompt, {ImageSize size, int quality});
}

class DalleService implements ImageGenService {
  @override
  Future<GeneratedImage> generate(String prompt, {ImageSize size = ImageSize.square1024, int quality = 1}) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'dall-e-3',
        'prompt': prompt,
        'n': 1,
        'size': size.value,
        'quality': quality == 2 ? 'hd' : 'standard',
      }),
    );
    return GeneratedImage.fromJson(jsonDecode(response.body));
  }
}
```

### Chat Integration

Images werden inline im Chat angezeigt:

```
┌─────────────────────────────────────┐
│  User: Mach ein Bild von einer     │
│  cyberpunk Katze                    │
│                                     │
│  🛡️: Hier ist deine cyberpunk       │
│  Katze:                            │
│  ┌──────────────────────────────┐   │
│  │                              │   │
│  │      [GENERATED IMAGE]       │   │
│  │                              │   │
│  └──────────────────────────────┘   │
│  [💾 Speichern] [🔄 Neu generieren]  │
│  12:34 · dall-e-3                   │
└─────────────────────────────────────┘
```

### Image Display Widget

```dart
class GeneratedImageBubble extends StatelessWidget {
  final String imageUrl;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
        Row(
          children: [
            IconButton(icon: Icon(Icons.save_alt), onPressed: saveToGallery),
            IconButton(icon: Icon(Icons.refresh), onPressed: regenerate),
          ],
        ),
      ],
    );
  }
}
```

### Cost Control

DALL-E 3 kostet $0.040/bild (1024x1024) — Settings-Option:

- [ ] Image Generation aktivieren/deaktivieren
- [ ] Max Bilder pro Tag (Default: 10)
- [ ] Qualität: Standard ($0.04) vs HD ($0.08)
- [ ] Größen: 1024x1024, 1024x1792, 1792x1024

---

## 7. 📊 Feature Priority Matrix (MoSCoW)

Prioritäts-Matrix für alle Features. Basierend auf:
- User Value (wie sehr will der Nutzer das?)
- Technical Effort (wie schwer zu bauen?)
- Dependencies (was muss vorher fertig sein?)
- Revenue Impact (trägt es zum Business bei?)

### Must Have (MVP — Sprint 1)

| # | Feature | Effort | Value | Notes |
|---|---------|--------|-------|-------|
| 1 | **Chat mit Streaming** | 🟡 Medium | 🔴 Hoch | Kern-Feature, SSE implementiert |
| 2 | **Multi-API Support** | 🟡 Medium | 🔴 Hoch | OpenAI + Claude + Gemini |
| 3 | **Chat-History** | 🟢 Low | 🔴 Hoch | Hive implementiert |
| 4 | **Kali-Persönlichkeit** | 🟢 Low | 🔴 Hoch | System Prompt + Templates |
| 5 | **Dark Theme UI** | 🟡 Medium | 🔴 Hoch | STYLE_GUIDE.md definiert |
| 6 | **Settings Screen** | 🟢 Low | 🟡 Mittel | API Key, Model, Personality |
| 7 | **Conversation List** | 🟢 Low | 🟡 Mittel | Chat-Übersicht |
| 8 | **Markdown Rendering** | 🟢 Low | 🔴 Hoch | flutter_markdown implementiert |

### Should Have (Sprint 2)

| # | Feature | Effort | Value | Notes |
|---|---------|--------|-------|-------|
| 9 | **Code Highlighting** | 🟢 Low | 🔴 Hoch | Dev-fokussierte App |
| 10 | **Emotion Responses** | 🟡 Medium | 🟡 Mittel | System Prompt Logic |
| 11 | **Memory System** | 🟡 Medium | 🟡 Mittel | Hive Memory Box |
| 12 | **Voice Input** | 🟡 Medium | 🟡 Mittel | speech_to_text |
| 13 | **Export Chat** | 🟢 Low | 🟢 Niedrig | JSON/Text Export |
| 14 | **Model Switcher** | 🟢 Low | 🟡 Mittel | Mid-Conversation Switch |

### Could Have (Sprint 3)

| # | Feature | Effort | Value | Notes |
|---|---------|--------|-------|-------|
| 15 | **Voice Output (TTS)** | 🟡 Medium | 🟡 Mittel | flutter_tts |
| 16 | **Image Generation** | 🟡 Medium | 🟡 Mittel | DALL-E 3 |
| 17 | **Personality Profiles** | 🟡 Medium | 🟡 Mittel | 5 verschiedene Persönlichkeiten |
| 18 | **Image Upload** | 🔴 Hoch | 🟡 Mittel | Image Analysis |
| 19 | **Search Messages** | 🟡 Medium | 🟡 Mittel | Durchsuchbare History |
| 20 | **Notification System** | 🟡 Medium | 🟢 Niedrig | Response Ready |

### Won't Have (V1)

| # | Feature | Grund |
|---|---------|-------|
| 21 | **Cloud Sync** | Privacy-First, lokal |
| 22 | **Multi-User** | Single-User App |
| 23 | **Plugins/Tools** | Zu früh, V2 |
| 24 | **Custom Models** | API-basiert für jetzt |
| 25 | **AR/VR** | Overkill |

### Implementation Timeline

```
Sprint 1 (Tag 1-7)    ▓▓▓▓▓▓▓▓▓▓ Must Have (1-8)
Sprint 2 (Tag 8-14)   ▓▓▓▓▓▓▓▓░░ Should Have (9-14)
Sprint 3 (Tag 15-21)  ▓▓▓▓▓▓░░░░ Could Have (15-20)
Sprint 4 (Tag 22-28)  ▓▓▓▓░░░░░░ Polish + Launch
```

### Dependency Graph

```
Chat Streaming ──────► Code Highlighting
     │                        │
     ├──► Kali Personality ───┼──► Emotion Responses
     │                        │
     ├──► Chat History ───────┼──► Memory System
     │                        │
     ├──► Settings ───────────┼──► Voice Input
     │                        │
     └──► Multi-API ──────────┼──► Image Generation
                              │
                              └──► Personality Profiles
```

---

## Bonus: Feature Flags

Control-System für Feature-Rollouts:

```dart
class FeatureFlags {
  static const bool codeHighlighting = true;
  static const bool emotionEngine = false;    // Sprint 2
  static const bool memorySystem = false;     // Sprint 2
  static const bool voiceInput = false;       // Sprint 2
  static const bool voiceOutput = false;      // Sprint 3
  static const bool imageGeneration = false;  // Sprint 3
  static const bool personalityProfiles = false; // Sprint 3
}
```

---

## Agent-Notizen

**Für Code Agent:**
- Kali-Persönlichkeit = System Prompt Injection in API Service
- Emotion Responses = Konversations-Analyse → System Prompt Context
- Memory = Separate Hive Box, gleiche Architektur wie Chat-History

**Für Design Agent:**
- Code Blocks brauchen JetBrains Mono + Copy-Button
- Image Bubbles brauchen Loading State + Error State
- Voice Mode UI: Waveform + Floating Action Button

**Für Research Agent:**
- Prüfe: Unterstützen alle APIs custom system prompts?
- Prüfe: Image Generation Preise für DALL-E 3 vs Stable Diffusion
- Prüfe: Best Speech-to-Text Flutter Package 2026

---

*Feature Agent Report — 27.03.2026*
*Basierend auf TASKS.md, FEEDBACK.md, STYLE_GUIDE.md, DAILY_PLAN.md*
