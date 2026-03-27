# Bug Report — Kali Chat App

**Generated:** 2026-03-27 by Bug Agent  
**Scope:** All `.dart` files in `lib/` (24 files analyzed)

---

## Summary

| Severity | Count |
|----------|-------|
| Critical | 2     |
| High     | 3     |
| Medium   | 5     |
| Low      | 3     |

---

## 🔴 Critical

### BUG-001: Unregistered Routes Crash App

**Severity:** Critical  
**File:** `lib/main.dart` — line 48  
**Affected:** `lib/screens/home_page.dart` (no route), `lib/screens/article_detail_page.dart` line 6

`ArticleDetailPage.routeName` (`'/article-detail'`) is defined but **never registered** in the `MaterialApp.routes` map. Same for `HomePage` which has no route at all. Calling `Navigator.pushNamed(context, ArticleDetailPage.routeName)` will throw:

```
Could not navigate to route "/article-detail". No route registered.
```

**Fix:** Add routes to `main.dart`:

```dart
routes: {
  ConversationsScreen.routeName: (_) => const ConversationsScreen(),
  ChatScreen.routeName: (_) => const ChatScreen(),
  SettingsScreen.routeName: (_) => const SettingsScreen(),
  ArticleDetailPage.routeName: (_) => const ArticleDetailPage(),
},
```

Or use `onGenerateRoute` for argument-based routes.

---

### BUG-002: Double Hive Initialization Conflicts

**Severity:** Critical  
**File:** `lib/storage/storage_service.dart` — line 16, `lib/storage/hive_storage.dart` — line 10  
**File:** `lib/main.dart` — line 7

`HiveStorage.init()` calls `Hive.initFlutter()` and registers adapters. `StorageService` does the same independently. If both run (e.g. during refactoring), Hive will throw:

```
HiveError: TypeAdapter already registered (typeId: 0)
```

Additionally, `StorageService` (112 lines) is **entirely unused** — only `HiveStorage` is referenced. This is dead code that creates maintenance confusion.

**Fix:** Delete `storage_service.dart` entirely, or merge into one class. Add guard in `HiveStorage.init()`:

```dart
if (!Hive.isAdapterRegistered(0)) {
  Hive.registerAdapter(ConversationAdapter());
}
```

---

## 🟠 High

### BUG-003: Null Safety Risk — Non-null Assertion on Potentially Null Field

**Severity:** High  
**File:** `lib/providers/chat_provider.dart` — line 95

```dart
if (_activeConversation == null) {
  await createNewConversation();
}
// ...
conversationId: _activeConversation!.id,  // line 95 — forced unwrap
```

If `createNewConversation()` fails (storage error, async race), `_activeConversation` remains `null` and the `!` operator throws a `Null check operator used on a null value` exception — crashing the app.

**Fix:** Use null-safe access after null-check:

```dart
final conversation = _activeConversation;
if (conversation == null) {
  await createNewConversation();
  if (_activeConversation == null) return; // safety guard
}
```

---

### BUG-004: `loadSettings()` Called Before Widget Tree — NotifyListeners Warning

**Severity:** High  
**File:** `lib/main.dart` — line 11, `lib/providers/settings_provider.dart` — line 42

```dart
final settingsProvider = SettingsProvider();
await settingsProvider.loadSettings(); // calls notifyListeners()
```

`loadSettings()` calls `notifyListeners()` before the `MultiProvider` is mounted. In debug mode this produces:

```
Tried to listen to a value exposed with provider, from outside of the widget tree.
```

This is undefined behavior and may cause the first Consumer to miss the loaded state.

**Fix:** Either remove `notifyListeners()` from `loadSettings()` and set fields directly, or move loading into the widget tree:

```dart
// Option A: silent load
Future<void> loadSettings({bool notify = true}) async {
  // ... set fields ...
  if (notify) notifyListeners();
}
```

---

### BUG-005: HTTP Client Resource Leak — No `close()` on ArticleService

**Severity:** High  
**File:** `lib/services/article_service.dart` — line 10

```dart
final http.Client _client;
ArticleService({http.Client? client}) : _client = client ?? http.Client();
```

The `http.Client` is created but **never closed**. Over time, this leaks HTTP connections, especially on Android/iOS where connection pools are limited. Same issue in `ClaudeService` (line 13), `GeminiService` (line 11), and `OpenAiService` (line 13).

**Fix:** Add `dispose()` method and call it when services are no longer needed:

```dart
void dispose() => _client.close();
```

---

## 🟡 Medium

### BUG-006: Switching Provider Doesn't Validate Model Exists

**Severity:** Medium  
**File:** `lib/providers/settings_provider.dart` — line 72

```dart
Future<void> setSelectedProvider(String provider) async {
  _selectedProvider = provider;
  final models = providerModels[provider] ?? ['gpt-4o'];
  _selectedModel = models.first;
```

Switching from OpenAI (model: `gpt-4o`) to Claude sets model to `claude-sonnet-4-20250514` — correct. But if a user previously selected a non-first model (e.g. `gpt-3.5-turbo`) and switches providers, the previous model name is silently replaced without any UI feedback.

**Fix:** This is mostly OK, but add explicit validation that `_selectedModel` is in `availableModels` after any change:

```dart
if (!availableModels.contains(_selectedModel)) {
  _selectedModel = availableModels.first;
}
```

---

### BUG-007: Duplicate `HiveStorage` Instantiation

**Severity:** Medium  
**File:** `lib/main.dart` — line 13

```dart
await HiveStorage.init();  // static call (line 8)
final storage = HiveStorage();  // new instance (line 13)
```

`HiveStorage.init()` is a static method that opens Hive boxes. Then a `new HiveStorage()` is created to access those boxes via getter properties. This works but is confusing — the static `init()` and instance accessors on the same class is a code smell. The constructor does nothing beyond what the static getters already provide.

**Fix:** Make `HiveStorage` a proper singleton or use only static methods:

```dart
class HiveStorage {
  static Box<Conversation> get _conversationBox => Hive.box<Conversation>(conversationsBox);
  // ... all static methods ...
}
```

---

### BUG-008: `_formatDate` Shows Inconsistent Format for Single-Digit Days

**Severity:** Medium  
**File:** `lib/screens/conversations_screen.dart` — line 134

```dart
return '${date.day}/${date.month}';
```

This returns `3/5` for March 5th and `12/25` for December 25th. Inconsistent visual alignment.

**Fix:**

```dart
return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
```

---

### BUG-009: Gemini Stream Parser Breaks on Complex JSON

**Severity:** Medium  
**File:** `lib/services/gemini_service.dart` — lines 93-99

```dart
String cleaned = line.trim();
if (cleaned.endsWith(',')) cleaned = cleaned.substring(0, cleaned.length - 1);
if (cleaned.startsWith('[')) cleaned = cleaned.substring(1);
if (cleaned.endsWith(']')) cleaned = cleaned.substring(0, cleaned.length - 1);
```

This naive cleanup tries to handle the Gemini `streamGenerateContent` JSON array response line by line. But Gemini can return multi-line JSON objects or nested arrays. The current logic will:
- Strip brackets from legitimate JSON values containing `[` or `]`
- Fail on nested commas inside text content
- Silently swallow parse errors (catch block on line 108 does nothing)

**Fix:** Use a proper JSON streaming decoder or buffer lines until a complete JSON object is accumulated:

```dart
final buffer = StringBuffer();
// Accumulate lines, try JSON decode when balanced braces found
```

---

### BUG-010: Chat Screen Rebuilds Entire List on Every Character

**Severity:** Medium  
**File:** `lib/providers/chat_provider.dart` — line 125, `lib/screens/chat_screen.dart` — line 53

```dart
// In provider: notifyListeners() on every streaming chunk
await for (final chunk in apiService.sendMessage(...)) {
  _streamingContent += chunk;
  assistantMessage.content = _streamingContent;
  notifyListeners(); // triggers full rebuild
}
```

During streaming, `notifyListeners()` fires on every chunk (potentially 50-100+ times/second). The entire `ListView.builder` rebuilds each time. On older devices this causes jank.

**Fix:** Use a separate `ValueNotifier<String>` for streaming content, or implement a `ProxyProvider` / `select()` to avoid full tree rebuilds:

```dart
final _streamingNotifier = ValueNotifier<String>('');
// Update _streamingNotifier.value on each chunk without full rebuild
```

---

## 🟢 Low

### BUG-011: Scroll-to-Bottom Fires on Every Build

**Severity:** Low  
**File:** `lib/screens/chat_screen.dart` — line 53

```dart
WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
```

This is called inside `build()` of the `Consumer`, meaning it fires on **every provider notification** (including streaming chunks). Combined with the `Future.delayed(100ms)` in `_scrollToBottom`, this creates competing animations.

**Fix:** Move scroll logic to only trigger when message count changes:

```dart
int _prevMessageCount = 0;
// In build: only scroll if count changed
if (messages.length != _prevMessageCount) {
  _prevMessageCount = messages.length;
  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
}
```

---

### BUG-012: `HiveStorage.getConversation` — Untyped Key

**Severity:** Low  
**File:** `lib/storage/hive_storage.dart` — line 32

```dart
Conversation? getConversation(String id) {
  return _conversationBox.get(id); // Hive.get() returns dynamic
}
```

`Hive.box.get(key)` returns `dynamic`. If the key doesn't match an existing entry's key exactly (e.g. type mismatch), it returns `null` silently. No type safety guarantee.

**Fix:** Use typed access:

```dart
Conversation? getConversation(String id) {
  return _conversationBox.get(id) as Conversation?;
}
```

---

### BUG-013: No Input Validation on Empty API Key

**Severity:** Low  
**File:** `lib/providers/settings_provider.dart` — line 49

```dart
String get currentApiKey {
  switch (_selectedProvider) {
    case 'claude': return _claudeApiKey;
    case 'gemini': return _geminiApiKey;
    default: return _openaiApiKey;
  }
}
```

If the user sends a message without configuring an API key, `currentApiKey` returns `''`. The API service then makes a request with an empty `Authorization` header, resulting in a confusing `401` or `403` error.

**Fix:** Add validation in `ChatProvider.sendMessage()`:

```dart
if (!_settingsProvider.isConfigured) {
  _errorMessage = 'Please configure an API key in Settings';
  _state = ChatState.error;
  notifyListeners();
  return;
}
```

---

## Recommendations

1. **Immediate:** Fix BUG-001 (route crash) and BUG-002 (Hive conflict) — these crash the app.
2. **Soon:** Fix BUG-003 (null safety) and BUG-004 (notifyListeners timing).
3. **Cleanup:** Delete `storage_service.dart` (dead code), consolidate `HiveStorage` patterns.
4. **Performance:** Consider debouncing `notifyListeners()` during streaming (BUG-010).
