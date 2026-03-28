# Bug Agent – Tag 4 (2026-03-28)

## Geprüfte Dateien

1. `lib/main.dart`
2. `lib/screens/chat_screen.dart`
3. `lib/providers/chat_provider.dart`
4. `lib/services/openai_service.dart`
5. `lib/widgets/message_input.dart`

---

## Bugs

### BUG-01: `_scrollToBottom` ruft `animateTo` nach dispose auf (chat_screen.dart:19-28)

`Future.delayed` greift auf `_scrollController` zu, aber nach `dispose()` kann der Controller bereits freigegeben sein → **Flutter Error: "ScrollController disposed during animation"**.

```dart
// FIX: mounted-Check hinzufügen
Future.delayed(const Duration(milliseconds: 100), () {
  if (!mounted || !_scrollController.hasClients) return;
  _scrollController.animateTo(...)
});
```

**Severity:** 🟡 Medium

---

### BUG-02: `sendMessage`-Fehler löscht letzte Nachricht unabhängig vom Absender (chat_provider.dart:126-128)

Bei Exception wird `_messages.removeLast()` aufgerufen, aber die letzte Nachricht könnte eine valide **User-Message** sein (z.B. wenn der Stream sofort fehlschlägt). Sollte nur `assistant`-Nachrichten mit leerem Content entfernen.

```dart
// FIX: explizit prüfen
if (_messages.isNotEmpty &&
    _messages.last.role == 'assistant' &&
    _messages.last.content.isEmpty) {
  _messages.removeLast();
}
```

**Severity:** 🟠 Medium-High

---

### BUG-03: Kein `notifyListeners()` nach Error-Reset in `clearError` (chat_provider.dart:132-135)

`clearError()` setzt `_errorMessage` und `_state` → das ist korrekt. Aber wenn ein nächster `sendMessage`-Aufruf **vorher** den State nicht zurücksetzt (z.B. nach erneutem Fehler ohne Reset), bleibt UI inkonsistent. Hier ist es korrekt — aber `notifyListeners()` fehlt wenn `clearError` von UI ohne nachfolgenden rebuild aufgerufen wird.

**Severity:** 🟢 Low (notifyListeners ist vorhanden — kein Bug)

---

### BUG-04: API-Key wird im Klartext in HTTP-Header gesendet – kein Timeout/Retry (openai_service.dart:43-45)

`http.Client.send()` hat keinen Timeout. Bei hängenden Verbindungen bleibt der Stream für immer offen → UI zeigt "Streaming" unbegrenzt.

```dart
// FIX: Timeout hinzufügen
final response = await _client.send(request).timeout(
  const Duration(seconds: 60),
);
```

**Severity:** 🟠 Medium

---

### BUG-05: `Conversation.title` wird beim 2. User-Message nicht mehr aktualisiert (chat_provider.dart:91-95)

Der Titel wird nur gesetzt wenn `_messages.length == 1`. Danach bleibt immer "New Chat" oder der erste Ausschnitt. Kein Bug im klassischen Sinne, aber UX-Problem: Nutzer sieht keinen hilfreichen Titel.

**Severity:** 🟢 Low (Feature-Request, kein Crash-Bug)

---

### BUG-06: `_controller.clear()` löscht Text bevor `onSubmitted` verarbeitet wird (message_input.dart:52-55)

Wenn `TextInputAction.send` + `onSubmitted` feuert UND gleichzeitig `_handleSend()` aufgerufen wird, wird der Text möglicherweise doppelt gesendet oder nach `clear()` ist `text` leer. In der Praxis: `onSubmitted` → `_handleSend` → `clear()` — das ist korrekt. Aber bei Duplikat-Events (Soft-Keyboard) kann es Race-Conditions geben.

**Severity:** 🟢 Low

---

### BUG-07: `HiveStorage` Singleton aber in `main()` wird `await HiveStorage.init()` aufgerufen (main.dart:9)

`init()` ist `static` und wird **vor** `HiveStorage()`-Konstruktor aufgerufen. Das ist korrekt. Aber wenn `ChatProvider` eine **neue** `HiveStorage()`-Instanz erstellt, nutzt es den Singleton — kein Bug, aber Architektur-Smell: `_storage` wird injected aber ist immer derselbe Singleton.

**Severity:** 🟢 Low (Design-Feedback)

---

## Zusammenfassung

| Bug | Severity | Datei |
|-----|----------|-------|
| BUG-01 | 🟡 Medium | chat_screen.dart |
| BUG-02 | 🟠 Medium-High | chat_provider.dart |
| BUG-04 | 🟠 Medium | openai_service.dart |
| BUG-05 | 🟢 Low | chat_provider.dart |
| BUG-06 | 🟢 Low | message_input.dart |
| BUG-07 | 🟢 Low | main.dart |

**Empfohlene Priorität:** BUG-02 → BUG-04 → BUG-01

---
*Bug Agent Tag 4 – 2026-03-28*
