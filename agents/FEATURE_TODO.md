# FEATURE_TODO.md — Tag 3 Focus Tasks

> Feature Agent Tag 3 — 28.03.2026
> 2 Tasks aus FEATURE_TASKS.md für sofortige Umsetzung

---

## Task 1: Code Highlighting — Finish Integration

**Status:** 🔧 IN PROGRESS — Package ist installiert, fehlt Integration

### Dateien zu erstellen/ändern

**1.1 `lib/widgets/code_block.dart` (NEU)**
- Widget `CodeBlock` mit `HighlightView` von `flutter_highlight`
- Sprach-Label oben links, Copy-Button oben rechts
- GitHub Dark Theme (bg: `#0D1117`, border: `#30363D`)
- Horizontal scrollbar wenn Code zu breit
- Copy → Clipboard + Snackbar "Code kopiert"

**1.2 `lib/theme/highlight_theme.dart` (NEU)**
- `githubDarkTheme` Map<String, TextStyle>
- Farben: keyword `#FF7B72`, string `#A5D6FF`, number `#79C0FF`, comment `#8B949E`, function `#D2A8FF`

**1.3 `lib/widgets/chat_bubble.dart` (BEARBEITEN)**
- Regex ` ```(\w+)?\n` → Code-Block parsen
- Plain-text Code-Blocks durch `CodeBlock` Widget ersetzen
- Sprach-Erkennung: dart, python, json, javascript

### Done when:
- [ ] Code-Blocks zeigen Syntax-Highlighting
- [ ] Sprach-Label + Copy-Button sichtbar
- [ ] Snackbar bei Copy
- [ ] Horizontales Scrollen funktioniert

---

## Task 2: Emotion Response System

**Status:** ❌ TODO — System Prompt Logic, kein UI nötig

### Dateien zu erstellen/ändern

**2.1 `lib/services/emotion_engine.dart` (NEU)**
- `buildEmotionalContext(List<ChatMessage> recentMessages)` → String
- Detect: repetitive questions (→ "Sei direkt"), frustration (→ "Sei hilfreich"), complex topics (→ "Sei ausführlich"), humor (→ "Sei locker")
- Kontextuelle Emojis nur in AI-Responses: ✅ ⚠️ ❌ 💡

**2.2 `lib/providers/chat_provider.dart` (BEARBEITEN)**
- EmotionEngine aufrufen, Context nach Personality-Prompt einfügen
- Injection Order: Personality → Emotion → Memory → User Messages

### Done when:
- [ ] Repetitive Fragen → kürzerer Ton
- [ ] Frustration → hilfreicherer Ton
- [ ] Complex Topics → ausführlicherer Ton
- [ ] Emotion Context landet in System Prompt, nicht in UI

---

## Reihenfolge

```
1. Task 1 (Code Highlighting finish)  → schnellster Win
2. Task 2 (Emotion Engine)            → System-Prompt-only, kein UI
```

*Feature Agent Tag 3 — 28.03.2026*
