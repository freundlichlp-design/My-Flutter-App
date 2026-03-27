# STYLE GUIDE - Kali Chat App

> Design System für die Kali Chat App — eine Multi-API AI Chat Applikation mit Flutter.

---

## 1. Color Palette

### Dark Theme (Primary — Kali Security Vibe)

| Name | Hex | Verwendung |
|------|-----|-----------|
| `bgPrimary` | `#0D1117` | App-Hintergrund |
| `bgSecondary` | `#161B22` | Chat-Fläche, Cards |
| `bgTertiary` | `#21262D` | Input-Feld, Modals |
| `borderColor` | `#30363D` | Trennlinien, Borders |
| `textPrimary` | `#E6EDF3` | Haupttext |
| `textSecondary` | `#8B949E` | Timestamps, Labels |
| `textMuted` | `#484F58` | Platzhalter, deaktiviert |
| `accentPrimary` | `#58A6FF` | Links, aktive Elemente, AI-Status |
| `accentSuccess` | `#3FB950` | Streaming on, Connected |
| `accentWarning` | `#D29922` | Warnungen |
| `accentDanger` | `#F85149` | Fehler, Disconnect |

### Chat-Bubble Spezifisch

| Name | Hex | Verwendung |
|------|-----|-----------|
| `bubbleUser` | `#1F6FEB` | User-Nachrichten Hintergrund |
| `bubbleUserText` | `#FFFFFF` | User-Nachrichten Text |
| `bubbleAi` | `#21262D` | AI-Nachrichten Hintergrund |
| `bubbleAiText` | `#E6EDF3` | AI-Nachrichten Text |
| `bubbleAiBorder` | `#30363D` | AI-Bubble Border (subtil) |

### Provider-Spezifische Akzente (Settings/Model-Selector)

| Name | Hex | Verwendung |
|------|-----|-----------|
| `openAiGreen` | `#10A37F` | OpenAI Branding |
| `claudeOrange` | `#D97706` | Claude/Anthropic Branding |
| `geminiBlue` | `#4285F4` | Gemini Branding |

---

## 2. Typography

**Font Family:** `Inter` (system fallback: `SF Pro Display` / `Roboto`)

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| `headline` | 24px | `w700` | Screen Titles ("Chat", "Settings") |
| `subtitle` | 18px | `w600` | Section Headers, Conversation Titles |
| `body` | 15px | `w400` | Chat-Nachrichten Text |
| `bodyBold` | 15px | `w600` | Inline Hervorhebungen |
| `caption` | 12px | `w400` | Timestamps, Token-Counts |
| `label` | 13px | `w500` | Buttons, Labels, Nav |
| `code` | 13px | `w400` | Inline Code in Messages (Monospace: `JetBrains Mono`) |

**Line Heights:**
- Headline: 1.3x
- Body: 1.5x (wichtig für lesbarkeit bei langen AI-Responses)
- Caption: 1.4x

---

## 3. Spacing System

**Base Unit:** `8px`

| Token | Value | Usage |
|-------|-------|-------|
| `space.xs` | 4px | Inline-Elemente, Icons |
| `space.sm` | 8px | Inneres Padding kleine Elemente |
| `space.md` | 16px | Standard Padding, Gap |
| `space.lg` | 24px | Section Spacing |
| `space.xl` | 32px | Screen Padding Top/Bottom |
| `space.xxl` | 48px | Major Sections |

---

## 4. Chat Bubble Design

### User Messages

```
┌─────────────────────────────────────┐
│                                     │
│  ┌──────────────────────────────┐   │
│  │  Hey, was ist SSE Streaming? │   │
│  └──────────────────────────────┘   │
│        align: right                  │
│                                     │
```

| Property | Value |
|----------|-------|
| Background | `bubbleUser` (#1F6FEB) |
| Text Color | `bubbleUserText` (#FFFFFF) |
| Border Radius | `18px` (oben-links, oben-rechts, unten-links) / `4px` unten-rechts (speech tail) |
| Max Width | `85%` der Screen-Breite |
| Padding | `12px vertical`, `16px horizontal` |
| Margin | `space.xs` zwischen Bubbles |
| Font | `body` 15px w400 |
| Alignment | Rechts-bündig |
| Shadow | Kein Schatten (flat design) |

### AI Messages

```
┌─────────────────────────────────────┐
│  🤖                                 │
│  ┌──────────────────────────────┐   │
│  │ SSE steht für Server-Sent    │   │
│  │ Events...                    │   │
│  └──────────────────────────────┘   │
│  12:34 · gpt-4o · 42 tokens        │
│        align: left                   │
```

| Property | Value |
|----------|-------|
| Background | `bubbleAi` (#21262D) |
| Text Color | `bubbleAiText` (#E6EDF3) |
| Border | `1px solid` `bubbleAiBorder` (#30363D) |
| Border Radius | `18px` (oben-links, oben-rechts, unten-rechts) / `4px` unten-links |
| Max Width | `85%` der Screen-Breite |
| Padding | `12px vertical`, `16px horizontal` |
| Margin | `space.xs` zwischen Bubbles |
| Font | `body` 15px w400 |
| Alignment | Links-bündig |
| Metadata | Caption-Font unter Bubble: `Timestamp · Model · Tokens` |

### Code Blocks in AI Messages

| Property | Value |
|----------|-------|
| Background | `#0D1117` (dunkler als Bubble) |
| Border Radius | `8px` |
| Padding | `12px` |
| Font | `JetBrains Mono` 13px |
| Syntax Highlighting | Optional, GitHub-Dark-Theme |

### Markdown Styling

| Element | Style |
|---------|-------|
| Headings | `bodyBold`, Farbe: `textPrimary` |
| Bold | `bodyBold`, Farbe: `textPrimary` |
| Inline Code | Background: `bgPrimary`, Radius: `4px`, Padding: `2px 6px` |
| Links | Farbe: `accentPrimary`, unterstrichen |
| Lists | Einzug: `space.md`, Marker: `•` |

---

## 5. Streaming Indicator Design

### Typing Animation (während AI streamed)

```
  ┌──────────────────────────────┐
  │  █                           │  ← Blinkender Cursor
  └──────────────────────────────┘
```

**Option A — Blinkender Cursor (EMPFOHLEN)**

| Property | Value |
|----------|-------|
| Character | `█` (Block Cursor) |
| Color | `accentPrimary` (#58A6FF) |
| Animation | `opacity: 0.0 → 1.0`, Duration: `500ms` |
| Curve | `Curves.easeInOut` |
| Repeat | Endlos bis Stream endet |

**Option B — Drei-Punkt Animation (Fallback)**

```
  🤖 · · ·
```

| Property | Value |
|----------|-------|
| Dots | 3 Punkte, `8px` Durchmesser |
| Color | `textSecondary` (#8B949E) |
| Spacing | `4px` zwischen Punkten |
| Animation | Sequential bounce, je `300ms` versetzt |
| Curve | `Curves.easeOut` |

### Stream Status Bar

```
┌──────────────────────────────────────┐
│  ● Streaming... · 42 tokens · 2.1s  │
└──────────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| Position | Über der Input-Bar, sticky |
| Background | `bgTertiary` (#21262D) |
| Height | `32px` |
| Padding | `space.sm` horizontal |
| Dot Color | `accentSuccess` (#3FB950) — pulsierend |
| Text Font | `caption` 12px |
| Text Color | `textSecondary` |
| Border | Top: `1px` `borderColor` |
| Animation | Dot: `opacity 0.5 → 1.0`, `800ms`, loop |

### Ein-/Ausblenden

| Property | Value |
|----------|-------|
| Show | `AnimatedOpacity` `0 → 1`, `200ms` |
| Hide | `AnimatedOpacity` `1 → 0`, `150ms` |
| Condition | Visible wenn `ChatProvider.isStreaming == true` |

---

## 6. Input Field Design

```
┌──────────────────────────────────────┐
│  Schreibe eine Nachricht...    [➤]  │
└──────────────────────────────────────┘
```

| Property | Value |
|----------|-------|
| Background | `bgTertiary` (#21262D) |
| Border Radius | `24px` |
| Border | `1px solid` `borderColor` |
| Border (focused) | `1px solid` `accentPrimary` |
| Padding | `12px horizontal`, `space.sm` vertical |
| Text Font | `body` 15px |
| Placeholder Color | `textMuted` (#484F58) |
| Send Button | Circle, `40px`, `accentPrimary` bg |
| Send Icon | `Icons.send`, white, `20px` |
| Min Height | `48px` |
| Max Height | `120px` (scrollbar bei langen Inputs) |

---

## 7. Conversation List Design

| Property | Value |
|----------|-------|
| Item Height | `72px` |
| Background | `bgSecondary` |
| Selected Background | `bgTertiary` |
| Title Font | `subtitle` 18px w600 |
| Subtitle Font | `caption` 12px (letzte Message, truncate) |
| Avatar | Model-Icon (OpenAI/Claude/Gemini) oder `🤖` |
| Swipe Actions | Delete (rot), Archive (blau) |
| Divider | `1px` `borderColor` |

---

## 8. Iconography

| Icon | Usage |
|------|-------|
| `Icons.chat_bubble_outline` | App Logo / Empty State |
| `Icons.send` | Send Button |
| `Icons.add` | Neue Conversation |
| `Icons.settings` | Settings |
| `Icons.delete_outline` | Delete |
| `Icons.copy` | Message kopieren |
| `Icons.refresh` | Retry Message |
| `Icons.stop_circle` | Streaming stoppen |

---

## 9. Dark Mode First

Die App ist **Dark-Mode-First**. Light Mode ist ein späteres Stretch-Goal. Alle Farben oben sind für Dark Mode definiert.

**Grund:** AI-Chat-Apps werden primär abends/lang genutzt. Dark Mode ist erwartet.

---

## 10. Responsive Breakpoints

| Breakpoint | Width | Anpassung |
|-----------|-------|-----------|
| Phone | < 600px | Standard Layout |
| Tablet | 600–1024px | Bubbles max 70% Breite |
| Desktop | > 1024px | Sidebar + Chat nebeneinander |

---

## 11. Animation Guidelines

| Context | Duration | Curve |
|---------|----------|-------|
| Screen Transitions | `300ms` | `Curves.easeOutCubic` |
| Bubble Einblenden | `200ms` | `Curves.easeOut` |
| Streaming Cursor | `500ms` | `Curves.easeInOut` (loop) |
| Loading Spinner | `1000ms` | `Curves.linear` (loop) |
| Bottom Sheet | `250ms` | `Curves.easeOutQuart` |

---

## 12. Accessibility

- **Kontrast:** Alle Texte mindestens WCAG AA (4.5:1)
- **Touch Targets:** Mindestens `48x48px`
- **Semantics:** `Semantics` Widgets für Screen Reader
- **Font Scaling:** Unterstütze `MediaQuery.textScaleFactor`
- **Reduce Motion:** Respektiere `MediaQuery.disableAnimations`

---

*Erstellt am 27.03.2026 vom Design Agent.*
*Basierend auf TASKS.md und FEEDBACK.md.*
