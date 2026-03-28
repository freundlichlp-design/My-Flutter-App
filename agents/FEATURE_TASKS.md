# FEATURE_TASKS.md - Tag 2 Implementation Tasks

> Feature Agent Report — 28.03.2026
> Konkrete Tasks für Kilo Code basierend auf FEATURES.md und FEEDBACK.md

---

## Status Overview

| Feature | Status | Blocker |
|---------|--------|---------|
| Kali Persönlichkeit System | ✅ DONE | — |
| Code Highlighting | 🔧 IN PROGRESS | Package installiert, fehlt Integration in ChatBubble |
| Emotion Response System | ❌ TODO | System Prompt Logic |
| Memory System | ❌ TODO | Hive Memory Box |
| Voice Mode Vorbereitung | ❌ TODO | UI + Packages |

---

## Task 1: Code Highlighting Implementation

### Ziel
Syntax-Highlighting in ChatBubble für alle AI-Code-Responses.

### Voraussetzungen
- `flutter_highlight` ist bereits in `pubspec.yaml`
- GitHub Dark Theme Definition in FEATURES.md

### Files zu erstellen/ändern

#### 1.1 `lib/widgets/code_block.dart` (NEU)
- Widget `CodeBlock` mit:
  - `HighlightView` von `flutter_highlight`
  - Sprach-Label oben links (z.B. "dart", "python")
  - Copy-Button oben rechts
  - GitHub Dark Theme (Farben aus FEATURES.md)
  - JetBrains Mono Font (oder monospace Fallback)
  - Scrollable horizontal wenn Code zu breit
- Style:
  - Background: `#0D1117`
  - Border Radius: `8`
  - Padding: `12`
  - Sprach-Label: `#8B949E` (textSecondary)
  - Border: `#30363D` (borderDark, 1px)

#### 1.2 `lib/theme/highlight_theme.dart` (NEU)
- Definiere `githubDarkTheme` Map<String, TextStyle>
- Farben:
  - root: `#E6EDF3` auf `#0D1117`
  - keyword: `#FF7B72`
  - string: `#A5D6FF`
  - number: `#79C0FF`
  - comment: `#8B949E`
  - function: `#D2A8FF`
  - class: `#7EE787`
  - operator: `#FF7B72`

#### 1.3 `lib/widgets/chat_bubble.dart` (BEARBEITEN)
- Parse Markdown Code-Blocks in Messages
- Ersetze plain-text Code-Blocks mit `CodeBlock` Widget
- Sprache erkennen: Regex ` ```(\w+)?\n` für Language
- Fallback: auto-detect oder "text"

#### 1.4 Acceptance Criteria
- [ ] Code-Blocks haben Syntax-Highlighting
- [ ] Sprach-Label wird angezeigt
- [ ] Copy-Button kopiert Code in Clipboard
- [ ] Snackbar "Code kopiert" erscheint
- [ ] Horizontales Scrollen bei langem Code
- [ ] Dart, Python, JavaScript werden erkannt
- [ ] JSON wird korrekt formatiert

---

## Task 2: Memory System Implementation

### Ziel
Lokales Memory-System mit Hive Box für User-Facts und Preferences.

### Files zu erstellen/ändern

#### 2.1 `lib/models/memory_entry.dart` (NEU)
- HiveType Model mit typeId: 3
- Fields:
  - `id` (String, Field 0) — UUID
  - `category` (String, Field 1) — "preference", "topic", "personal", "code", "event"
  - `key` (String, Field 2) — z.B. "programming_language"
  - `value` (String, Field 3) — z.B. "Dart/Flutter"
  - `context` (String?, Field 4) — Original-Nachricht
  - `createdAt` (DateTime, Field 5)
  - `lastAccessed` (DateTime, Field 6)
  - `confidence` (double, Field 7) — 0.0-1.0
  - `accessCount` (int, Field 8)
- Hive Adapter generieren: `flutter packages pub run build_runner build`

#### 2.2 `lib/services/memory_engine.dart` (NEU)
- `MemoryEngine` Klasse mit:
  - `getRelevantMemories(String message, Box<MemoryEntry> box)` → List<MemoryEntry>
    - Keyword-Extract aus User-Message
    - Score: keyword match + confidence + accessCount Bonus
    - Top 5 zurückgeben
  - `buildMemoryContext(List<MemoryEntry> memories)` → String
    - Format: "## Was du über den User weißt:\n- key: value"
  - `extractMemories(List<ChatMessage> conversation)` → Future<void>
    - Prompt an AI: Extrahiere Facts aus Konversation
    - Speichere als neue MemoryEntry
  - `deleteMemory(String id)` — Löscht einzelne Erinnerung
  - `clearAll()` — Löscht alle Memories
  - `exportAsJson()` → String — Export für Backup

#### 2.3 `lib/services/hive_storage.dart` (BEARBEITEN)
- Add Memory Box:
  - `static const String memoryBoxName = 'memories';`
  - `late Box<MemoryEntry> _memoryBox;`
  - `Box<MemoryEntry> get memoryBox => _memoryBox;`
- In `init()`: `_memoryBox = await Hive.openBox<MemoryEntry>(memoryBoxName);`
- In `close()`: `await _memoryBox.close();`

#### 2.4 `lib/providers/chat_provider.dart` (BEARBEITEN)
- Bei senden einer Message: Relevante Memories laden
- Memory-Context in System Prompt injecten
- Nach Konversation (optional): Auto-Extract neue Memories

#### 2.5 `lib/screens/memory_settings_screen.dart` (NEU)
- Übersicht aller gespeicherten Memories
- Gruppiert nach Category
- Löschen-Button pro Entry
- "Alle löschen" Button mit Confirmation
- Export-Button (JSON Download)

#### 2.6 Acceptance Criteria
- [ ] Hive Memory Box öffnet sich beim App-Start
- [ ] Relevante Memories werden in System Prompt injectet
- [ ] Memory-Settings-Screen zeigt alle Einträge
- [ ] Einzelne Memories können gelöscht werden
- [ ] "Alle löschen" zeigt Confirmation Dialog
- [ ] JSON Export funktioniert
- [ ] Memory extraction nach Konversation speichert neue Facts

---

## Task 3: Emotion Response System

### Ziel
Kali reagiert emotional über Ton und Wortwahl, nicht über UI-Emojis.

### Files zu erstellen/ändern

#### 3.1 `lib/services/emotion_engine.dart` (NEU)
- `EmotionEngine` Klasse mit:
  - `buildEmotionalContext(List<ChatMessage> recentMessages)` → String
    - Detect repetitive questions (>2x ähnliche Frage → "Der User fragt bereits wiederholt dasselbe. Sei direkt.")
    - Detect frustration (Fehlermeldungen, "nicht funktioniert", "warum nicht" → "Der User scheint frustriert. Sei hilfreich und kurz.")
    - Detect complex topics (lange Messages, Code-Blocks, technische Begriffe → "Dies ist ein spannendes Thema. Du darfst ausführlicher sein.")
    - Detect humor/fun (lustige Fragen, kreative Bitten → "Der User will Spaß. Sei locker.")
  - `_hasRepetitiveQuestions(List<ChatMessage> messages)` → bool
    - Vergleiche letzte 5 User-Messages auf Ähnlichkeit (Cosine oder Keyword-Overlap)
  - `_showsFrustration(List<ChatMessage> messages)` → bool
    - Keywords: "nicht", "warum", "geht nicht", "fehler", "bug", "kaputt", "scheiße"
  - `_hasComplexTopic(List<ChatMessage> messages)` → bool
    - Message-Länge > 200 Zeichen, Code-Blocks, technische Keywords
  - Emoji Mapping (minimal, nur CONTEXTUELLE):
    - Erfolg nach Debugging → ✅
    - Sicherheitsproblem → ⚠️
    - Code-Fehler → ❌
    - Kreative Lösung → 💡

#### 3.2 `lib/providers/chat_provider.dart` (BEARBEITEN)
- `EmotionEngine.buildEmotionalContext()` aufrufen
- Emotional Context als zusätzlichen System Prompt Context injecten
- NACH dem Personality-Prompt, VOR dem Memory-Context

#### 3.3 Integration Order im System Prompt
1. Personality System Prompt
2. Emotional Context (EmotionEngine)
3. Memory Context (MemoryEngine)
4. User Messages

#### 3.4 Acceptance Criteria
- [ ] Bei repetitiven Fragen wird Ton kürzer
- [ ] Bei frustriertem User wird hilfreicher Ton aktiviert
- [ ] Bei complex Topics wird ausführlicher Ton aktiviert
- [ ] Emotion Context wird NUR in System Prompt injectet, nicht in UI
- [ ] Keine dumm-emojis in Chat-UI, nur kontextuelle in Responses

---

## Task 4: Voice Mode Vorbereitung

### Ziel
Voice Input/Output UI vorbereiten, auch wenn Backend noch nicht fertig ist.

### Files zu erstellen/ändern

#### 4.1 `pubspec.yaml` (BEARBEITEN)
- Add Dependencies:
  ```yaml
  speech_to_text: ^6.6.0
  flutter_tts: ^4.0.1
  ```

#### 4.2 `lib/widgets/voice_input_button.dart` (NEU)
- Floating/Microphone Button im Chat-Screen
- States: idle, listening, processing
- Animation:
  - Idle: Graues Mikrofon-Icon
  - Listening: Grüner Pulse-Animation
  - Processing: Lade-Indicator
- Callback: `onVoiceResult(String recognizedText)`
- Tap: Start/Stop Recording

#### 4.3 `lib/widgets/voice_overlay.dart` (NEU)
- Full-Screen Overlay wenn Voice Mode aktiv
- Layout:
  - Oben: "Voice Mode Active" Header
  - Mitte: Waveform-Animation (Audio-Levels als Bar-Chart)
  - Unten: Text-Preview der Erkennung
  - Bottom: [⏹️ Stop] [↩️ Cancel] [➤ Send] Buttons
- Audio-Waveform:
  - 20 vertikale Bars
  - Farb-Gradient: `accentPrimary` (#7C3AED) → `accentSuccess` (#22C55E)
  - Animation basierend auf Audio-Levels
- Timer-Display: "0:12" oben rechts

#### 4.4 `lib/services/voice_service.dart` (NEU)
- Wrapper um `speech_to_text` und `flutter_tts`
- `VoiceService` Klasse:
  - `initSpeech()` → Future<bool>
  - `startListening()` → Future<void>
  - `stopListening()` → Future<String?> (recognized text)
  - `isListening` → bool
  - `speak(String text)` → Future<void> (TTS)
  - `stopSpeaking()` → Future<void>
  - `availableVoices` → List<String>
  - `setVoice(String voiceName)` → Future<void>

#### 4.5 `lib/screens/voice_settings_screen.dart` (NEU)
- Einstellungen für Voice Mode:
  - [ ] Voice Input aktivieren/deaktivieren
  - [ ] Voice Output (TTS) aktivieren/deaktivieren
  - [ ] TTS Stimme auswählen (Dropdown)
  - [ ] TTS Geschwindigkeit (Slider: 0.5x - 2.0x)
  - [ ] Hands-Free Mode (Toggle)

#### 4.6 Feature Flags Update
- In `lib/config/feature_flags.dart` (falls vorhanden):
  - `static const bool voiceInput = true;` — Aktivieren
  - `static const bool voiceOutput = false;` — Noch nicht

#### 4.7 Acceptance Criteria
- [ ] `speech_to_text` und `flutter_tts` in pubspec.yaml
- [ ] Voice Input Button im Chat-Screen sichtbar
- [ ] Button zeigt korrekten State (idle/listening/processing)
- [ ] Voice Overlay erscheint beim Tap
- [ ] Waveform-Animation läuft
- [ ] Text-Preview zeigt erkannten Text
- [ ] Stop/Cancel/Send Buttons funktionieren
- [ ] Voice Settings Screen erreichbar
- [ ] TTS Settings speicherbar

---

## Implementation Order

```
Tag 2 Priorität:
1. Code Highlighting (Task 1)    → ~2 Stunden
2. Emotion Engine (Task 3)       → ~2 Stunden
3. Memory System (Task 2)        → ~3 Stunden
4. Voice Mode (Task 4)           → ~2 Stunden

Abhängigkeiten:
- Task 1 ist unabhängig (kann sofort starten)
- Task 3 braucht ChatProvider (existiert)
- Task 2 braucht HiveStorage (existiert)
- Task 4 ist unabhängig (neue Packages)
```

---

## Für Kilo Code: Quick-Start

1. **Start mit Task 1** — Code Highlighting ist der schnellste Win
2. **Dann Task 3** — Emotion Engine ist System-Prompt-only, kein UI
3. **Dann Task 2** — Memory System braucht mehr Files
4. **Zuletzt Task 4** — Voice Mode ist Vorbereitung, nicht vollständig

**Test nach jedem Task:** `flutter run` und manuell prüfen ob Features funktionieren.

---

*Feature Agent Tag 2 — 28.03.2026*
*Basierend auf FEATURES.md und FEEDBACK.md*
