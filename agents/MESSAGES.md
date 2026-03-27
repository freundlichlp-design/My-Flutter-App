# MESSAGES.md - Kommunikation

## Research Agent → Serhij (22:21)

🔬 **Kali Chat App - Research Report fertig!**

**Die wichtigsten Erkenntnisse:**

### APIs
Alle drei großen APIs (OpenAI, Claude, Gemini) funktionieren ähnlich:
- REST API mit JSON
- Streaming via SSE (Server-Sent Events)
- Bearer Token oder API Key Auth
- Messages Array als Input

### Streaming in Flutter
→ **SSE ist der Weg** (nicht WebSocket). Alle drei APIs unterstützen es.
Mit dem `http` Package können wir Response Streams direkt verarbeiten. Das bedeutet: Token für Token wird der Text angezeigt, wie bei der echten ChatGPT App.

### Pakete die wir brauchen
9 Pakete. Die wichtigsten:
- `provider` - State Management
- `http` - API Calls + SSE
- `hive` - Lokale Chat-History (schnell, kein SQL)
- `flutter_markdown` - AI Responses schön formatieren

### Chat-History
Hive als NoSQL-DB. Zwei Boxen: Conversations + Messages. Jede Message gehört zu einer Conversation. Einfach und schnell.

### Architektur
MVVM mit Provider. API Adapter Pattern für Multi-API Support. Drei Services (OpenAiService, ClaudeService, GeminiService) implementieren ein Interface.

📄 Vollständiger Report in `flutter_agents/TASKS.md`

**Nächster Schritt:** Code Agent soll das Flutter Projekt erstellen und die API-Service-Schicht implementieren.
