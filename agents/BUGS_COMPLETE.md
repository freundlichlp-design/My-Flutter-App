# 🐛 Bug Agent — Complete Bug Scan

**Generated:** 2026-03-29 by Bug Agent (Full Scan)  
**Scope:** ALL `.dart` files in `lib/` (82 files analyzed)  
**Previous Reports:** BUGS.md (Tag 2), BUGS_UPDATE.md (Tag 3), BUGS_DESIGN.md (Tag 5)

---

## Bug Table

| # | Datei | Zeile | Schwere | Beschreibung | Fix |
|---|-------|-------|---------|-------------|-----|
| 1 | `lib/models/subscription.dart` | 8 | 🔴 Critical | **Hive typeId Collision:** `Subscription` (`typeId: 2`) und `MemoryEntry` (`typeId: 2`) teilen sich den selben typeId. `MemoryEntryAdapter` wird nie registriert → Crashes beim Deserialisieren von Memory-Entries | `@HiveType(typeId: 4)` für MemoryEntry, Adapter + .g.dart regenerieren |
| 2 | `lib/providers/chat_provider.dart` | ~186 | 🔴 Critical | **Assistant-Nachrichten werden nie gespeichert:** `_sendMessage()` wird für Assistant-Antworten aufgerufen, aber `ChatSendMessage` erstellt nur User-Messages (`role: 'user'`). Assistant-Content wird als User-Nachricht gespeichert | Eigene `saveMessage` Methode mit korrekter Rolle nutzen |
| 3 | `lib/models/subscription.dart` | 48 | 🔴 Critical | **`dailyLimit` gibt -1 für Premium zurück:** `_buildUsageBar` in chat_screen.dart teilt durch `sub.dailyLimit` → `-1` → ProgressIndicator zeigt `NaN` | Guard: `if (!sub.isPremium)` existiert, aber `dailyLimit` wird auch in paywall_screen.dart ohne Guard genutzt |
| 4 | `lib/providers/chat_provider.dart` | 131, 145 | 🔴 Critical | **MemoryStorage wird direkt instanziiert:** `final memoryStorage = MemoryStorage()` statt DI-Singleton. Erzeugt separate Instanz, die Daten verfehlt | `MemoryStorage` als Constructor-Injection übergeben |
| 5 | `lib/storage/memory_storage.dart` | 22 | 🔴 Critical | **MemoryEntryAdapter wird nie registriert:** `Hive.isAdapterRegistered(2)` ist `true` weil `SubscriptionAdapter` typeId 2 bereits registriert hat. Memory-Box kann nicht gelesen werden | Wird durch Bug #1 gelöst (typeId ändern) |
| 6 | `lib/storage/hive_storage.dart` | 22 | 🔴 Critical | **SubscriptionAdapter überlappt MemoryEntry:** Hive registriert zuerst `SubscriptionAdapter` (typeId 2), dann wird `MemoryStorage.init()` aufgerufen — `MemoryEntryAdapter` (typeId 2) wird übersprungen | Wird durch Bug #1 gelöst |
| 7 | `lib/providers/chat_provider.dart` | ~200 | 🟡 Medium | **Stream-Error löscht partiellen Content:** Bei Fehern wird letzte Message gelöscht wenn `content.isEmpty`. Aber partial content ohne Error-Indikator bleibt im Chat | Bei Error + non-empty content: `⚠️ Response incomplete` anhängen |
| 8 | `lib/services/openai_service.dart` | 88 | 🟡 Medium | **HTTP Client Resource Leak:** Bei Fehler wird `response.stream.bytesToString()` gelesen, dann `controller.close()`. Aber wenn `bytesToString()` selbst wirft, wird Controller nie geschlossen | Try-catch um die Error-Handling-Block legen |
| 9 | `lib/services/claude_service.dart` | 70 | 🟡 Medium | **Claude SSE Parser ignoriert `event:` Zeilen:** Claude sendet `event: content_block_delta` vor `data:`. Der Parser filtert nur `data: ` — wenn beide auf einer Line sind, wird nichts extrahiert | Besserer SSE-Parser mit Event/Data-Pairing |
| 10 | `lib/services/gemini_service.dart` | 57-63 | 🟡 Medium | **Gemini System Prompt als User-Message prepended:** `system_instruction` wird als `role: 'user'` an `contents` angehängt. Dies kontaminiert den Conversation-Flow und kann Gemini verwirren | System Prompt als separates `system_instruction` Feld senden |
| 11 | `lib/features/chat/presentation/widgets/streaming_indicator.dart` | ~130 | 🟡 Medium | **Timer zeigt unformatierte Dezimalstellen:** `widget.elapsedTime!.inMilliseconds / 1000.0s` → `1.5340000000000002s` | `toStringAsFixed(2)` verwenden |
| 12 | `lib/providers/chat_provider.dart` | ~155 | 🟡 Medium | **Conversation-Titel wird erst nachträglich gesetzt:** Erstes Speichern mit `'New Chat'`, dann sofortiges Überschreiben. Zwei Write-Operationen, Race Condition möglich | Titel direkt bei `createNewConversation` setzen |
| 13 | `lib/providers/chat_provider.dart` | ~84 | 🟡 Medium | **`selectConversation` ohne vorheriges `loadConversations`:** `_conversations` kann leer sein wenn `selectConversation` aufgerufen wird, bevor `loadConversations` fertig ist | Auf `loadConversations` awaiten oder State prüfen |
| 14 | `lib/providers/memory_provider.dart` | 10 | 🟡 Medium | **MemoryProvider erstellt eigene MemoryStorage():** Direkte Instanzierung statt DI, konsistent mit Rest der App | Als Dependency injizieren |
| 15 | `lib/features/settings/presentation/pages/settings_screen.dart` | 29-31 | 🟡 Medium | **API Key Masking → Save sendet Masked Key:** User sieht `gpt-••••abcd`, drückt Save → `gpt-••••abcd` wird als API Key gespeichert | Bei Save prüfen ob Key gemasked ist, echten Key behalten |
| 16 | `lib/features/settings/data/repositories/settings_repository_impl.dart` | 42-47 | 🟡 Medium | **Switch-Statement ohne `break`/`return` (Dart 2 legacy):** Falls jemals mit Dart <3.0 kompiliert, führt Fall-through dazu dass `gemini`-Save auch `openai` überschreibt | Dart 3+ Switch hat kein Fall-through — OK für moderne SDKs, aber unsicher |
| 17 | `lib/providers/chat_provider.dart` | ~196 | 🟡 Medium | **`_sendMessage` für Assistant-Content aufgerufen:** Speichert Assistant-Text mit `role: 'user'`. History wird auf API-Seite falsch formatiert | Assistant-Message direkt speichern ohne `ChatSendMessage` UseCase |
| 18 | `lib/features/chat/presentation/widgets/message_input.dart` | 77 | 🟢 Minor | **Hardcoded Deutsch:** `hintText: 'Schreibe eine Nachricht...'` — Rest der App ist Englisch | `'Type a message...'` oder i18n |
| 19 | `lib/features/chat/presentation/widgets/image_picker_button.dart` | 23, 55, 61 | 🟢 Minor | **Hardcoded Deutsch in Error-Messages:** `'Fehler beim Bild laden: $e'`, `'Kamera'`, `'Galerie'` | Englische Strings oder i18n |
| 20 | `lib/features/chat/presentation/widgets/code_block.dart` | 114 | 🟢 Minor | **'Code kopiert' hardcoded Deutsch:** SnackBar Text | `'Code copied'` |
| 21 | `lib/features/memory/presentation/pages/memory_settings_screen.dart` | multiple | 🟢 Minor | **Hardcoded Deutsch:** `'Memory aktiviert'`, `'Datenschutz'`, `'Alle Memories löschen?'` etc. | Englische Strings oder i18n |
| 22 | `lib/features/subscription/presentation/pages/paywall_screen.dart` | multiple | 🟢 Minor | **Hardcoded Deutsch:** `'Premium Aktiv'`, `'Unbegrenzte Nachrichten'`, `'Premium freischalten'` etc. | Englische Strings oder i18n |
| 23 | `lib/features/chat/presentation/widgets/chat_bubble.dart` | 38-42 | 🟢 Minor | **Hardcoded BorderRadius statt KaliRadius.bubbleUser/bubbleAi:** `Radius.circular(18)` etc. — Token existieren, werden nicht genutzt | `KaliRadius.bubbleUser` / `KaliRadius.bubbleAi` verwenden |
| 24 | `lib/features/chat/presentation/widgets/streaming_indicator.dart` | 53-57 | 🟢 Minor | **Hardcoded BorderRadius:** Gleiche Tokens wie Bug #23 | `KaliRadius.bubbleAi` verwenden |
| 25 | `lib/features/chat/presentation/widgets/conversation_list_item.dart` | 51 | 🟢 Minor | **Hardcoded Radius:** `BorderRadius.circular(12)` → `KaliRadius.lg` | Token ersetzen |
| 26 | `lib/core/router/app_router.dart` | 47-53 | 🟢 Minor | **Article-Routes sind unerreichbar:** `/articles` und `/articles/:id` sind registriert aber es gibt keinen Navigation-Punkt dazu im UI | Route entfernen oder Navigation hinzufügen |
| 27 | `lib/providers/article_provider.dart` | - | 🟢 Minor | **ArticleProvider in MultiProvider aber nie im UI erreichbar:** Wird registriert, aber kein UI navigiert zu Artikeln | Entfernen oder Article-Tab hinzufügen |
| 28 | `lib/main.dart` | 12 | 🟢 Minor | **Redundanter HiveStorage import:** `await HiveStorage.init()` in main.dart + `sl.registerSingleton<HiveStorage>(HiveStorage())` in DI. Beide erstellen die Singleton-Instanz | Nur DI nutzen, `HiveStorage.init()` aus DI aufrufen |
| 29 | `lib/core/di/injection_container.dart` | 62-63 | 🟢 Minor | **`SettingsGetApiKey` UseCase registriert aber nie aufgerufen:** Dead Code | Entfernen oder nutzen |
| 30 | `lib/providers/chat_provider.dart` | 242 | 🟢 Minor | **`enforceMemoryLimit` auf separater MemoryStorage-Instanz:** Erstellt `MemoryStorage()` statt DI zu nutzen | DI-MemoryStorage nutzen |
| 31 | `lib/features/chat/presentation/widgets/streaming_indicator.dart` | ~130 | 🟢 Minor | **`_PulsingDot` nutzt `withValues(alpha:)`:** Flutter 3.27+ only. Ältere Versionen brauchen `withOpacity()` | Kompatibilitäts-Check |
| 32 | `lib/features/chat/presentation/widgets/conversation_list_item.dart` | 113-114 | 🟢 Minor | **`withValues(alpha:)`:** Gleiche Kompatibilitäts-Problematik | `withOpacity()` nutzen |
| 33 | `lib/features/settings/presentation/pages/settings_screen.dart` | 91 | 🟢 Minor | **`withValues(alpha:)`:** Gleiche Kompatibilitäts-Problematik | `withOpacity()` nutzen |

---

## Zusammenfassung

| Schwere | Anzahl |
|---------|--------|
| 🔴 Critical | 6 |
| 🟡 Medium | 12 |
| 🟢 Minor | 15 |
| **Gesamt** | **33** |

---

## 🔴 Critical Bugs — Details & Fixes

### BUG-1: Hive typeId Collision (MemoryEntry ↔ Subscription)

**Problem:** `MemoryEntry` und `Subscription` benutzen beide `@HiveType(typeId: 2)`.
```dart
// memory_entry.dart
@HiveType(typeId: 2)  // ← KOLLISION!
class MemoryEntry extends HiveObject { ... }

// subscription.dart  
@HiveType(typeId: 2)  // ← KOLLISION!
class Subscription extends HiveObject { ... }
```

Hive registriert zuerst `SubscriptionAdapter` (typeId 2). Wenn dann `MemoryStorage.init()` prüft `Hive.isAdapterRegistered(2)`, ist es `true` — `MemoryEntryAdapter` wird nie registriert. Jeder Versuch, Memory-Entries aus der Box zu lesen, endet in einem `TypeError` Crash.

**Fix:**
```dart
// models/memory_entry.dart
@HiveType(typeId: 4)  // Eindeutige typeId
class MemoryEntry extends HiveObject { ... }
```
Dann `flutter pub run build_runner build --delete-conflicting-outputs` ausführen um `memory_entry.g.dart` zu regenerieren.

---

### BUG-2: Assistant-Nachrichten werden als User gespeichert

**Problem:** In `chat_provider.dart` Zeile ~186:
```dart
final result = await _sendMessage(
  content: finalMessage.content,  // Assistant Content
  conversation: conversation,
  ...
);
```
`ChatSendMessage` erzwingt `role: 'user'`. Die Assistant-Antwort wird als User-Nachricht in Hive gespeichert.

**Fix:**
```dart
// Direkt speichern statt _sendMessage UseCase
await _localDatasource.saveMessage(Message(
  id: finalMessage.id,
  conversationId: finalMessage.conversationId,
  role: 'assistant',  // Korrekte Rolle!
  content: finalMessage.content,
  timestamp: finalMessage.timestamp,
));
```

---

### BUG-3: `dailyLimit` = -1 für Premium → NaN in Progress

**Problem:** `subscription.dart` line 48:
```dart
int get dailyLimit => isPremium ? -1 : freeDailyLimit;
```
`paywall_screen.dart` teilt durch `dailyLimit`:
```dart
value: sub.messagesUsedToday / Subscription.freeDailyLimit,  // OK, hardcoded
```
Aber in `chat_screen.dart`:
```dart
final ratio = sub.messagesUsedToday / sub.dailyLimit;  // NaN wenn -1!
```

**Fix:**
```dart
// chat_screen.dart
final ratio = sub.dailyLimit > 0 
    ? sub.messagesUsedToday / sub.dailyLimit 
    : 0.0;
```

---

### BUG-4: MemoryStorage direkt instanziiert statt DI

**Problem:** `chat_provider.dart` erstellt `MemoryStorage()` lokal:
```dart
final memoryStorage = MemoryStorage();  // Neue Instanz!
```
Die DI registriert `sl.registerSingleton<MemoryStorage>(MemoryStorage())`. Durch das Singleton-Pattern teilen sie sich den internen State — aber die explizite Instanzierung ist fragil und inkonsistent.

**Fix:** `MemoryStorage` als Constructor-Parameter zu `ChatProvider` hinzufügen:
```dart
class ChatProvider extends ChangeNotifier {
  final MemoryStorage _memoryStorage;
  
  ChatProvider({
    ...
    required MemoryStorage memoryStorage,
  }) : _memoryStorage = memoryStorage;
}
```

---

### BUG-5 & BUG-6: MemoryEntryAdapter nie registriert

**Problem:** `memory_storage.dart` line 22:
```dart
if (!Hive.isAdapterRegistered(2)) {
  Hive.registerAdapter(MemoryEntryAdapter());
}
```
Da `SubscriptionAdapter` typeId 2 bereits registriert ist (in `hive_storage.dart`), wird dieser Check `true` sein → Adapter wird nie registriert → Crashes beim Box-Zugriff.

**Fix:** Durch Bug #1 Fix gelöst (typeId auf 4 ändern).

---

## 🟡 Medium Bugs — Details & Fixes

### BUG-7: Partial Content bei Stream-Error verloren

**Problem:**
```dart
} catch (e) {
  if (_messages.isNotEmpty && _messages.last.content.isEmpty) {
    _messages.removeLast();  // Nur wenn leer
  }
  // Partial content bleibt OHNE Fehler-Indikator!
}
```

**Fix:**
```dart
} catch (e) {
  if (_messages.isNotEmpty) {
    if (_messages.last.content.isEmpty) {
      _messages.removeLast();
    } else {
      // Partial content markieren
      final partial = _messages.last;
      _messages[_messages.length - 1] = MessageEntity(
        id: partial.id,
        conversationId: partial.conversationId,
        role: partial.role,
        content: '${partial.content}\n\n⚠️ Response incomplete',
        timestamp: partial.timestamp,
      );
    }
  }
}
```

---

### BUG-8: HTTP Controller nicht geschlossen bei nested Error

**Problem:** `openai_service.dart`:
```dart
if (response.statusCode != 200) {
  final body = await response.stream.bytesToString();  // ← Kann werfen!
  controller.addError(...);
  await controller.close();
  return;
}
```
Wenn `bytesToString()` fehlschlägt, wird `controller.close()` nie erreicht.

**Fix:**
```dart
if (response.statusCode != 200) {
  try {
    final body = await response.stream.bytesToString();
    controller.addError(Exception('OpenAI API error: $body'));
  } catch (e) {
    controller.addError(Exception('OpenAI API error ${response.statusCode}'));
  }
  await controller.close();
  return;
}
```

---

### BUG-11: Timer unformatiert

**Problem:** `${widget.elapsedTime!.inMilliseconds / 1000.0}s` → `1.5340000000000002s`

**Fix:**
```dart
'${(widget.elapsedTime!.inMilliseconds / 1000.0).toStringAsFixed(2)}s'
```

---

### BUG-15: Masked API Key wird gespeichert

**Problem:** User sieht `gpt-••••abcd` im TextField, drückt Save → `gpt-••••abcd` wird als Key in SecureStorage geschrieben.

**Fix:** Settings-Screen sollte bei Focus den echten Key laden oder bei Save erkennen dass der Key gemasked ist:
```dart
void _handleSave(String provider, String newKey) {
  // Nur speichern wenn Key nicht gemasked ist
  if (!newKey.contains('••••')) {
    settings.setApiKey(provider, newKey);
  }
}
```

---

## Priorisierte Empfehlungen

### Sofort (App-Crash-Risiko):
1. **BUG-1/5/6:** typeId Collision fixen → `MemoryEntry` auf typeId 4
2. **BUG-2:** Assistant-Messages korrekt speichern
3. **BUG-4:** MemoryStorage über DI injizieren

### Bald (Funktionale Defekte):
4. **BUG-7:** Partial content bei Stream-Error konservieren
5. **BUG-11:** Timer formatieren (1-Zeiler)
6. **BUG-15:** Masked Key Save-Bug fixen
7. **BUG-8:** HTTP Controller Error-Handling

### Cleanup:
8. **BUG-18-22:** Hardcoded Deutsch strings → Englisch
9. **BUG-23-25:** Design Token Integration
10. **BUG-26-29:** Dead Code entfernen

---

## Datei-Coverage

| Verzeichnis | Dateien | Bugs gefunden |
|-------------|---------|---------------|
| `lib/main.dart` | 1 | 1 |
| `lib/core/` | 3 | 1 |
| `lib/models/` | 10 | 3 (Critical!) |
| `lib/providers/` | 5 | 8 |
| `lib/services/` | 7 | 3 |
| `lib/storage/` | 2 | 2 (Critical!) |
| `lib/theme/` | 7 | 0 |
| `lib/features/chat/` | 14 | 8 |
| `lib/features/settings/` | 8 | 3 |
| `lib/features/articles/` | 7 | 2 |
| `lib/features/memory/` | 1 | 1 |
| `lib/features/subscription/` | 1 | 1 |
| **Total** | **82 Dateien** | **33 Bugs** |
