# FEATURE_DAILY.md - Tag 4 Tasks

> Feature Agent — 28.03.2026

---

## Status

| Feature | Status |
|---------|--------|
| Code Highlighting | 🔧 IN PROGRESS |
| Emotion Response | ❌ TODO |
| Memory System | ❌ TODO |
| Voice Mode | ❌ TODO |

---

## Task 1: Code Highlighting — ChatBubble Integration

### Ziel
Code-Block Highlighting in ChatBubble vollständig integrieren.

### Fortschritt
- ✅ `flutter_highlight` installiert
- ✅ GitHub Dark Theme definiert
- ❌ Chat-Integration fehlt

### Schritte

1. **`lib/widgets/code_block.dart` erstellen**
   - `HighlightView` mit GitHub Dark Theme
   - Sprach-Label (top-left)
   - Copy-Button mit Clipboard
   - Horizontales Scrollen

2. **`lib/widgets/chat_bubble.dart` anpassen**
   - Markdown Code-Block Parser
   - Regex: ` ```(\w+)?\n` für Sprach-Erkennung
   - Ersetze plain-text durch `CodeBlock` Widget

3. **Test**
   - Syntax-Highlighting für Dart, Python, JavaScript
   - Copy-Funktion → Snackbar "Code kopiert"
   - Responsive Layout bei langem Code

### Acceptance Criteria
- [ ] Code-Blocks haben Syntax-Highlighting
- [ ] Sprach-Label sichtbar
- [ ] Copy-Button kopiert in Clipboard
- [ ] Scrollable bei langem Code

---

## Task 2: Emotion Engine — Basis

### Ziel
EmotionEngine Grundgerüst für emotionale Response-Steuerung.

### Files

1. **`lib/services/emotion_engine.dart`**
   - `buildEmotionalContext()` → System Prompt String
   - Repetitive Question Detection
   - Frustration Detection (Keywords)
   - Complex Topic Detection

2. **Integration in ChatProvider**
   - `EmotionEngine.buildEmotionalContext()` aufrufen
   - Context nach Personality, vor Memory injecten

### Acceptance Criteria
- [ ] `emotion_engine.dart` erstellt
- [ ] Repetitive Questions Detection
- [ ] Frustration Detection aktiv
- [ ] System Prompt Context injected

---

## Reihenfolge

```
Vormittag: Code Highlighting (~2h)
Nachmittag: Emotion Engine (~2h)
Abend: Test + Commit
```

---

*Feature Agent Tag 4 — 28.03.2026*