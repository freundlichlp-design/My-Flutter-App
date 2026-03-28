# Bug Report — Kali Chat App (Tag 2)

**Generated:** 2026-03-28 by Bug Agent (Tag 2)  
**Scope:** All `.dart` files in `lib/` (24 files analyzed)  
**Previous Report:** Tag 1 (2026-03-27)

---

## Tag 1 → Tag 2: Changelog

### ✅ Fixed from Tag 1
| Bug | Status | Commit |
|-----|--------|--------|
| BUG-002: Double Hive Init | ✅ Fixed | `storage_service.dart` deleted, singleton pattern in `HiveStorage` |
| BUG-003: Null Safety in ChatProvider | ✅ Fixed | Added `if (_activeConversation == null) return;` guard |
| BUG-004: notifyListeners before Widget Tree | ✅ Fixed | `loadSettings(notify: false)` in `main.dart` |
| BUG-006: Model Validation on Provider Switch | ✅ Fixed | `if (!models.contains(_selectedModel))` check added |
| BUG-007: Duplicate HiveStorage | ✅ Fixed | Singleton via `_instance` / `_internal` |
| BUG-008: Inconsistent Date Format | ✅ Fixed | `padLeft(2, '0')` added |
| BUG-012: Untyped Key in getConversation | ✅ Fixed | Was removed (no type cast needed with typed box) |
| BUG-013: Empty API Key Validation | ✅ Fixed | `isConfigured` check before sendMessage |
| C2 (Security): No Input Validation | ✅ Fixed | `_maxMessageLength` + `isConfigured` check |

### ❌ Still Open from Tag 1
| Bug | Reason |
|-----|--------|
| BUG-001: Unregistered Routes | Still not in `MaterialApp.routes` |
| BUG-005: HTTP Client Resource Leak | No `dispose()` in any service |
| BUG-009: Gemini Stream Parser | Same naive cleanup logic |
| BUG-010: notifyListeners per Chunk | Still fires on every streaming chunk |
| BUG-011: Scroll-to-Bottom per Build | Still in `build()` |

---

## Summary (Tag 2)

| Severity | Count |
|----------|-------|
| Critical | 1     |
| High     | 3     |
| Medium   | 4     |
| Low      | 3     |

---

## 🔴 Critical

### BUG-014: `DropdownButtonFormField.initialValue` — Deprecated/Removed in Flutter 3.24+

**Severity:** Critical  
**File:** `lib/screens/settings_screen.dart` — lines 82, 97  
**New in Tag 2** (Personality System)

Both `DropdownButtonFormField` widgets use the `initialValue` parameter:

```dart
// Line 82 — Model selector
DropdownButtonFormField<String>(
  initialValue: settings.selectedModel,
  ...

// Line 97 — Personality selector
DropdownButtonFormField<String>(
  initialValue: settings.selectedPersonalityId,
  ...
```

`initialValue` was **removed** in Flutter 3.24. The correct parameter is `value`. On current and future Flutter versions, this will throw:

```
The named parameter 'initialValue' isn't defined.
```

**Fix:** Replace both occurrences with `value`:

```dart
DropdownButtonFormField<String>(
  value: settings.selectedModel,
  ...
```

---

## 🟠 High

### BUG-001: Unregistered Routes — ArticleDetailPage & HomePage

**Severity:** High  
**File:** `lib/main.dart` — line 48  
**Persisting from Tag 1**

`ArticleDetailPage.routeName` (`'/article-detail'`) is defined but **never registered** in `MaterialApp.routes`. `HomePage` has no route at all. `HomePage` calls `Navigator.pushNamed(context, ArticleDetailPage.routeName)` which will crash.

Note: This only crashes if `HomePage` is ever navigated to. Currently it's not in the route table, so it's dead code — but `ArticleDetailPage.routeName` is referenced from `HomePage` and will crash if that page is ever used.

**Fix:** Either register the routes or remove the dead article code:

```dart
// Option A: Register
ArticleDetailPage.routeName: (_) => const ArticleDetailPage(),

// Option B: Remove home_page.dart, article_detail_page.dart,
// article_provider.dart, article_service.dart, article.dart
```

---

### BUG-005: HTTP Client Resource Leak — No `dispose()` in Any Service

**Severity:** High  
**Files:** `lib/services/article_service.dart`, `claude_service.dart`, `gemini_service.dart`, `openai_service.dart`  
**Persisting from Tag 1**

All four services create `http.Client()` but never close it. The `ChatProvider._createApiService()` creates a **new service instance on every message**, each with a new `http.Client`. Over time this leaks connections.

**Fix:** Add `dispose()` to each service:

```dart
void dispose() => _client.close();
```

And call it after stream completes in `ChatProvider`:

```dart
try {
  await for (final chunk in apiService.sendMessage(...)) { ... }
} finally {
  apiService.dispose(); // or use a shared client
}
```

Better: Use a single shared `http.Client` per provider, not per-message.

---

### BUG-015: Duplicate `KaliColors` Class Definition

**Severity:** High  
**Files:** `lib/widgets/chat_bubble.dart`, `lib/widgets/message_input.dart`, `lib/widgets/streaming_indicator.dart`  
**New in Tag 2**

`KaliColors` is defined **three separate times** with different subsets of constants:

- `chat_bubble.dart`: 15 constants (full palette)
- `message_input.dart`: 4 constants (partial)
- `streaming_indicator.dart`: 5 constants (partial)

These are **independent classes** — changing one doesn't affect the others. Any color update must be done in 3 places. If a developer imports from the wrong file, they'll get a different class with fewer constants.

**Fix:** Create `lib/widgets/kali_colors.dart` with the full definition. Import it everywhere. Delete the duplicates.

---

## 🟡 Medium

### BUG-016: ChatBubble `model` and `tokenCount` Never Passed

**Severity:** Medium  
**File:** `lib/widgets/chat_bubble.dart` (constructor) vs `lib/screens/chat_screen.dart` (usage, line 78)  
**New in Tag 2**

`ChatBubble` accepts optional `model` and `tokenCount` parameters for AI message metadata:

```dart
class ChatBubble extends StatelessWidget {
  final Message message;
  final String? model;
  final int? tokenCount;
  ...
}
```

But `ChatScreen` never passes them:

```dart
ChatBubble(message: messages[index]) // no model, no tokenCount
```

The metadata section at the bottom of AI bubbles is **always hidden**. This was clearly designed but never wired up.

**Fix:** Either:
- Store `model` on `Conversation` and pass it to `ChatBubble`
- Track token counts and pass them
- Or remove the dead metadata rendering code

---

### BUG-017: Conversation Missing `personalityId` — Personality is Global, Not Per-Conversation

**Severity:** Medium  
**Files:** `lib/models/conversation.dart`, `lib/providers/chat_provider.dart`  
**New in Tag 2**

The `Conversation` model has no `personalityId` field. Personality is stored globally in `SettingsProvider._selectedPersonalityId`. This means:

1. Switching personality mid-conversation changes system prompt on next message
2. User can't have different personalities per conversation
3. App restart loads global personality, not per-conversation personality
4. The system prompt sent to the AI is always `settings.selectedPersonality.systemPrompt`

This is a **design issue** more than a crash bug, but it will confuse users who expect conversations to keep their personality.

**Fix:** Add `personalityId` field to `Conversation`:

```dart
@HiveField(6)
String personalityId;
```

Use it in `ChatProvider.sendMessage()`:

```dart
final personality = KaliPersonality.getById(conversation.personalityId);
// ... systemPrompt: personality.systemPrompt
```

**⚠️ Note:** Adding a new HiveField requires bumping the Hive type version and writing a migration, or the app will crash on existing data.

---

### BUG-018: Gemini System Prompt Handling — `system_instruction` May Not Work with Stream

**Severity:** Medium  
**File:** `lib/services/gemini_service.dart` — lines 57-63  
**Persisting from Tag 1 (re-evaluated)**

The Gemini service uses `system_instruction` in the request body:

```dart
if (systemPrompt != null) {
  body['system_instruction'] = {
    'parts': [{'text': systemPrompt}]
  };
}
```

The Gemini `streamGenerateContent` endpoint has inconsistent support for `system_instruction` compared to `generateContent`. Some models ignore it in streaming mode. This means personality system prompts may be silently dropped when using Gemini.

**Fix:** Prepend the system prompt as the first user message for Gemini:

```dart
if (systemPrompt != null) {
  contents.insert(0, {
    'role': 'user',
    'parts': [{'text': 'System instruction: $systemPrompt'}]
  });
}
```

Or use `generateContent` instead of `streamGenerateContent` for personality support.

---

### BUG-019: `StreamingIndicator` Receives No Actual Data

**Severity:** Medium  
**File:** `lib/widgets/streaming_indicator.dart` vs `lib/screens/chat_screen.dart` (line 80)  
**New in Tag 2**

`StreamingIndicator` accepts optional `tokenCount` and `elapsedTime`:

```dart
const StreamingIndicator()  // chat_screen.dart line 80 — no params
```

The stream status bar shows "Streaming" text but never displays token count or elapsed time. The `ChatProvider` doesn't track either metric.

**Fix:** Either:
- Track tokens/elapsed in `ChatProvider` and pass them to `StreamingIndicator`
- Or remove the unused parameters and status bar section

---

## 🟢 Low

### BUG-020: `KaliPersonality.getById` — Silent Fallback on Invalid ID

**Severity:** Low  
**File:** `lib/models/kali_personality.dart` — line 93  
**New in Tag 2**

```dart
static KaliPersonality getById(String id) {
  return all.firstWhere(
    (p) => p.id == id,
    orElse: () => defaultPersonality,
  );
}
```

If `_selectedPersonalityId` in SharedPreferences contains an invalid ID (e.g., after removing a personality from code, or data corruption), the app silently falls back to `defaultPersonality`. No warning, no log. The user sees "Kali — Default" in settings but doesn't know why.

**Fix:** Log the fallback:

```dart
orElse: () {
  debugPrint('Warning: Personality "$id" not found, using default');
  return defaultPersonality;
},
```

---

### BUG-021: `ArticleProvider` Created But Never Used in Widget Tree

**Severity:** Low  
**Files:** `lib/main.dart`, `lib/providers/article_provider.dart`  
**Persisting from Tag 1**

`ArticleProvider` is never registered in `MultiProvider` in `main.dart`. The `HomePage` and `ArticleDetailPage` call `context.read<ArticleProvider>()` which will throw:

```
ProviderNotFoundException: Could not find the correct Provider<ArticleProvider>
```

These pages are unreachable from the current route table, but if someone adds them to routes, it crashes immediately.

**Fix:** Either add `ArticleProvider` to `MultiProvider` or remove the article system entirely.

---

### BUG-022: Personality System Prompt Sent in Full on Every Message

**Severity:** Low  
**File:** `lib/providers/chat_provider.dart` — line 128  
**New in Tag 2**

The full personality system prompt (up to ~300 words for "chaos" mode) is sent as the `system` parameter on **every single API call**. Combined with the full conversation history, this wastes tokens on every request. For Claude, the system prompt is billed separately but still counts toward context limits.

For a 50-message conversation, the same system prompt is sent 25 times.

**Fix:** Cache the system prompt string and only resend if personality changes. Or use conversation-level system prompt injection (Claude supports this via `conversation` parameter in newer API versions).

---

## Recommendations

### Immediate (Before Day 3)
1. **BUG-014:** Fix `initialValue` → `value` — will crash on current Flutter
2. **BUG-015:** Extract `KaliColors` to shared file — prevents future color drift
3. **BUG-017:** Add `personalityId` to `Conversation` — needs Hive migration

### Soon
4. **BUG-001/021:** Remove dead article code or properly integrate it
5. **BUG-005:** Add `dispose()` to services or use shared client
6. **BUG-016:** Wire up ChatBubble metadata or remove dead code

### Cleanup
7. **BUG-019:** Wire up StreamingIndicator or simplify
8. **BUG-020:** Add debug logging for personality fallback
9. **BUG-022:** Optimize system prompt usage
