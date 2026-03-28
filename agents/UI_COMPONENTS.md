# UI_COMPONENTS.md — Kali Chat App

> Vollständige Widget-Spezifikationen für Kilo Code (Coding Agent).
> Basierend auf STYLE_GUIDE.md, FEEDBACK.md (28.03.2026) und aktuellem Code-Stand.

---

## 1. Chat-Bubble Widget (`ChatBubble`)

### Übersicht

Zeigt User- oder AI-Nachrichten an. User = blaue Bubble rechts, AI = dunkle Bubble links mit Markdown-Rendering und Metadaten.

### Visuelle Spezifikation

| Property | User Bubble | AI Bubble |
|----------|-------------|-----------|
| Background | `#1F6FEB` (bubbleUser) | `#21262D` (bubbleAi) |
| Text Color | `#FFFFFF` (bubbleUserText) | `#E6EDF3` (bubbleAiText) |
| Border | Keine | `1px solid #30363D` (bubbleAiBorder) |
| Border Radius | `18px` top-left, top-right, bottom-left / `4px` bottom-right | `18px` top-left, top-right, bottom-right / `4px` bottom-left |
| Max Width | 85% Screen-Breite | 85% Screen-Breite |
| Padding | `12px` vertical, `16px` horizontal | `12px` vertical, `16px` horizontal |
| Margin (zwischen Bubbles) | `2px` vertical (symmetric) | `2px` vertical (symmetric) |
| Font | `15px`, `w400`, `height: 1.5` | `15px`, `w400`, `height: 1.5` |
| Alignment | `Alignment.centerRight` | `Alignment.centerLeft` |
| Shadow | Kein | Kein |

### AI Metadaten (unterhalb der Bubble)

```
12:34 · gpt-4o · 42 tokens
```

| Property | Value |
|----------|-------|
| Font | `12px`, `w400`, `height: 1.4` |
| Color | `#8B949E` (textSecondary) |
| Padding | `4px top, 4px left, 4px right` |
| Separator | ` · ` (middle dot) |
| Felder | Timestamp (optional), Model, Token-Count |

### Markdown Styling (AI Messages)

| Element | Style |
|---------|-------|
| Paragraph (`p`) | `15px w400`, color `#E6EDF3`, line-height `1.5` |
| Headings (`h1/h2/h3`) | `18/17/16px w600`, color `#E6EDF3` |
| Bold (`strong`) | `w600`, color `#E6EDF3` |
| Inline Code | bg: `#0D1117`, font: monospace `13px`, radius: `4px`, padding: `2px 6px` |
| Code Block | bg: `#0D1117`, radius: `8px`, padding: `12px` |
| Links (`a`) | color: `#58A6FF` (accentPrimary), unterstrichen |
| Lists | Marker: `•`, Einzug: `16px` |

### Status-Anzeige

- **Streaming aktiv**: Bubble zeigt `StreamingIndicator` (siehe Abschnitt 3)
- **Fehler**: Optional Retry-Button unter der Bubble
- **Copy**: `onLongPress` → Content in Clipboard

### Dart Code Snippet

```dart
class ChatBubble extends StatelessWidget {
  final Message message;
  final String? model;
  final int? tokenCount;

  const ChatBubble({
    super.key,
    required this.message,
    this.model,
    this.tokenCount,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isUser ? KaliColors.bubbleUser : KaliColors.bubbleAi,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser
                    ? null
                    : Border.all(color: KaliColors.bubbleAiBorder, width: 1),
              ),
              child: isUser
                  ? Text(
                      message.content,
                      style: const TextStyle(
                        color: KaliColors.bubbleUserText,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    )
                  : MarkdownBody(
                      data: message.content,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          color: KaliColors.bubbleAiText,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        code: TextStyle(
                          backgroundColor: KaliColors.bgPrimary,
                          fontFamily: 'monospace',
                          fontSize: 13,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: KaliColors.bgPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        a: const TextStyle(
                          color: KaliColors.accentPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
            ),
          ),
          if (!isUser && (model != null || tokenCount != null))
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                [model, if (tokenCount != null) '$tokenCount tokens']
                    .whereType<String>()
                    .join(' · '),
                style: const TextStyle(
                  color: KaliColors.textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

### Hinweise für Kilo Code

- `KaliColors` ist eine statische Farb-Klasse (nicht `Theme.of(context)` — Dark-Mode-First)
- `Message.isUser` ist ein Getter: `role == 'user'`
- `flutter_markdown` Package wird für AI-Responses verwendet
- `selectable: true` erlaubt Text-Selektion in AI-Responses
- FEEDBACK.md: Code Highlighting mit `flutter_highlight` ist vorbereitet, aber noch nicht in ChatBubble integriert

---

## 2. Message Input Widget (`MessageInput`)

### Übersicht

Textfeld + Send-Button am unteren Bildschirmrand. Support für Multi-Line, Auto-Clear nach Send, Focus-State-Border.

### Visuelle Spezifikation

```
┌──────────────────────────────────────┐
│  Schreibe eine Nachricht...    [➤]  │
└──────────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| Background (Container) | `#21262D` (bgTertiary) |
| Border (Container Top) | `1px solid #30363D` (borderColor) |
| Container Padding | `8px` horizontal, `8px` vertical |
| Input Background | `#21262D` (bgTertiary) |
| Input Border Radius | `24px` |
| Input Border (default) | `1px solid #30363D` (borderColor) |
| Input Border (focused) | `1px solid #58A6FF` (accentPrimary) |
| Input Padding | `16px` horizontal, `12px` vertical |
| Text Font | `15px`, white, `height: 1.5` |
| Placeholder | `"Schreibe eine Nachricht..."`, color `#484F58` (textMuted) |
| Min Height | `48px` |
| Max Height | `120px` (scrollbar bei langen Inputs) |
| Send Button | Circle `40x40px`, bg: `#58A6FF` (accentPrimary) |
| Send Icon | `Icons.send`, white, `20px` |
| Send Button (disabled) | bg: `#30363D` (borderColor) |
| Gap (Input ↔ Button) | `8px` |

### Verhalten

| Event | Aktion |
|-------|--------|
| `onSubmitted` (Enter/Tastatur-Senden) | `_handleSend()` |
| Send-Button Tap | `_handleSend()` |
| `_handleSend()` | Trim → Check `text.isNotEmpty && enabled` → `onSend(text)` → `controller.clear()` |
| `enabled = false` | Input deaktiviert, Send-Button grau |
| Focus Change | `setState` → Border-Farbe wechseln |

### Dart Code Snippet

```dart
class MessageInput extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool enabled;

  const MessageInput({
    super.key,
    required this.onSend,
    this.enabled = true,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.enabled) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: const BoxDecoration(
          color: KaliColors.bgTertiary,
          border: Border(
            top: BorderSide(color: KaliColors.borderColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 48,
                  maxHeight: 120,
                ),
                decoration: BoxDecoration(
                  color: KaliColors.bgTertiary,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isFocused
                        ? KaliColors.accentPrimary
                        : KaliColors.borderColor,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Schreibe eine Nachricht...',
                    hintStyle: TextStyle(
                      color: KaliColors.textMuted,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.enabled
                    ? KaliColors.accentPrimary
                    : KaliColors.borderColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: widget.enabled ? _handleSend : null,
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Hinweise für Kilo Code

- `SafeArea` verhindert Overlap mit System-UI (Home-Indikator etc.)
- `textInputAction: TextInputAction.send` → Tastatur zeigt "Senden" statt Enter
- `maxLines: null` + `maxHeight: 120px` → Multi-Line mit Scroll-Limit
- `enabled` wird vom Parent (ChatScreen) gesteuert: `false` während Streaming
- FEEDBACK.md: Input Validation (10.000 Zeichen Limit) ist im Provider, nicht im Widget

---

## 3. Streaming Indicator (`StreamingIndicator`)

### Übersicht

Zeigt an, dass die AI gerade streamed. Besteht aus zwei Teilen: Blinkender Cursor in der AI-Bubble + Status-Bar mit Token-Count und Zeit.

### Visuelle Spezifikation

```
  ┌──────────────────────────────┐
  │  █                           │  ← Blinkender Cursor (Option A)
  └──────────────────────────────┘
┌──────────────────────────────────────┐
│  ● Streaming... · 42 tokens · 2.1s  │  ← Status Bar
└──────────────────────────────────────┘
```

### Part 1: Blinkender Cursor (in AI-Bubble)

| Property | Value |
|----------|-------|
| Character | `█` (Unicode Block, U+2588) |
| Color | `#58A6FF` (accentPrimary) |
| Font Size | `15px`, `height: 1.5` |
| Animation | `opacity: 0.0 → 1.0` |
| Duration | `500ms` |
| Curve | `Curves.easeInOut` |
| Repeat | Endlos (`repeat(reverse: true)`) bis Stream endet |
| Widget | `AnimatedBuilder` + `Opacity` |

### Part 2: Pulsing Dot (in Status Bar)

| Property | Value |
|----------|-------|
| Size | `8x8px` |
| Shape | Circle (`BoxShape.circle`) |
| Color | `#3FB950` (accentSuccess) |
| Animation | `opacity: 0.5 → 1.0` |
| Duration | `800ms` |
| Curve | `Curves.easeInOut` |
| Repeat | Endlos (`repeat(reverse: true)`) |

### Part 3: Status Bar

| Property | Value |
|----------|-------|
| Background | `#21262D` (bgTertiary) |
| Border (top) | `1px solid #30363D` (borderColor) |
| Padding | `8px` horizontal, `4px` vertical |
| Margin | `4px top, 4px left` |
| Text Font | `12px`, `#8B949E` (textSecondary) |
| Content | `● Streaming` + optional ` · {tokens} tokens` + optional ` · {elapsed}s` |
| Separator | ` · ` (middle dot) |

### Ein-/Ausblenden

| Property | Value |
|----------|-------|
| Show | `AnimatedOpacity` `0 → 1`, `200ms` |
| Hide | `AnimatedOpacity` `1 → 0`, `150ms` |
| Condition | Visible wenn `ChatProvider.isStreaming == true` |

### Dart Code Snippet

```dart
class StreamingIndicator extends StatefulWidget {
  final int? tokenCount;
  final Duration? elapsedTime;

  const StreamingIndicator({
    super.key,
    this.tokenCount,
    this.elapsedTime,
  });

  @override
  State<StreamingIndicator> createState() => _StreamingIndicatorState();
}

class _StreamingIndicatorState extends State<StreamingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Bubble mit blinking cursor
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: KaliColors.bgTertiary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border.all(color: KaliColors.borderColor, width: 1),
              ),
              child: AnimatedBuilder(
                animation: _cursorController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _cursorController.value,
                    child: const Text(
                      '█',
                      style: TextStyle(
                        color: KaliColors.accentPrimary,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Status Bar
          Container(
            margin: const EdgeInsets.only(top: 4, left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PulsingDot(), // 8px circle, accentSuccess, 800ms loop
                const SizedBox(width: 6),
                const Text('Streaming',
                    style: TextStyle(color: KaliColors.textSecondary, fontSize: 12)),
                if (widget.tokenCount != null) ...[
                  const Text(' · ',
                      style: TextStyle(color: KaliColors.textSecondary)),
                  Text('${widget.tokenCount} tokens',
                      style: const TextStyle(
                          color: KaliColors.textSecondary, fontSize: 12)),
                ],
                if (widget.elapsedTime != null) ...[
                  const Text(' · ',
                      style: TextStyle(color: KaliColors.textSecondary)),
                  Text('${widget.elapsedTime!.inMilliseconds / 1000.0}s',
                      style: const TextStyle(
                          color: KaliColors.textSecondary, fontSize: 12)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Pulsing Dot — eigenes StatefulWidget
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: KaliColors.accentSuccess.withValues(
              alpha: 0.5 + _controller.value * 0.5,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
```

### Hinweise für Kilo Code

- `SingleTickerProviderStateMixin` statt `TickerProviderStateMixin` (Performance: nur 1 Controller)
- `_PulsingDot` ist ein separates Widget (eigener State) — nicht inline in `_StreamingIndicatorState`
- FEEDBACK.md: Fallback-Option B (Drei-Punkt-Animation) ist dokumentiert aber nicht implementiert — nur Option A (Cursor)
- Token-Count und Elapsed-Time sind optional — wird vom Provider übergeben

---

## 4. Conversation List Item (`ConversationListItem`)

### Übersicht

Ein Eintrag in der ConversationsList. Zeigt Avatar (API-Provider Initiale), Titel, Untertitel (Model) und Datum. Swipe-to-Delete.

### Visuelle Spezifikation

```
┌──────────────────────────────────────────┐
│  [O]  Meine erste Chat-Session      Heute│
│       openai · gpt-4o                    │
└──────────────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| Item Height | `72px` (standard ListTile) |
| Background | `#161B22` (bgSecondary) |
| Selected Background | `#21262D` (bgTertiary) |
| Avatar | CircleAvatar, `40px`, Text: API-Provider Initiale (O/C/G) |
| Avatar Background | Theme primary color |
| Title Font | `18px w600` (subtitle), color: `#E6EDF3` |
| Title Max Lines | `1`, overflow: `ellipsis` |
| Subtitle Font | `12px w400` (caption), color: `#8B949E` |
| Subtitle Content | `{apiProvider} · {model}` |
| Trailing Font | `12px w400` (bodySmall), color: `#8B949E` |
| Divider | `1px #30363D` (borderColor) — automatisch durch ListTile |
| Padding | Standard ListTile Padding |

### Datum-Formatierung

| Zeitraum | Format |
|----------|--------|
| Heute | `HH:mm` (z.B. `14:32`) |
| < 7 Tage | `{n}d ago` |
| Älter | `DD/MM` (z.B. `27/03`) |

### Swipe Actions

| Richtung | Aktion |
|----------|--------|
| `endToStart` (swipe links) | Delete — roter Hintergrund + Delete-Icon |
| Background Color | `Theme.of(context).colorScheme.error` |
| Icon | `Icons.delete`, color: `onError` |

### Provider-Branding (Avatar)

| API Provider | Initiale | Farbe |
|-------------|----------|-------|
| OpenAI | `O` | `#10A37F` (openAiGreen) |
| Claude | `C` | `#D97706` (claudeOrange) |
| Gemini | `G` | `#4285F4` (geminiBlue) |

### Dart Code Snippet

```dart
class ConversationsScreen extends StatefulWidget {
  static const String routeName = '/conversations';
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kali Chat'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, SettingsScreen.routeName),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final provider = context.read<ChatProvider>();
          await provider.createNewConversation();
          if (context.mounted) {
            Navigator.pushNamed(context, ChatScreen.routeName);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, _) {
          if (provider.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_outlined, size: 64,
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('No conversations yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
                  const SizedBox(height: 8),
                  Text('Tap + to start a new chat',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.conversations.length,
            itemBuilder: (context, index) {
              final conversation = provider.conversations[index];
              return Dismissible(
                key: Key(conversation.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: Theme.of(context).colorScheme.error,
                  child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
                ),
                onDismissed: (_) => provider.deleteConversation(conversation.id),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _providerColor(conversation.apiProvider),
                    child: Text(
                      conversation.apiProvider[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  title: Text(conversation.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    '${conversation.apiProvider} · ${conversation.model}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Text(
                    _formatDate(conversation.updatedAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () async {
                    await provider.selectConversation(conversation.id);
                    if (context.mounted) {
                      Navigator.pushNamed(context, ChatScreen.routeName);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _providerColor(String provider) {
    switch (provider.toLowerCase()) {
      case 'openai': return const Color(0xFF10A37F);
      case 'claude': return const Color(0xFFD97706);
      case 'gemini': return const Color(0xFF4285F4);
      default: return KaliColors.accentPrimary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    }
  }
}
```

### Hinweise für Kilo Code

- `_providerColor()` ist aktuell **nicht** im Code — wird als Verbesserung empfohlen
- `_formatDate()` nutzt `padLeft(2, '0')` — FEEDBACK.md bestätigt: BUG-008 bereits gefixt
- `Dismissible` = Swipe-to-Delete (nur `endToStart`, kein Archive-Feature)
- `addPostFrameCallback` in `initState` → verhindert Provider-Aufrufe während Build
- Empty State zeigt Icon + Text + Subtext

---

## 5. KaliColors — Shared Color Constants

Alle Widgets teilen diese statische Farb-Klasse. **Nicht** `Theme.of(context)` verwenden (Dark-Mode-First).

```dart
class KaliColors {
  // Background
  static const Color bgPrimary = Color(0xFF0D1117);
  static const Color bgSecondary = Color(0xFF161B22);
  static const Color bgTertiary = Color(0xFF21262D);
  static const Color borderColor = Color(0xFF30363D);

  // Text
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);

  // Accents
  static const Color accentPrimary = Color(0xFF58A6FF);
  static const Color accentSuccess = Color(0xFF3FB950);
  static const Color accentWarning = Color(0xFFD29922);
  static const Color accentDanger = Color(0xFFF85149);

  // Bubbles
  static const Color bubbleUser = Color(0xFF1F6FEB);
  static const Color bubbleUserText = Color(0xFFFFFFFF);
  static const Color bubbleAi = Color(0xFF21262D);
  static const Color bubbleAiText = Color(0xFFE6EDF3);
  static const Color bubbleAiBorder = Color(0xFF30363D);

  // Provider Branding
  static const Color openAiGreen = Color(0xFF10A37F);
  static const Color claudeOrange = Color(0xFFD97706);
  static const Color geminiBlue = Color(0xFF4285F4);
}
```

---

## 6. Paket-Abhängigkeiten (Relevant für Widgets)

| Paket | Widget | Zweck |
|-------|--------|-------|
| `flutter_markdown` | ChatBubble | AI-Response Markdown-Rendering |
| `flutter_highlight` | ChatBubble (TODO) | Code Syntax Highlighting |
| `provider` | Alle Screens | State Management (Consumer/Provider) |
| `hive` / `hive_flutter` | ChatProvider | Lokale Speicherung |
| `uuid` | Message-Model | Unique IDs für Messages |

---

## 7. Bekannte Bugs & Verbesserungen

Aus FEEDBACK.md (28.03.2026):

| ID | Issue | Status |
|----|-------|--------|
| BUG-005 | HTTP Client nicht disposed | Offen (braucht größeres Refactoring) |
| H1 | Silent Exception Swallowing | ✅ Erledigt (debugPrint) |
| C2 | Input Validation | ✅ Erledigt (10.000 Zeichen + API-Key-Check) |
| — | Code Highlighting in ChatBubble | Vorbereitet, nicht integriert |
| — | Provider-Branding-Colors in Avatar | Empfohlen, nicht implementiert |

---

## 8. Architektur-Notes für Kilo Code

```
lib/
  models/
    message.dart          → Message (HiveType typeId: 1)
    conversation.dart     → Conversation (HiveType typeId: 0)
    kali_personality.dart → 5 Personality Templates
  services/
    ai_api_service.dart   → Abstract AiApiService (Stream<String> sendMessage)
    openai_service.dart   → OpenAI SSE Implementation
    claude_service.dart   → Claude SSE Implementation
    gemini_service.dart   → Gemini SSE Implementation
  providers/
    chat_provider.dart    → Chat State (Conversations, Messages, Streaming)
    settings_provider.dart → API Keys, Model Selection, Personality
  screens/
    chat_screen.dart      → Main Chat UI
    conversations_screen.dart → Conversation List
    settings_screen.dart  → API Key + Model Configuration
  widgets/
    chat_bubble.dart      → User/AI Message Bubble
    message_input.dart    → Text Input + Send Button
    streaming_indicator.dart → Cursor + Status Bar
  storage/
    hive_storage.dart     → Singleton Hive Storage
```

---

*Erstellt am 28.03.2026 vom Design Agent (Tag 2).*
*Quellen: STYLE_GUIDE.md, FEEDBACK.md (28.03.2026), aktueller Code-Stand.*
