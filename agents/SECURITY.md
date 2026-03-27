# 🔒 Security Audit Report — Kali Chat App

**Agent:** Security Agent  
**Date:** 2026-03-27  
**Scope:** All `.dart` files in `lib/`  
**Files Scanned:** 25

---

## Executive Summary

The app has **3 CRITICAL**, **2 HIGH**, and **2 MEDIUM** security findings. The most severe issue is **plaintext storage of API keys** via SharedPreferences, which exposes credentials on any rooted/jailbroken device or via backup extraction.

| Severity | Count |
|----------|-------|
| 🔴 CRITICAL | 3 |
| 🟠 HIGH | 2 |
| 🟡 MEDIUM | 2 |
| ✅ PASS | 3 |

---

## 🔴 CRITICAL Findings

### C1: API Keys Stored in Plaintext (SharedPreferences)

**File:** `lib/providers/settings_provider.dart`  
**Lines:** All `set*ApiKey` methods  
**Risk:** API keys (OpenAI, Claude, Gemini) are saved as plaintext strings in SharedPreferences, which stores data as readable XML on the device filesystem.

```dart
// INSECURE — plaintext storage
final prefs = await SharedPreferences.getInstance();
await prefs.setString(_openaiKeyPref, key);
```

**Impact:** On rooted Android devices, any app with root access can read `/data/data/<package>/shared_prefs/*.xml`. iOS backups are also unencrypted by default.

**Recommendation:**
- Use `flutter_secure_storage` package (Keychain on iOS, EncryptedSharedPreferences on Android)
- Add `flutter_secure_storage: ^9.2.2` to pubspec.yaml
- Replace all SharedPreferences key storage with `FlutterSecureStorage().write/read/delete`

---

### C2: No Input Validation on User Messages

**File:** `lib/providers/chat_provider.dart`  
**Lines:** `sendMessage()` method  
**Risk:** Only validates `content.trim().isEmpty`. No length limits, no sanitization.

```dart
// MINIMAL validation — needs more
if (content.trim().isEmpty) return;
```

**Impact:**
- Unlimited message length could cause OOM or API cost abuse
- No protection against prompt injection (malicious system prompts)
- No rate limiting on API calls

**Recommendation:**
- Add max message length (e.g., 10,000 chars)
- Implement rate limiting (max requests per minute)
- Consider input sanitization for special characters

---

### C3: API Keys Exposed via Public Getters

**File:** `lib/providers/settings_provider.dart`  
**Lines:** 19-21, 27-35  
**Risk:** API keys are accessible via public getters, making them available to any widget or service in the app tree.

```dart
String get openaiApiKey => _openaiApiKey;  // Should be private or encrypted
String get currentApiKey { ... }  // Exposes active provider's key
```

**Impact:** Any code path can extract the API key. Combined with C1, this is a data exfiltration risk.

**Recommendation:**
- Remove public getters for raw API keys
- Provide a method that creates the API service internally without exposing the key
- Only pass keys to service constructors internally

---

## 🟠 HIGH Findings

### H1: Silent Exception Swallowing in Stream Handlers

**Files:** `lib/services/openai_service.dart`, `lib/services/gemini_service.dart`, `lib/services/claude_service.dart`  
**Risk:** All streaming response handlers use empty `catch (_) {}` blocks, silently discarding JSON parse errors.

```dart
// In all three service files
try { ... } catch (_) {}  // Silent swallow
```

**Impact:** Malformed API responses are silently ignored. Users get incomplete responses with no error indication. Difficult to debug production issues.

**Recommendation:**
- Log parse errors via a logging framework
- At minimum: `catch (e) { debugPrint('Stream parse error: $e'); }`
- Consider adding a partial-response warning to the UI

---

### H2: No Certificate Pinning

**Files:** All service files  
**Risk:** HTTP requests use default `http.Client()` with no certificate pinning. Vulnerable to MITM attacks on compromised networks.

**Impact:** An attacker with a rogue CA cert could intercept API keys in transit.

**Recommendation:**
- Implement certificate pinning using `http_certificate_pinning` or `dio` with custom `HttpClient`
- Pin against known API endpoint certificates (OpenAI, Anthropic, Google)
- At minimum, add a security note in documentation

---

## 🟡 MEDIUM Findings

### M1: Chat Messages Stored Unencrypted in Hive

**Files:** `lib/storage/hive_storage.dart`, `lib/storage/storage_service.dart`  
**Risk:** Chat messages (including potentially sensitive user input and AI responses) are stored in unencrypted Hive boxes.

**Impact:** Data at rest is readable if device storage is compromised.

**Recommendation:**
- Enable Hive encryption: `Hive.openBox(name, encryptionCipher: HiveAesCipher(key))`
- Generate and store the encryption key in `flutter_secure_storage`

---

### M2: No HTTP Client Timeout Configuration

**Files:** All service files  
**Risk:** HTTP clients are created without timeout configuration. Long-running requests could hang indefinitely.

```dart
final http.Client _client = client ?? http.Client();  // No timeout
```

**Impact:** App could hang during poor network conditions, leading to poor UX and potential resource exhaustion.

**Recommendation:**
```dart
final client = http.Client();
// Or wrap with timeout:
request.send().timeout(const Duration(seconds: 30));
```

---

## ✅ Passed Checks

| Check | Status | Notes |
|-------|--------|-------|
| No hardcoded API keys in source | ✅ | Keys are injected via constructor params |
| HTTPS used for all API endpoints | ✅ | All URLs use `https://` |
| Error handling for API calls | ✅ | Status codes checked, errors propagated |

---

## Recommended Dependencies to Add

```yaml
# pubspec.yaml
dependencies:
  flutter_secure_storage: ^9.2.2   # Replace SharedPreferences for keys
  http_certificate_pinning: ^3.0.1  # Certificate pinning
```

---

## Priority Fix Order

1. **C1** — Migrate to `flutter_secure_storage` (blocks production use)
2. **C3** — Hide API key getters (quick fix, high impact)
3. **C2** — Add input validation + rate limiting
4. **H1** — Fix silent exception handling
5. **M1** — Enable Hive encryption
6. **H2** — Add certificate pinning
7. **M2** — Configure HTTP timeouts

---

*Generated by Security Agent — Kali Chat App Audit*
