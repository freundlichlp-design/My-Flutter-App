# DESIGN_MASTER.md — Kali Chat Design Master Reference

> **Design Agent PRO v2** — Die 5 wichtigsten Design-Dokumente in einem File.
> Basierend auf: DESIGN_SYSTEM.md, KALI_STYLE.md, STYLE_GUIDE.md, UI_COMPONENTS.md

---

# 1. Chat Screen Wireframe

## Layout Structure

```
┌─────────────────────────────────────────────────────┐
│ ▓▓ APP BAR ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │
│  [←]  Model: GPT-4o              [⚙] [⋯]          │
│─────────────────────────────────────────────────────│
│                                                     │
│  CHAT MESSAGES (ListView.builder, reverse: true)    │
│                                                     │
│  ┌─────────────────────────────────┐                │
│  │ System: "Du bist Kali..."  [🔧] │                │
│  └─────────────────────────────────┘                │
│         ┌──────────────────────────────┐            │
│         │  Hey, was ist neu?           │  ● sent    │
│         └──────────────────────────────┘            │
│  ┌─────────────────────────────────────────┐        │
│  │ Kali antwortet gerade...                │        │
│  │ Der Stream-Indikator pulsiert blau.     │ ▍      │
│  └─────────────────────────────────────────┘        │
│  [📋 Copy] [🔄 Regenerate] [🗑️ Delete]             │
│─────────────────────────────────────────────────────│
│ ▓▓ INPUT BAR ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │
│  [📎] [Schreib eine Nachricht...] [🎤] [▶ Senden]  │
└─────────────────────────────────────────────────────┘
```

## Komponenten-Hierarchie

```
ChatScreen (ConsumerStatefulWidget)
├── AppBar
│   ├── BackButton → ConversationsScreen
│   ├── ModelSelectorDropdown (currentProvider + modelName)
│   ├── SettingsButton → SettingsScreen
│   └── MoreOptionsButton (share, export, clear)
├── MessagesList (ListView.builder, reverse: true)
│   ├── SystemMessageBubble (collapsible)
│   ├── UserMessageBubble
│   │   ├── TextContent (SelectableText)
│   │   ├── ImageAttachment (if any)
│   │   └── StatusIndicator (sending → sent → read)
│   └── AiMessageBubble
│       ├── StreamingText (AnimatedText with cursor ▍)
│       ├── CodeBlock (SyntaxHighlighted, Copy-Button)
│       ├── MarkdownContent (flutter_markdown)
│       └── ActionBar (copy, regenerate, delete)
├── MessageInput
│   ├── AttachmentButton (ImagePicker)
│   ├── TextField (multiline, maxLines: 5)
│   ├── VoiceInputButton (speech_to_text, hold-to-talk)
│   └── SendButton (disabled when empty)
```

## Spacing & Abmessungen

| Element | Wert |
|---------|------|
| App Bar Height | 56dp |
| Bubble Max Width | 85% screen |
| Bubble Padding | 12dp H, 8dp V |
| Bubble Radius | 16dp (user top-right=4dp asymmetrisch) |
| Message Gap (gleicher Sender) | 4dp |
| Sender Gap (User ↔ AI) | 16dp |
| Input Bar Height | 56dp (expandable bis 120dp) |

## Scroll-Verhalten
- **Reverse ListView** — auto-scroll bei neuem Input
- **Scroll-to-bottom FAB** — erscheint beim Hochscrollen
- **Sticky Date Header** — "Heute", "Gestern", "12. Mär"
- **Haptic Feedback** — Long-Press auf Bubble → Copy/Share Context Menu

---

# 2. Empty States (Kali Attitude)

## 2.1 Keine Konversationen

```
┌─────────────────────────────────┐
│          ┌─────────┐            │
│          │ KALI ▍  │            │
│          └─────────┘            │
│                                 │
│     Leere ist langweilig.       │
│     Fang an zu reden.           │
│                                 │
│   ┌─────────────────────┐       │
│   │  + Neue Konversation │       │
│   └─────────────────────┘       │
│   Oder importiere Verlauf [→]   │
└─────────────────────────────────┘
```

**Copy-Varianten (zufällig rotieren):**
1. *"Leere ist langweilig. Fang an zu reden."*
2. *"Noch nichts hier. Dein erstes Wort?"*
3. *"Stille vor dem Sturm."*
4. *"0 Gespräche. 0 Tokens verschwendet. Potential: unbegrenzt."*
5. *"Die KI wartet. Du auch?"*

## 2.2 Keine Nachrichten in Konversation
```
┌─────────────────────────────────┐
│           ▍ (blinkender Cursor) │
│     Neue Konversation.          │
│     Modell: GPT-4o · 128K Ctx  │
│   Was willst du wissen?         │
│  💡 /model wechselt Modell      │
│  💡 [📎] für Bilder             │
└─────────────────────────────────┘
```

## 2.3 Keine Suchergebnisse
```
     "query" → Nichts gefunden.
     Selbst Kali weiß nicht alles.
   [🔍 Anderer Suchbegriff]
```

**Kali-Attitude-Regeln:**
- Immer ehrlich, nie naiv ("Oopsie!" — NEIN)
- Immer kurz (max 2 Zeilen)
- Immer mit Next Action (Button/Link)
- Humor trocken, kein Emoji-Spam
- Fehler = Kali's Schuld, nie User's Schuld

---

# 3. Error States (Kali reagiert)

## 3.1 API Key Fehlend / Ungültig
```
┌─────────────────────────────────┐
│  ⚠️  AUTH FEHLER                │
│  API Key fehlt oder ungültig.   │
│  Ohne Key kein Modell.          │
│  Ohne Modell kein Chat. Logik.  │
│  [→ API Key eingeben]           │
└─────────────────────────────────┘
```
- **Icon:** 🔒 Geschlossenes Schloss
- **Border:** `accentDanger` (#F85149), Background: `bgTertiary`
- **Animation:** Shake (200ms, 3x) auf Input-Feld

## 3.2 Network Error / Timeout
```
┌─────────────────────────────────┐
│  📡  VERBINDUNG UNTERBROCHEN    │
│  Keine Verbindung zum Server.   │
│  Nachricht wurde gespeichert.   │
│  Retry in 5s... ████░░░ 53%     │
│  [↻ Jetzt erneut versuchen]    │
└─────────────────────────────────┘
```
- Auto-Retry mit Exponential Backoff (5s → 10s → 20s → 40s)
- Offline-Queue in Hive: "2 Nachrichten in Warteschlange"
- Connectivity-Stream → Status-Badge in App Bar

## 3.3 Rate Limit (429)
```
┌─────────────────────────────────┐
│  ⏱️  ZU SCHNELL                 │
│  Rate Limit erreicht.           │
│  Nächster Versuch in 30s.       │
│  ████████░░░░░░░░ 53%           │
│  [↻ Sofort erneut versuchen]   │
└─────────────────────────────────┘
```
- Respektiert `Retry-After` Header
- Prompt: "Möchtest du auf Gemini wechseln?"

## 3.4 Modell nicht verfügbar
```
┌─────────────────────────────────┐
│  🔧  MODELL NICHT VERFÜGBAR    │
│  GPT-4o antwortet nicht.        │
│  ✅ Claude Sonnet               │
│  ✅ Gemini Pro                  │
│  ❌ GPT-4o (down)               │
│  [→ Zu Claude wechseln]        │
└─────────────────────────────────┘
```

**Global Error Rules:**
- Background: `bgSecondary` (#161B22), Border: 1px `accentDanger`, Radius 8dp
- Immer im Chat-Stream als System-Message (nicht Modal/SnackBar)
- Buttons: 44dp min Touch-Target, `accentPrimary` (#58A6FF)

---

# 4. Loading States (Neon Pulse)

## 4.1 Chat Streaming — Kern-Experience
```
┌─────────────────────────────────┐
│  ┌───────────────────────────┐  │
│  │ Kali antwortet...         │  │
│  │ Stream-Text läuft...      │ ▍│  ← Blinkender Cursor
│  └───────────────────────────┘  │
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │ ← Neon Pulse Bar
└─────────────────────────────────┘
```

**Neon Pulse Animation:**
```dart
AnimationController _pulse; // duration: 1200ms, repeat
// Pulse: Opacity 0.3 → 1.0 → 0.3, Curves.easeInOut
// Applied to: Bubble border glow, cursor shimmer, "denkt nach" text
// Color: #58A6FF, Shadow(blur: 12, spread: 2)
```

## 4.2 Conversation List Skeleton
```
┌─────────────────────────────────┐
│  ▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░  │  ← Shimmer Sweep
│  ▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░  │     LinearGradient
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░  │     1500ms linear
│  ▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░  │
└─────────────────────────────────┘
```
Pro Item: Titel (60% width), Subtitle (80%), Avatar (40dp circle), Timestamp (40dp rechts)

## 4.3 Initial App Load
```
         ┌─────────┐
         │ KALI ▍  │   ← Logo Scale-Pulse (0.95→1.05, 800ms)
         └─────────┘
      Loading... ████████░░ 67%   ← Real Progress (Hive→API→Ready)
```
Target: < 1.5s auf mid-range Device

## 4.4 Message Sending States
```
[Composing] → [Sending] → [Sent] → [Delivered] → [Streaming]
    —           ●○○        ●●○       ●●●          ▍
    —        textMuted   textSec   accentPri    accentPri
```
Dots-Animation: Sequential fade-in, 150ms stagger. Regel: Aktiv = pulsierendes Neon-Blau.

---

# 5. Micro-Interactions (5 Wichtigste)

## 5.1 🎤 Voice Input — Hold to Talk
| Phase | Visual | Haptic |
|-------|--------|--------|
| TouchDown | Button scale(1.0→0.9) | heavyImpact() |
| 200ms | Pulse-Ring expand (neon-blau, 64→96dp) | — |
| Listening | Ring pulsiert (0.3 opacity cycle), Waveform | — |
| Slide Left >50dp | Ring wird rot, "Loslassen zum Abbrechen" | — |
| Release | Ring collapse(48→0, 300ms), senden | mediumImpact() |

## 5.2 📋 Copy Code — Tap Feedback
| Phase | Detail |
|-------|--------|
| Tap | Icon morph: 📋 → ✅ (200ms spring animation) |
| Feedback | "Kopiert!" Toast (bottom, 1.5s auto-dismiss) |
| Long Code (>1000 Zeilen) | Confirm: "Alles kopieren? (4.2KB)" |

Nie silent kopieren — User muss IMMER wissen dass es geklappt hat.

## 5.3 🔄 Regenerate Response — Swipe Action
| Phase | Detail |
|-------|--------|
| Trigger | Horizontal Swipe left auf AI-Bubble |
| Visual | Bubble slidet → Reveals [🔄] [🗑️] |
| Physics | 250ms ease-out, rubber-band bei Über-Swipe |
| Haptic | lightImpact() bei Swipe-Threshold |
| Alternative | Tap ⋯ → Action Sheet |

```
┌──────────────────────────────────┐
│  AI Response Text...      │🔄│🗑️ │
└──────────────────────────────────┘
```

## 5.4 ⌨️ Input Focus — Smooth Transition
| Phase | Detail |
|-------|--------|
| Tap Textfeld | Border: `borderColor` → `borderFocus` (#58A6FF, 200ms) |
| Shadow | blur 0→8, color: #58A6FF@20% ("atmet") |
| Placeholder | Opacity fade-out beim Focus |
| Keyboard | AnimatedPadding schiebt hoch (kein Jump) |
| Send Button | Muted → Neon-Blau bei Text-Eingabe |

Cursor-Farbe: `accentPrimary` (#58A6FF). Text-Selection: `accentPrimary` @30% BG.

## 5.5 💬 Message Sent — Satisfying Send
```
0ms    → Haptic: mediumImpact()
0ms    → Button springt (scale 1.0→1.2→1.0, 400ms spring)
50ms   → Input cleared (opacity 1.0→0, 150ms)
100ms  → User-Bubble erscheint (slide up + fade in, 300ms)
400ms  → AI-Thinking indicator (fade in, 200ms delay)
500ms  → Streaming beginnt
```

---

## Cross-Cutting Design Rules

### Animation Principles
1. **Max 300ms** für UI-Transitions (Streaming = proaktiv, ausgenommen)
2. **Spring Physics** für physische Interaktionen (Swipe, Button-Press)
3. **Ease-In-Out** für Visual-Transitions (Fade, Color-Change)
4. **Haptic bei JEDEM** physischen Feedback
5. **Keine Blocking-Animations** — User kann immer weitermachen

### Kali Personality in UI
- **Ehrlich:** "API Key fehlt" statt "Etwas ist schiefgelaufen"
- **Kurz:** Max 2 Zeilen Error-Text
- **Trocken:** Humor okay, aber kein "Oopsie! 🙈"
- **Kontrolliert:** User sieht IMMER Tokens, Modell, Status
- **Schnell:** Loading = Streaming. Kein Spinner ohne Progress.

### Farb-Usage
| Zustand | Farbe | Hex |
|---------|-------|-----|
| Aktiv / Streaming | Neon Blue | #58A6FF |
| Erfolg | Green | #3FB950 |
| Warning | Yellow | #D29922 |
| Error | Red | #F85149 |
| Inaktiv / Muted | Gray | #484F58 |

### Accessibility
- Contrast Ratio: Min 4.5:1 (alle Farben erfüllen)
- Touch Targets: Min 44x44dp
- Screen Reader: Alle Icons haben semantic labels
- `prefers-reduced-motion` → Pulse wird statischer Glow

---

> **DESIGN_MASTER.md v1.0** — 28.03.2026
> Nächster Schritt: Figma Wireframes basierend auf diesen Spezifikationen.
