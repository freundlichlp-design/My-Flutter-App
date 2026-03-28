# FEATURE_DAILY.md - Tag 4 Tasks

> Feature Agent — 28.03.2026
> Tägliche Tasks für Feature-Entwicklung

---

## Status Update

| Feature | Status | Letzte Aktualisierung |
|---------|--------|----------------------|
| Code Highlighting | 🔧 IN PROGRESS | Tag 2 — Integration ausstehend |
| Emotion Response System | ❌ TODO | — |
| Memory System | ❌ TODO | — |
| Voice Mode | ❌ TODO | — |

---

## Task 1: Code Highlighting — ChatBubble Integration (Tag 4)

### Ziel
Code-Block Highlighting in ChatBubble Widget vollständig integrieren.

### Fortschritt
- ✅ `flutter_highlight` Package installiert
- ✅ GitHub Dark Theme definiert
- ❌ Chat-Integration fehlt

### Heutige Schritte

1. **`lib/widgets/code_block.dart` erstellen**
   - `HighlightView` mit GitHub Dark Theme
   - Sprach-Label (top-left)
   - Copy-Button mit Clipboard
   - Horizontales Scrollen

2. **`lib/widgets/chat_bubble.dart` anpassen**
   - Markdown Code-Block Parser
   - Regex: ` ```(\w+)?\n` für Sprach-Erkennung
   - Ersetze plain-text durch `CodeBlock` Widget

3. **Test & Validate**
   - Syntax-Highlighting für Dart, Python, JavaScript
   - Copy-Funktion → Snackbar "Code kopiert"
   - Responsive Layout bei langem Code

### Acceptance Criteria
- [ ] Code-Blocks haben Syntax-Highlighting
- [ ] Sprach-Label sichtbar (dart, python, json)
- [ ] Copy-Button kopiert in Clipboard
- [ ] Snackbar-Bestätigung erscheint
- [ ] Scrollable bei langem Code

---

## Task 2: Emotion Engine — Basis-System (Tag 4)

### Ziel
EmotionEngine Grundgerüst für emotionale Response-Steuerung.

### Files zu erstellen

1. **`lib/services/emotion_engine.dart`**
   - `buildEmotionalContext()` → System Prompt String
   - Repetitive Question Detection
   - Frustration Detection (Keywords)
   - Complex Topic Detection

2. **Integration in ChatProvider**
   - `EmotionEngine.buildEmotionalContext()` aufrufen
   - Context nach Personality, vor Memory injecten

### Erste Implementierung

```dart
// emotion_engine.dart
class EmotionEngine {
  String buildEmotionalContext(List<ChatMessage> messages) {
    final recent = messages.reversed.take(10).toList();
    
    if (_hasRepetitiveQuestions(recent)) {
      return "Der User fragt bereits wiederholt dasselbe. Sei direkt.";
    }
    if (_showsFrustration(recent)) {
      return "Der User scheint frustriert. Sei hilfreich und kurz.";
    }
    if (_hasComplexTopic(recent)) {
      return "Dies ist ein spannendes Thema. Du darfst ausführlicher sein.";
    }
    return "";
  }
  
  bool _hasRepetitiveQuestions(List<ChatMessage> msgs) {
    // Keyword-Overlap Vergleich
  }
  
  bool _showsFrustration(List<ChatMessage> msgs) {
    // Keywords: "nicht", "warum", "fehler", "geht nicht"
  }
  
  bool _hasComplexTopic(List<ChatMessage> msgs) {
    // Message-Länge > 200, Code-Blocks
  }
}
```

### Acceptance Criteria
- [ ] `emotion_engine.dart` erstellt
- [ ] Repetitive Questions Detection funktioniert
- [ ] Frustration Detection aktiv
- [ ] System Prompt Context wird injected
- [ ] Keine UI-Emojis, nur Ton-Anpassung

---

## Implementation Reihenfolge

```
Vormittag:
1. Code Highlighting fertigstellen (~2h)

Nachmittag:
2. Emotion Engine Basis (~2h)

Abend:
- Test-Run: `flutter run`
- Commit: Feature Agent Tag 4
```

---

## Quick-Start für Kilo Code

1. **Starte mit Task 1** — Code Highlighting ist fast fertig
2. **Dann Task 2** — Emotion Engine ist System-Prompt-only
3. **Test nach jedem Task** — `flutter run` und prüfen

---

*Feature Agent Tag 4 — 28.03.2026*
*Fokus: Code Highlighting fertigstellen + Emotion Engine starten*