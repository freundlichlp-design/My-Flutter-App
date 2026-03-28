# Bug Agent Tag 3 — BUGS_UPDATE.md

**Datum:** 2026-03-28
**Focus:** Neue Features (Articles, Streaming, Multi-Provider, Conversations)
**Geprüft:** 29 .dart Dateien, Focus auf 5 Dateien

---

## 🔴 KRITISCH

### BUG-B3-01: Streaming Timer zeigt unformatierte Sekunden
- **Datei:** `lib/widgets/streaming_indicator.dart` ~Zeile 80
- **Problem:** `${widget.elapsedTime!.inMilliseconds / 1000.0}s` zeigt Werte wie `1.5340000000000002s` statt `1.53s`
- **Fix:** `toStringAsFixed(2)` verwenden:
  ```dart
  '${(widget.elapsedTime!.inMilliseconds / 1000.0).toStringAsFixed(2)}s'
  ```
- **Impact:** UI sieht unprofessionell aus, Layout kann springen

---

### BUG-B3-02: Claude Service Bug — SSE Lines enthalten `event:` Prefix nicht
- **Datei:** `lib/services/claude_service.dart` ~Zeile 70
- **Problem:** Claude SSE Streams senden manchmal Zeilen mit `event: content_block_delta` VOR dem `data:` Feld. Der Parser filtert nur nach `data: ` und ignoriert diese Zeilen — aber wenn `event:` Zeilen unerwartet gemischt werden, kann der LineSplitter Lines produzieren die NICHT mit `data: ` anfangen aber trotzdem JSON enthalten
- **Impact:** Mögliche stille Datenverluste bei bestimmten Claude Response-Patterns
- **Severity:** Mittel — sollte aber gefixt werden

---

## 🟡 MITTEL

### BUG-B3-03: Archive-Feature ist Dummy
- **Datei:** `lib/screens/conversations_screen.dart` ~Zeile 88
- **Problem:** `onArchive:` Callback zeigt nur einen SnackBar mit "Archived: ${conversation.title}", aber archiviert die Conversation nicht tatsächlich. Weder wird ein `isArchived` Flag gesetzt, noch wird sie aus der Liste entfernt
- **Impact:** User denkt Feature funktioniert, aber passiert nichts
- **Fix:** Entweder Archive-Logik implementieren oder Button entfernen

---

### BUG-B3-04: Kein Stream-Cancellation bei Navigation
- **Datei:** `lib/services/ai_api_service.dart` + `lib/services/openai_service.dart`
- **Problem:** Abstract Interface `AiApiService` hat keine `cancelStream()` Methode. Wenn User während Streaming die Conversation wechselt oder die App schließt, läuft der HTTP Request weiter und der StreamController wird nie geschlossen
- **Impact:** Memory Leak, unnötige API-Kosten, possible Crash bei `notifyListeners()` auf disposed Provider
- **Fix:** `StreamSubscription` in Services halten + `cancel()` Methode im Interface

---

### BUG-B3-05: Chat Provider wirft partielle Nachricht bei Fehler weg
- **Datei:** `lib/providers/chat_provider.dart` ~Zeile 102
- **Problem:** Bei Streaming-Fehler wird letzte Message komplett gelöscht wenn content leer ist. Aber wenn der Stream bereits Content geliefert hat bevor er abbricht, ist dieser Content verloren
- **Code:**
  ```dart
  if (_messages.isNotEmpty && _messages.last.content.isEmpty) {
    _messages.removeLast();
  }
  ```
- **Problem:** Wenn content NICHT leer ist, bleibt die partial message UNEDITIERT im Chat ohne Fehler-Indikator. User sieht unvollständige Antwort als wäre sie komplett
- **Fix:** Bei Fehler + non-empty partial content → "⚠️ Response incomplete" hint anhängen

---

## 🟢 NIEDRIG

### BUG-B3-06: Kein Fallback bei fehlendem API Key für gewählten Provider
- **Datei:** `lib/providers/chat_provider.dart` + `lib/providers/settings_provider.dart`
- **Problem:** User kann Provider wechseln (z.B. OpenAI → Claude) ohne API Key für neuen Provider zu setzen. Erst beim Senden kommt "Please configure an API key in Settings first." — aber Provider-Switch ohne Key sollte UI-Feedback geben (z.B. Warnung, Dropdown gesperrt)
- **Impact:** UX-Reibung

---

### BUG-B3-07: `_PulsingDot` benutzt `withValues(alpha:)` statt `withOpacity()`
- **Datei:** `lib/widgets/streaming_indicator.dart` ~Zeile 129
- **Problem:** `KaliColors.accentSuccess.withValues(alpha: 0.5 + _controller.value * 0.5)` — `withValues` ist Flutter 3.27+ only. Ältere Flutter Versionen brauchen `withOpacity()`
- **Impact:** Build-Failure auf älteren Flutter Versionen (dasselbe Pattern in `conversations_screen.dart` gefunden)

---

### BUG-B3-08: Message Input Hardcoded Deutsch
- **Datei:** `lib/widgets/message_input.dart` ~Zeile 77
- **Problem:** `hintText: 'Schreibe eine Nachricht...'` ist hardcoded auf Deutsch. Rest der App ist Englisch
- **Impact:** Inkonsistente Sprache, Internationalisierung nicht möglich

---

## 📊 Zusammenfassung

| Severity | Anzahl | Status |
|----------|--------|--------|
| 🔴 Kritisch | 2 | OPEN |
| 🟡 Mittel | 3 | OPEN |
| 🟢 Niedrig | 3 | OPEN |
| **Gesamt** | **8** | |

## 🔧 Empfohlene Priority für Tag 4

1. **BUG-B3-01** — Sofort fixen (1-Zeiler, sofort sichtbar)
2. **BUG-B3-04** — Stream cancellation implementieren (Memory Leak)
3. **BUG-B3-05** — Partial content bei Fehlern konservieren
4. **BUG-B3-03** — Archive implementieren oder entfernen

## Geprüfte Dateien (5 Fokus)

| Datei | Bugs gefunden |
|-------|---------------|
| `lib/widgets/streaming_indicator.dart` | 2 (B3-01, B3-07) |
| `lib/services/claude_service.dart` | 1 (B3-02) |
| `lib/providers/chat_provider.dart` | 2 (B3-05, B3-06) |
| `lib/screens/conversations_screen.dart` | 2 (B3-03, B3-07) |
| `lib/widgets/message_input.dart` | 1 (B3-08) |

**Git-Commit:** `Bug Agent Tag 3`
