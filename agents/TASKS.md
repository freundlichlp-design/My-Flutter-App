# TASKS.md - Kali Chat App

## Heute (27.03)

### 💻 Code Tasks
- [ ] 💻 Code: Flutter-Projekt erstellen (`flutter create kali_chat`)
- [ ] 💻 Code: API-Service-Schicht für OpenAI Streaming (SSE via `http` package)
- [ ] 💻 Code: Chat-Model-Klasse (Message, Conversation, Role)
- [ ] 💻 Code: Provider/State Management für Chat-State einrichten
- [ ] 💻 Code: Local Storage mit `hive` für Chat-History
- [ ] 💻 Code: Multi-API Support (OpenAI, Claude, Gemini) als Adapter-Pattern

### 🎨 Design Tasks
- [ ] 🎨 Design: Chat-Bubble UI (User vs AI Messages)
- [ ] 🎨 Design: Streaming-Indikator (typing animation)
- [ ] 🎨 Design: Conversation List Screen
- [ ] 🎨 Design: Settings Screen (API Key, Model Auswahl)

### 📋 Pakete (pubspec.yaml)
| Paket | Version | Zweck |
|-------|---------|-------|
| `provider` | ^6.1.1 | State Management |
| `http` | ^1.2.0 | HTTP Requests + SSE Streaming |
| `hive` | ^2.2.3 | Lokale Datenbank |
| `hive_flutter` | ^1.1.0 | Flutter Integration für Hive |
| `uuid` | ^4.2.1 | Unique IDs für Messages |
| `flutter_markdown` | ^0.6.18 | Markdown Rendering (AI Responses) |
| `url_launcher` | ^6.2.3 | Links in Messages öffnen |
| `shared_preferences` | ^2.2.2 | Settings speichern |
| `web_socket_channel` | ^2.4.0 | WebSocket Support (optional) |

---

## API Research Ergebnisse

### 1. OpenAI API (ChatGPT)
- **Endpoint:** `https://api.openai.com/v1/chat/completions`
- **Streaming:** `stream: true` → Server-Sent Events (SSE)
- **Modelle:** `gpt-4o`, `gpt-4o-mini`, `gpt-3.5-turbo`
- **Auth:** Bearer Token im Header
- **Format:** JSON mit `messages` Array (role: system/user/assistant)
- **SSE Format:** Jede Zeile `data: {...}`, letzte Zeile `data: [DONE]`

### 2. Claude API (Anthropic)
- **Endpoint:** `https://api.anthropic.com/v1/messages`
- **Streaming:** `stream: true` → SSE
- **Modelle:** `claude-sonnet-4-20250514`, `claude-opus-4-20250514`, `claude-3-5-haiku-20241022`
- **Auth:** `x-api-key` Header + `anthropic-version: 2023-06-01`
- **Format:** `messages` Array + `system` als separates Feld

### 3. Gemini API (Google)
- **Endpoint:** `https://generativelanguage.googleapis.com/v1beta/models/{model}:streamGenerateContent`
- **Streaming:** `streamGenerateContent` Endpoint
- **Modelle:** `gemini-2.0-flash`, `gemini-1.5-pro`
- **Auth:** API Key als Query Parameter `?key=...`
- **Format:** `contents` Array mit `parts`

---

## Streaming in Flutter

### SSE (Server-Sent Events) - EMPFOHLEN
- Alle drei APIs unterstützen SSE
- `http` package kann `http.Request` mit `send()` → Response Stream
- Response als `Stream<String>` verarbeiten
- Zeilenweise parsen: `data: {...}` Events extrahieren
- Vorteil: Einfach, alle APIs unterstützen es

### WebSocket
- OpenAI bietet keine WebSocket API für Chat
- Claude bietet keine WebSocket API
- Gemini hat limited WebSocket Support
- **Fazit:** SSE ist der Weg

### SSE Implementation Pattern:
```dart
final request = http.Request('POST', uri);
request.headers['Authorization'] = 'Bearer $apiKey';
request.headers['Content-Type'] = 'application/json';
request.body = jsonEncode({"model": "gpt-4o", "stream": true, "messages": [...]});

final response = await client.send(request);
response.stream
  .transform(utf8.decoder)
  .transform(const LineSplitter())
  .listen((line) {
    if (line.startsWith('data: ')) {
      final data = line.substring(6);
      if (data != '[DONE]') {
        final json = jsonDecode(data);
        final content = json['choices'][0]['delta']['content'];
        // UI aktualisieren
      }
    }
  });
```

---

## Chat-History Local Storage

### Hive - EMPFOHLEN
- **Warum:** Schnell, NoSQL, Flutter-native, kein SQL nötig
- **Schema:**
  - `Conversation` Box: {id, title, createdAt, updatedAt, model, apiProvider}
  - `Message` Box: {id, conversationId, role, content, timestamp, tokens}
- **Vorteil:** TypeAdapter für Custom Objects, sehr schnell
- **Alternative:** `sqflite` wenn Relations nötig (aber overkill für Chat)

### Schema:
```dart
@HiveType(typeId: 0)
class Conversation {
  @HiveField(0) String id;
  @HiveField(1) String title;
  @HiveField(2) DateTime createdAt;
  @HiveField(3) DateTime updatedAt;
  @HiveField(4) String model;
  @HiveField(5) String apiProvider; // openai, claude, gemini
}

@HiveType(typeId: 1)
class Message {
  @HiveField(0) String id;
  @HiveField(1) String conversationId;
  @HiveField(2) String role; // user, assistant, system
  @HiveField(3) String content;
  @HiveField(4) DateTime timestamp;
  @HiveField(5) int? tokens;
}
```

---

## Architektur-Empfehlung

### Simple MVVM mit Provider
```
lib/
  models/          → Message, Conversation
  services/        → ApiService (OpenAI/Claude/Gemini Adapter)
  providers/       → ChatProvider, SettingsProvider
  screens/         → ChatScreen, ConversationsScreen, SettingsScreen
  widgets/         → ChatBubble, MessageInput, StreamingText
  storage/         → HiveStorage
```

### API Adapter Pattern:
```dart
abstract class AiApiService {
  Stream<String> sendMessage(List<Message> history);
  Future<String> getResponse(List<Message> history);
}

class OpenAiService implements AiApiService { ... }
class ClaudeService implements AiApiService { ... }
class GeminiService implements AiApiService { ... }
```
