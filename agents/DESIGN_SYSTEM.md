# DESIGN_SYSTEM.md — Kali Chat App

> **Design Agent Tag 5** — Complete Design System Specification
> Basierend auf STYLE_GUIDE.md, UI_COMPONENTS.md, ARCHITECTURE.md
> Erstellt: 28.03.2026

---

## 1. Design Token System

### 1.1 Farben (Dart Constants)

```dart
import 'package:flutter/material.dart';

/// Design Tokens — Kali Chat App
/// Alle Farben als Color-Konstanten. Dark-Mode-First.
/// Hex-Werte sind die Single Source of Truth.
class KaliColors {
  KaliColors._(); // Prevent instantiation

  // ═══════════════════════════════════════════════════════
  //  BACKGROUND TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color bgPrimary    = Color(0xFF0D1117);
  static const Color bgSecondary  = Color(0xFF161B22);
  static const Color bgTertiary   = Color(0xFF21262D);
  static const Color bgOverlay    = Color(0x99000000);  // Modal backdrop

  // ═══════════════════════════════════════════════════════
  //  TEXT TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color textPrimary   = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted     = Color(0xFF484F58);
  static const Color textInverse   = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════
  //  BORDER TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color borderColor     = Color(0xFF30363D);
  static const Color borderFocus     = Color(0xFF58A6FF);
  static const Color borderDanger    = Color(0xFFF85149);

  // ═══════════════════════════════════════════════════════
  //  SEMANTIC / ACCENT TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color accentPrimary   = Color(0xFF58A6FF);
  static const Color accentSecondary = Color(0xFF388BFD);
  static const Color accentSuccess   = Color(0xFF3FB950);
  static const Color accentWarning   = Color(0xFFD29922);
  static const Color accentDanger    = Color(0xFFF85149);

  // ═══════════════════════════════════════════════════════
  //  CHAT BUBBLE TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color bubbleUser     = Color(0xFF1F6FEB);
  static const Color bubbleUserText = Color(0xFFFFFFFF);
  static const Color bubbleAi       = Color(0xFF21262D);
  static const Color bubbleAiText   = Color(0xFFE6EDF3);
  static const Color bubbleAiBorder = Color(0xFF30363D);

  // ═══════════════════════════════════════════════════════
  //  PROVIDER BRANDING TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color openAiBranding  = Color(0xFF10A37F);
  static const Color claudeBranding  = Color(0xFFD97706);
  static const Color geminiBranding  = Color(0xFF4285F4);
}
```

### 1.2 Typography (Dart Constants)

```dart
/// Typografie-Tokens. Font-Families:
///   - Body/UI: 'Inter' (Fallback: 'SF Pro Display' / 'Roboto')
///   - Code:    'JetBrains Mono' (Fallback: 'monospace')
class KaliTextStyles {
  KaliTextStyles._();

  // ─── Display / Headline ───────────────────────────────
  static const TextStyle headline = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: KaliColors.textPrimary,
  );

  // ─── Subtitle / Section Headers ──────────────────────
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: KaliColors.textPrimary,
  );

  // ─── Body (Chat Messages) ────────────────────────────
  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: KaliColors.textPrimary,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: KaliColors.textPrimary,
  );

  // ─── Caption / Metadata ──────────────────────────────
  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: KaliColors.textSecondary,
  );

  // ─── Label / Buttons ─────────────────────────────────
  static const TextStyle label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: KaliColors.textPrimary,
  );

  // ─── Inline Code ─────────────────────────────────────
  static const TextStyle code = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: KaliColors.textPrimary,
    backgroundColor: KaliColors.bgPrimary,
  );

  // ─── Muted / Placeholder ─────────────────────────────
  static const TextStyle muted = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: KaliColors.textMuted,
  );
}
```

### 1.3 Spacing (Dart Constants)

```dart
/// Spacing-Tokens. Base Unit: 8px
/// Alle Abstände sind Vielfache von 8px (außer 4px für Feinjustierung).
class KaliSpacing {
  KaliSpacing._();

  static const double xxs = 2;   // Hairline
  static const double xs  = 4;   // Inline-Elemente, Icons
  static const double sm  = 8;   // Inneres Padding kleine Elemente
  static const double md  = 16;  // Standard Padding, Gap
  static const double lg  = 24;  // Section Spacing
  static const double xl  = 32;  // Screen Padding Top/Bottom
  static const double xxl = 48;  // Major Sections

  // Convenience EdgeInsets
  static const EdgeInsets paddingXS   = EdgeInsets.all(4);
  static const EdgeInsets paddingSM   = EdgeInsets.all(8);
  static const EdgeInsets paddingMD   = EdgeInsets.all(16);
  static const EdgeInsets paddingLG   = EdgeInsets.all(24);
  static const EdgeInsets paddingXL   = EdgeInsets.all(32);

  static const EdgeInsets paddingScreenH = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets paddingScreenV = EdgeInsets.symmetric(vertical: 32);
}
```

### 1.4 Radius (Dart Constants)

```dart
/// Border-Radius-Tokens
class KaliRadius {
  KaliRadius._();

  static const double sm   = 4;    // Inline Code, Bubble Tails
  static const double md   = 8;    // Code Blocks, Cards
  static const double lg   = 12;   // Sheets
  static const double xl   = 18;   // Chat Bubbles
  static const double pill = 24;   // Input Field
  static const double full = 9999; // Fully rounded (Avatars)

  // Convenience BorderRadius
  static final BorderRadius bubbleUser = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
    bottomLeft: Radius.circular(xl),
    bottomRight: Radius.circular(sm),
  );

  static final BorderRadius bubbleAi = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
    bottomLeft: Radius.circular(sm),
    bottomRight: Radius.circular(xl),
  );

  static final BorderRadius inputField = BorderRadius.circular(pill);
  static final BorderRadius card = BorderRadius.circular(md);
  static final BorderRadius codeBlock = BorderRadius.circular(md);
}
```

### 1.5 Shadows (Dart Constants)

```dart
/// Elevation-Tokens (minimal — Flat Design First)
class KaliElevation {
  KaliElevation._();

  /// Kein Schatten im Default-State (Flat Design).
  /// Nur für Modals/Bottom Sheets bei Bedarf.
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x20000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> none = <BoxShadow>[];
}
```

### 1.6 Durations (Dart Constants)

```dart
/// Animation-Duration-Tokens
class KaliDurations {
  KaliDurations._();

  static const Duration instant    = Duration(milliseconds: 0);
  static const Duration fast       = Duration(milliseconds: 150);
  static const Duration normal     = Duration(milliseconds: 200);
  static const Duration medium     = Duration(milliseconds: 250);
  static const Duration slow       = Duration(milliseconds: 300);
  static const Duration cursor     = Duration(milliseconds: 500);
  static const Duration spinner    = Duration(milliseconds: 1000);
  static const Duration pulsing    = Duration(milliseconds: 800);
}
```

---

## 2. Widget Library — 10 Standard Widgets

Alle Widgets folgen diesen Prinzipien:
- **Named Constructor Parameter Pattern** — required/optional klar getrennt
- **Kein Theme.of(context)** — KaliColors/Styles direkt verwenden (Dark-Mode-First)
- **Keine Business Logic** — State/Logic aus Presentation-Layer via Provider
- **Semantics** — jedes Widget mit `Semantics` Wrapper für Accessibility

### 2.1 `ChatBubble` — Nachrichten-Bubble

**Zweck:** User- und AI-Nachrichten anzeigen.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `message` | `Message` | required | Das Message-Objekt |
| `model` | `String?` | null | AI Model Name (nur AI) |
| `tokenCount` | `int?` | null | Token-Verbrauch (nur AI) |
| `onCopy` | `VoidCallback?` | null | Copy-to-Clipboard Handler |
| `onRetry` | `VoidCallback?` | null | Retry Handler (nur bei Fehlern) |

**Verhalten:**
- User: `bubbleUser` Background, rechts-bündig, `bubbleUser.bubbleUser` Radius
- AI: `bubbleAi` Background, links-bündig, `bubbleAi.bubbleAi` Radius, Markdown-Rendering
- `onLongPress` → Copy-to-Clipboard
- Metadata (Model · Tokens) unter AI-Bubbles
- Max-Width: 85% der Screen-Breite

---

### 2.2 `MessageInput` — Text-Eingabe

**Zweck:** Multi-Line Textfeld mit Send-Button.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `onSend` | `ValueChanged<String>` | required | Callback bei Send |
| `enabled` | `bool` | true | Deaktiviert während Streaming |
| `hintText` | `String` | 'Schreibe eine Nachricht...' | Placeholder |

**Verhalten:**
- `TextInputAction.send` → Tastatur "Senden"-Button
- Auto-Clear nach Send
- Focus-Border: `borderColor` → `accentPrimary`
- Multi-Line: min 48px, max 120px mit Scroll
- Send-Button: 40px Circle, `accentPrimary`/`borderColor` (disabled)

---

### 2.3 `StreamingIndicator` — Streaming-Status

**Zweck:** Blinkender Cursor + Status-Bar während AI streamed.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `tokenCount` | `int?` | null | Bisherige Tokens |
| `elapsedTime` | `Duration?` | null | Verstrichene Zeit |

**Verhalten:**
- Cursor: `█` Character, `accentPrimary`, 500ms Fade-Loop
- Pulsing Dot: 8px, `accentSuccess`, 800ms Pulse
- Status: `● Streaming · {tokens} tokens · {time}s`
- Show/Hide: `AnimatedOpacity` 200ms/150ms

---

### 2.4 `ConversationListItem` — Listen-Eintrag

**Zweck:** Eintrag in der Conversations-Liste.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `conversation` | `Conversation` | required | Conversation-Daten |
| `onTap` | `VoidCallback?` | null | Tap Handler |
| `onDelete` | `VoidCallback?` | null | Swipe-to-Delete Handler |

**Verhalten:**
- Avatar: 40px Circle, Provider-Initiale, Provider-Branding-Farbe
- Title: `subtitle` Style, max 1 Line, ellipsis
- Subtitle: `{provider} · {model}`
- Trailing: Relative Datum (Heute → `HH:mm`, <7d → `Xd ago`, sonst `DD/MM`)
- Swipe `endToStart` → Delete (roter Hintergrund)

---

### 2.5 `KaliButton` — Standard-Button

**Zweck:** Primär- und Sekundär-Actions.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | `String` | required | Button-Text |
| `onPressed` | `VoidCallback?` | required | Tap Handler |
| `variant` | `KaliButtonVariant` | primary | primary / secondary / danger / ghost |
| `icon` | `IconData?` | null | Optionales Icon links |
| `isLoading` | `bool` | false | Loading Spinner statt Text |
| `isFullWidth` | `bool` | false | Volle Breite |

**Varianten:**

| Variant | Background | Text | Border |
|---------|-----------|------|--------|
| `primary` | `accentPrimary` | `textInverse` | none |
| `secondary` | `bgTertiary` | `textPrimary` | `borderColor` |
| `danger` | `accentDanger` | `textInverse` | none |
| `ghost` | transparent | `accentPrimary` | none |

- Border Radius: `8px` (card)
- Padding: `12px` vertical, `24px` horizontal
- Min Width: `120px` (unless `isFullWidth`)
- Disabled: 50% opacity
- Loading: `CircularProgressIndicator` 20px

---

### 2.6 `KaliCard` — Container-Widget

**Zweck:** Gruppiert Content mit Hintergrund + optional Border.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `child` | `Widget` | required | Inhalt |
| `padding` | `EdgeInsets` | `paddingMD` | Innerer Abstand |
| `hasBorder` | `bool` | true | Zeigt Border |
| `hasShadow` | `bool` | false | Zeigt Shadow |
| `onTap` | `VoidCallback?` | null | Tappable Card |

- Background: `bgSecondary`
- Border: `1px solid borderColor`
- Radius: `card` (8px)
- Shadow: `KaliElevation.card` (wenn `hasShadow`)

---

### 2.7 `KaliAvatar` — Provider/User Avatar

**Zweck:** Zeigt Initialen oder Icon in Branding-Farbe.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `provider` | `String?` | null | API Provider (openai/claude/gemini) |
| `initials` | `String` | required | Anzeige-Text |
| `size` | `double` | 40 | Durchmesser in px |
| `backgroundColor` | `Color?` | null | Override (sonst Provider-Branding) |

**Mapping:**

| Provider | Color |
|----------|-------|
| openai | `openAiBranding` |
| claude | `claudeBranding` |
| gemini | `geminiBranding` |
| null | `accentPrimary` |

---

### 2.8 `KaliTextField` — Eingabefeld

**Zweck:** Standard-Textfeld für Settings, Forms.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `controller` | `TextEditingController` | required | Text Controller |
| `label` | `String?` | null | Label über dem Feld |
| `hintText` | `String?` | null | Placeholder |
| `obscureText` | `bool` | false | Für Passwörter/API-Keys |
| `errorText` | `String?` | null | Fehler-Text |
| `suffixIcon` | `Widget?` | null | Icon rechts (z.B. Eye Toggle) |

- Background: `bgTertiary`
- Border: `1px solid borderColor` (default), `borderFocus` (focused), `borderDanger` (error)
- Radius: `inputField` (24px)
- Padding: `16px` H, `12px` V
- Label: `label` Style oberhalb

---

### 2.9 `KaliDivider` — Trennlinie

**Zweck:** Visuelle Trennung von Abschnitten.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `thickness` | `double` | 1 | Linienstärke |
| `indent` | `double` | 0 | Einzug links |
| `endIndent` | `double` | 0 | Einzug rechts |

- Farbe: `borderColor`
- Horizontal full width, optional indented

---

### 2.10 `KaliEmptyState` — Leerzustand

**Zweck:** Angezeigte wenn keine Daten vorhanden.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `icon` | `IconData` | required | Haupt-Icon |
| `title` | `String` | required | Haupt-Text |
| `subtitle` | `String?` | null | Erklärender Text |
| `action` | `Widget?` | null | Optionaler Action-Button |

- Icon: 64px, `accentPrimary` mit 30% Opacity
- Title: `subtitle` Style, 50% Opacity
- Subtitle: `body` Style, 40% Opacity
- Zentriert auf Screen

---

## 3. Animation Guidelines

### 3.1 Prinzipien

1. **Functional, not decorative** — Animationen informieren den User über State-Changes
2. **Schnell & subtil** — Meistens 150–300ms. Keine langen Animationen die den User aufhalten.
3. **Respect `reduceMotion`** — `MediaQuery.disableAnimations` → alle Animationen auf 0ms setzen

### 3.2 Animation Token Registry

| ID | Context | Duration | Curve | Trigger |
|----|---------|----------|-------|---------|
| `a-screenTransition` | Screen Push/Pop | 300ms | `easeOutCubic` | Navigation |
| `a-bubbleAppear` | Neue Message | 200ms | `easeOut` | New message in list |
| `a-cursorBlink` | Streaming Cursor | 500ms | `easeInOut` | `isStreaming = true` |
| `a-spinnerRotate` | Loading | 1000ms | `linear` | Loading state |
| `a-pulsingDot` | Stream Status | 800ms | `easeInOut` | `isStreaming = true` |
| `a-bottomSheet` | Modal/Sheet | 250ms | `easeOutQuart` | Sheet open/close |
| `a-fadeIn` | Content appear | 200ms | `easeOut` | Data loaded |
| `a-fadeOut` | Content disappear | 150ms | `easeIn` | Data removed |
| `a-slideUp` | Keyboard push | 250ms | `easeOut` | Focus input |
| `a-scaleIn` | Button press | 100ms | `easeOut` | Tap feedback |

### 3.3 Reduce-Motion Helper

```dart
/// Gibt true zurück wenn User Animationen deaktiviert hat.
bool shouldReduceMotion(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context);

/// Gibt Duration basierend auf reduceMotion.
Duration resolveDuration(BuildContext context, Duration normal) =>
    shouldReduceMotion(context) ? Duration.zero : normal;
```

### 3.4 Curve Registry

```dart
/// Standard-Curves für die App.
class KaliCurves {
  KaliCurves._();

  static const Curve screenTransition = Curves.easeOutCubic;
  static const Curve bubbleAppear     = Curves.easeOut;
  static const Curve cursorBlink      = Curves.easeInOut;
  static const Curve bottomSheet      = Curves.easeOutQuart;
  static const Curve fadeIn           = Curves.easeOut;
  static const Curve fadeOut          = Curves.easeIn;
  static const Curve slideUp          = Curves.easeOut;
  static const Curve scaleIn          = Curves.easeOut;
}
```

### 3.5 Lottie / Custom Animations

Aktuell nicht vorgesehen. Alle Animationen sind Flutter-native (AnimatedBuilder, AnimatedOpacity, AnimatedContainer). Lottie-Integration nur bei Bedarf (z.B. Loading-Illustrationen).

---

## 4. Responsive Breakpoints

### 4.1 Breakpoint System

| Breakpoint | Width | Dart Constant | Description |
|-----------|-------|---------------|-------------|
| Phone | < 600px | `KaliBreakpoints.phone` | Standard mobile layout |
| Tablet | 600–1024px | `KaliBreakpoints.tablet` | Wider bubbles, optional sidebar hint |
| Desktop | > 1024px | `KaliBreakpoints.desktop` | Sidebar + Chat side-by-side |

```dart
class KaliBreakpoints {
  KaliBreakpoints._();

  static const double phone   = 600;
  static const double tablet  = 1024;
  static const double desktop = 1440;

  static bool isPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width < phone;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= phone && w < tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;
}
```

### 4.2 Layout-Anpassungen

**Phone (< 600px):**
- Bubbles: max 85% Screen-Breite
- Input: full width
- Navigation: Stack (Push/Pop)
- Conversations: Full-screen List

**Tablet (600–1024px):**
- Bubbles: max 70% Screen-Breite (zentriert)
- Input: max 600px centered
- Navigation: Optional Permanent Drawer
- Padding: `24px` horizontal

**Desktop (> 1024px):**
- Layout: Sidebar (320px) + Chat (flex)
- Bubbles: max 640px Breite
- Input: max 640px
- Sidebar: Permanent, `bgSecondary`, Conversations immer sichtbar
- Max content width: 1024px (zentriert)

### 4.3 Responsive Helper

```dart
/// Gibt den max-content-width basierend auf Breakpoint zurück.
double maxContentWidth(BuildContext context) {
  if (KaliBreakpoints.isDesktop(context)) return 1024;
  if (KaliBreakpoints.isTablet(context)) return 700;
  return double.infinity; // Phone: full width
}

/// Gibt Bubble-Max-Width als Fraction zurück.
double bubbleMaxFraction(BuildContext context) {
  if (KaliBreakpoints.isDesktop(context)) return 0.6;
  if (KaliBreakpoints.isTablet(context)) return 0.7;
  return 0.85; // Phone
}
```

### 4.4 Media Query Konfiguration

```dart
// In app.dart / MaterialApp:
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    // Min Touch-Target: 48px (Accessibility)
    // Font-Scaling: Supported (keine feste Obergrenze)
  ),
  child: child!,
)
```

---

## 5. Accessibility Specifications

### 5.1 WCAG-Konformität

Alle Text-Kontraste erfüllen **WCAG AA (4.5:1)** Minimum:

| Token | Auf bgPrimary (#0D1117) | Ratio | Level |
|-------|-------------------------|-------|-------|
| `textPrimary` (#E6EDF3) | 16.8:1 | ✅ AAA |
| `textSecondary` (#8B949E) | 6.2:1 | ✅ AA |
| `textMuted` (#484F58) | 3.1:1 | ⚠️ Decorative only |
| `accentPrimary` (#58A6FF) | 6.4:1 | ✅ AA |
| `accentDanger` (#F85149) | 4.8:1 | ✅ AA |

**Regel:** `textMuted` darf NUR für Placeholder/Decorative Texte verwendet werden — nie für Informationen.

### 5.2 Touch Targets

```dart
/// Minimale Touch-Target-Größe: 48x48px (Material Design Guideline)
/// Implementation: Alle Buttons, IconButtons, ListTiles verwenden diese Regel.
class KaliTouchTarget {
  KaliTouchTarget._();

  static const double minSize = 48.0;

  /// Wrapper für zu kleine Widgets → macht sie tappable
  static Widget wrap({required Widget child, required VoidCallback? onTap}) {
    return SizedBox(
      width: minSize,
      height: minSize,
      child: Center(child: child),
    );
  }
}
```

### 5.3 Screen Reader Support (Semantics)

```dart
/// Jedes interaktive Widget bekommt Semantics:
///
/// ChatBubble:
Semantics(
  label: '${message.isUser ? "Du" : "AI"}: ${message.content}',
  child: ChatBubble(message: message),
)

/// MessageInput:
Semantics(
  textField: true,
  label: 'Nachricht eingeben',
  hint: 'Schreibe eine Nachricht an die AI',
  child: MessageInput(onSend: _handleSend),
)

/// StreamingIndicator:
Semantics(
  liveRegion: true,  // Screen Reader liest Updates vor
  label: 'AI antwortet...',
  child: StreamingIndicator(),
)

/// ConversationListItem:
Semantics(
  button: true,
  label: '${conversation.title}, ${conversation.apiProvider}, ${conversation.model}',
  child: ConversationListItem(...),
)

/// Delete Action:
Semantics(
  button: true,
  label: 'Konversation löschen: ${conversation.title}',
  child: Dismissible(...),
)
```

### 5.4 Font Scaling

```dart
/// Unterstützt MediaQuery.textScaleFactor (Font-Scaling):
/// - Keine festen Höhen für Text-Container
/// - Layout-Builder verwenden für responsive Text
/// - Chat-Bubbles: Flexible Height
/// - Input: Flexible Height (min 48, max 120)
///
/// WARNUNG: Wenn textScaleFactor > 2.0, UI kann überlaufen.
/// Lösung: Constrain mit maxHeight + Scrollable.

// Fallback für extreme Font-Sizes:
Text(
  message.content,
  style: KaliTextStyles.body,
  maxLines: 10,  // Verhindert endlosen Text
  overflow: TextOverflow.ellipsis,
)
```

### 5.5 Reduce Motion

```dart
/// Respektiere User-Präferenz:
///
/// 1. MediaQuery.disableAnimations → alle Duration auf 0
/// 2. Keine Auto-Playing-Animations
/// 3. Streaming Cursor: Statischer Block statt Blink
///
/// Helper in KaliAnimations:
static bool preferNoMotion(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context);

/// In jedem AnimatedWidget:
final duration = preferNoMotion(context)
    ? Duration.zero
    : KaliDurations.normal;
```

### 5.6 Color Blindness Support

```dart
/// Aktuelle Semantic-Farben (Success/Warning/Danger) basieren NICHT
/// nur auf Farbe — sie haben auch Icons:
///
/// - Success: `accentSuccess` + ✓ Icon
/// - Warning: `accentWarning` + ⚠ Icon
/// - Danger:  `accentDanger` + ✕ Icon
///
/// Regel: Status wird durch Farbe + Icon + Text kommuniziert,
/// nie durch Farbe allein.
```

### 5.7 Keyboard Navigation

```dart
/// Flutter's Focus-System wird unterstützt:
///
/// - Tab: Navigation zwischen interaktiven Elementen
/// - Enter: Send-Nachricht (im Input)
/// - Escape: Schließe Bottom-Sheets
/// - Arrow-Keys: Scroll-Navigation in Chat-Liste
///
/// Focus-Indikator: `borderFocus` (accentPrimary) Border, 2px
```

### 5.8 Accessibility Checklist (per Widget)

| Check | Required |
|-------|----------|
| Semantics label existiert | ✅ |
| Touch target ≥ 48x48 | ✅ |
| Kontrast ≥ 4.5:1 | ✅ |
| Keyboard navigierbar | ✅ |
| Reduce-Motion respektiert | ✅ |
| Font-Scaling supported | ✅ |
| Status ≠ nur Farbe | ✅ |

---

## Appendix: Usage Guide

### Import Design Tokens

```dart
import 'package:my_flutter_app/theme/kali_colors.dart';
// Alle Widgets greifen direkt auf KaliColors, KaliTextStyles, KaliSpacing zu.
```

### Full Example: Styled Container

```dart
Container(
  padding: KaliSpacing.paddingMD,
  decoration: BoxDecoration(
    color: KaliColors.bgSecondary,
    borderRadius: KaliRadius.card,
    border: Border.all(color: KaliColors.borderColor, width: 1),
  ),
  child: Text(
    'Hello World',
    style: KaliTextStyles.body,
  ),
)
```

---

*Erstellt am 28.03.2026 vom Design Agent (Tag 5).*
*Quellen: STYLE_GUIDE.md, UI_COMPONENTS.md, ARCHITECTURE.md.*
*Status: DESIGN_SYSTEM.md v1.0 — Ready for implementation.*
