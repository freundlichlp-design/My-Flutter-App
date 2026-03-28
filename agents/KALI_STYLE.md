# KALI_STYLE.md — Kali Brand Personality & Visual Identity

> **Design Agent Tag 6** — Personality-Driven Design Layer
> Basierend auf: DESIGN_SYSTEM.md, STYLE_GUIDE.md, UI_COMPONENTS.md
> Erstellt: 28.03.2026

---

## 1. Kali Brand Identity — Wer ist Kali als App?

### Die Kernfrage

Kali ist kein Chatbot. Kali ist eine **Waffe für Wissen** — ein Multi-API AI Terminal, das aussieht wie ein Messenger, aber fühlt wie ein Hacker-Tool.

### Brand Pillars

| Pilar | Was es bedeutet |
|-------|-----------------|
| **Power** | Kali gibt dir Zugriff auf GPT-4, Claude, Gemini — alle in einem Interface. Kein Bullshit, keine Paywalls im UI. |
| **Control** | Du wählst das Modell. Du siehst die Tokens. Du kontrollierst den Kontext. Kali ist ein Werkzeug, kein Dienst. |
| **Darkness** | Dark-Mode ist kein Feature — es ist die DNA. Kali lebt in der Nacht. Helle UIs sind für E-Commerce. |
| **Precision** | Jedes Pixel sitzt. Kein Overdesign. Keine Deko. Form follows function — aber mit Stil. |
| **Speed** | Streaming-Indikatoren, instant Responses, keine Lade-Screens. Kali ist schnell oder es ist kaputt. |

### Brand Statement

> **Kali ist die App, die du öffnest, wenn du ernst arbeiten willst.** Kein Schnickschnack. Kein Gamification. Schwarzer Hintergrund, blauer Cursor, Antwort kommt. Wie ein Terminal. Aber beautiful.

### Target Vibe

Kali fühlt sich an wie:
- Ein geheimes Hacker-Interface in einem Sci-Fi Film
- VS Code Dark Theme, aber als Messenger
- Das Gegenteil von WhatsApp — kontrolliert, informiert, mächtig
- Ein Tool für Leute, die `curl` ohne Google tippen können

### Naming & Voice

- **Name:** Kali (wie die Hindu-Göttin — Zerstörerin der Ignoranz, Beschützerin des Wissens)
- **Ton:** Direkt. Kein Smalltalk. Sagt was es tut, tut was es sagt.
- **Pronouns:** Es/App — Kali ist kein Mensch, will auch keiner sein
- **Error Messages:** Ehrlich. "API Key fehlt" statt "Oopsie, something went wrong! 🙈"

---

## 2. Signature UI Elements — Was macht Kali einzigartig?

### 2.1 Die Neon-Blaue Pulsader (Accent System)

Kalis `#58A6FF` ist nicht einfach nur eine Akzentfarbe — es ist die **Pulsader der App**. Überall wo diese Farbe auftaucht, fließt Information:

- **Aktiver Chat:** Blauer Cursor blinkt
- **Streaming:** Blauer Puls am unteren Rand
- **Fokus:** Blauer Border um Input
- **Aktive Konversation:** Blauer Link-Text in Sidebar

**Regel:** Neon-Blau = aktiver Datenfluss. Wenn es blau leuchtet, passiert gerade etwas.

### 2.2 Asymmetrische Chat-Bubbles

```
User:  ╭──────────────────╮       (rechts, abgerundet außen)
       │ Hallo Kali       │
       ╰──────────╮       (scharfe Ecke innen)

AI:    ╭───╮                          (links, abgerundet außen)
             │ Hallo, wie kann ich helfen?
             ╰──────────────────────╯  (scharfe Ecke innen)
```

Die **asymmetrischen Radien** (18px außen, 4px innen) sind Kalis visuelle Signatur. Es erzeugt eine Richtung — Nachrichten fließen von links nach rechts, wie Daten durch ein Terminal.

### 2.3 Der Streaming-Cursor `█`

Keine drei Punkte. Kein "AI is typing...". Kalis Streaming-Indikator ist ein **blinkender Block-Cursor** — wie in einem Terminal:

```
█ (500ms ein) (500ms aus)
```

Ergänzt durch eine Status-Leiste unten:
```
● Streaming · 247 tokens · 2.3s
```

Das ist **Kalis Markenzeichen**. User sehen in Echtzeit was passiert — Token für Token.

### 2.4 Provider-Branding im Avatar

Jeder AI-Provider hat seine eigene Farbe im Avatar:
- 🟢 OpenAI: `#10A37F` (Grün)
- 🟠 Claude: `#D97706` (Orange)
- 🔵 Gemini: `#4285F4` (Blau)

Der Avatar zeigt die **Initiale des Modells** (G, C, G) in weiß auf dem farbigen Hintergrund. Sofort erkennbar, welches Modell antwortet.

### 2.5 Der Pill-Input

Das Eingabefeld ist eine **Pill-Form** (24px Radius) — nicht rechteckig, nicht eckig. Es schwebt am unteren Rand wie eine Kommandozeile:

```
┌─────────────────────────────────────────┐
│  Schreibe eine Nachricht...        [▶]  │  ← Pill-Shape, bgTertiary
└─────────────────────────────────────────┘
```

Send-Button: 40px Kreis, `accentPrimary`, wird erst aktiv wenn Text da ist. Davor: `borderColor` (subtil, deaktiviert).

### 2.6 Flat Design mit gezielten Schatten

Kali ist **primär flat** — keine Schatten im Default-Zustand. Schatten nur:
- Modals/Bottom Sheets (subtil, 16px blur)
- Bei Hover auf Cards (optional, 8px blur)

**Philosophie:** Schatten lenken ab. Kali ist clean. Wenn etwas hervorgehoben werden soll, passiert das durch Farbe, nicht durch Elevation.

---

## 3. Personality-Driven Design — Kalis Attitude im UI

### 3.1 Kein Willkommens-Bullshit

Kali zeigt **keinen** onboarding-screen mit "Welcome to Kali! 🎉". Stattdessen:

```
┌────────────────────────────────┐
│                                │
│         [K]                    │  ← Logo, allein, centered
│                                │
│   Wähle ein Modell zuerst.    │  ← Direkte Aufforderung
│                                │
│   ┌──────────────────────┐    │
│   │ GPT-4o · Claude · Gemini│  │  ← Model Selector
│   └──────────────────────┘    │
│                                │
└────────────────────────────────┘
```

**Ton:** Sachlich. Kein Emojis. Kein "Lass uns anfangen!". Kali sagt dir was du tun musst, Punkt.

### 3.2 Error Messages mit Haltung

| Standard-App | Kali |
|-------------|------|
| "Oops! Something went wrong 😅" | "API-Key ungültig. Prüfe deine Settings." |
| "No internet connection!" | "Offline. Keine Verbindung zum Server." |
| "This feature is coming soon!" | "Nicht implementiert." |
| "Rate limit exceeded. Please try again later." | "Rate Limit erreicht. {x} Sekunden warten." |

Kali behandelt Fehler wie ein Compiler — präzise, nüchtern, hilfreich. Kein Gaslighting.

### 3.3 Loading States sind ehrlich

Kein Spinner ohne Kontext. Kali zeigt **immer** was gerade passiert:

```
● Verbinde mit OpenAI...           (1-2s)
● Streaming · 12 tokens · 0.8s    (während Response)
● Antwort komplett · 247 tokens · 3.2s  (fertig)
```

User sollen nie raten müssen ob die App hängt oder arbeitet.

### 3.4 Settings = Config File

Das Settings-Screen fühlt sich an wie eine Konfigurationsdatei:

```
API Keys
─────────────────────────────
OpenAI    sk-•••••••••kE7Q   [👁] [✏️]
Claude    sk-ant-•••••xpL   [👁] [✏️]
Gemini    AIza•••••••wJK8    [👁] [✏️]

Modelle
─────────────────────────────
Standard-Modell    [GPT-4o     ▾]
Streaming          [● An       ○ Aus]
Max Tokens         [4096       ]
```

**Keine** Kategorien wie "Account", "Preferences", "General". Es ist eine Config. Punkt.

### 3.5 Conversations = Filesystem

Die Conversations-Liste fühlt sich an wie ein Datei-Explorer:

```
┌─ Chats ──────────────────────┐
│ 🟢 GPT-4o · Flutter Help     │
│    vor 2 Stunden             │
│                              │
│ 🟠 Claude · Code Review      │
│    Gestern                   │
│                              │
│ 🔵 Gemini · Research         │
│    3 Tage her                │
│                              │
│ 🗑 Swipe zum Löschen         │
└──────────────────────────────┘
```

Conversations sind Einträge in einem Terminal. Keine Thumbnails, keine Preview-Bilder. Titel + Modell + Zeit.

### 3.6 Interactions sind kurz und direkt

- **Tap:** Öffnet Conversation (sofort, 200ms Fade)
- **Long Press:** Copy-to-Clipboard (kein Dialog, direkte Aktion)
- **Swipe:** Delete (roter Hintergrund, kein Confirm-Dialog — Undo via Snackbar)
- **Double Tap:** Keine Aktion (kein Zoom, kein Highlight)

**Regel:** Jede Interaktion hat genau einen Zweck. Keine Multi-Tap-Geheimnisse.

---

## 4. Color Mood — Dark + Neon + Confident

### 4.1 Die Farbphilosophie

Kalis Farbwelt ist ein **nachtaktives Ökosystem**:

```
██████████  bgPrimary (#0D1117)     — Die Nacht selbst
██████████  bgSecondary (#161B22)   — Schatten in der Nacht
██████████  bgTertiary (#21262D)    — Erhellte Bereiche
──────────  borderColor (#30363D)   — Struktur, unsichtbar aber da
░░░░░░░░░░  textSecondary (#8B949E) — Gedämpfte Information
██████████  textPrimary (#E6EDF3)   — Helle Information
▄▄▄▄▄▄▄▄▄▄  accentPrimary (#58A6FF) — Energie, Leben, Datenfluss
```

### 4.2 Farbkontrast als Hierarchie

Kali nutzt **Luminanz-Abstufung** als Informationsebene:

| Ebene | Farbe | Luminanz | Bedeutung |
|-------|-------|----------|-----------|
| 0 | `#0D1117` | 0.7% | Grund, Leere |
| 1 | `#161B22` | 1.3% | Container, Struktur |
| 2 | `#21262D` | 2.2% | Interaktive Fläche |
| 3 | `#30363D` | 3.2% | Trenner, Border |
| 4 | `#484F58` | 4.6% | Inaktiver Text |
| 5 | `#8B949E` | 10% | Sekundärer Text |
| 6 | `#E6EDF3` | 33% | Primärer Text |
| 7 | `#58A6FF` | 22% | **Akzent** — sticht raus |

Der Akzent (`#58A6FF`) hat eine **mittlere Luminanz** — er ist weder zu dunkel noch zu hell. Er sticht aus dem dunklen Grund heraus, blendet aber nicht. Das ist die Balance: **sichtbar, aber nicht schreiend**.

### 4.3 Neon-Effekte (Sparsam einsetzen)

Kali nutzt subtile **Glow-Effekte** für Status-Indikatoren:

```dart
// Streaming-Glow (subtil)
BoxShadow(
  color: KaliColors.accentPrimary.withOpacity(0.15),
  blurRadius: 12,
  spreadRadius: 2,
)

// Success-Pulse
BoxShadow(
  color: KaliColors.accentSuccess.withOpacity(0.2),
  blurRadius: 8,
  spreadRadius: 1,
)
```

**Regel:** Neon nur für Live-Status (Streaming, Connected, Active). Nie für statische Elemente. Es leuchtet = es arbeitet.

### 4.4 Farbverbote

| ❌ Nie verwenden | Warum |
|------------------|-------|
| Weißer Hintergrund | Kali ist dunkel. Immer. |
| Pastell-Töne | Zu soft. Kali ist hart. |
| Regenbogen-Gradienten | Overdesign. Kali ist monochrom mit Akzent. |
| Gelb als Text | Schlechter Konstrast auf Schwarz |
| Rot für "neutrale" Aktionen | Rot = Gefahr/Löschen, nicht "Abbrechen" |

### 4.5 Provider-Farben als Identifikation

Die drei Provider-Farben erzählen eine Geschichte:

- 🟢 **Grün (#10A37F)** = OpenAI — etabliert, zuverlässig, der Standard
- 🟠 **Orange (#D97706)** = Claude — warm, direkt, menschlich
- 🔵 **Blau (#4285F4)** = Gemini — Google's Antwort, kühl, technisch

Diese Farben tauchen **ausschließlich** in Avatars und Model-Selector auf — nie im App-Hintergrund. Sie sind Gäste in Kalis dunklem Raum.

---

## 5. Typography Voice — Bold + Direct

### 5.1 Schriften als Persönlichkeit

**Inter** ist nicht zufällig gewählt. Inter ist:
- Gebaut für Bildschirme (nicht für Print)
- Hohe x-Höhe = bessere Lesbarkeit bei kleinen Größen
- Neutral genug um nicht aufzufallen — professionell genug um Vertrauen zu schaffen
- Die Schrift von GitHub, Linear, Vercel — Tools die Developer benutzen

**JetBrains Mono** für Code ist ebenfalls ein Statement:
- Die beliebteste IDE-Schrift der Welt
- Gebaut für Code-Readability
- Ligaturen optional (aber supported)

### 5.2 Typografie-Hierarchie als Befehlsstruktur

Kalis Text-Hierarchie spiegelt eine **Befehlshierarchie** wider:

```
HEADLINE (24px, w700)          — Befehl. Screen-Titel. Unmissverständlich.
  └─ SUBTITLE (18px, w600)    — Unterkommando. Section-Header.
       └─ BODY (15px, w400)   — Information. Chat-Nachrichten.
            └─ CAPTION (12px) — Metadaten. Timestamps. Nebensächlich.
```

### 5.3 Weight als Tonfall

| Weight | Verwendung | Tonfall |
|--------|-----------|---------|
| `w700` (Bold) | Headlines, Wichtige Buttons | **Bestimmt. Aufmerksamkeit.** |
| `w600` (SemiBold) | Subtitles, Hervorhebungen | **Wichtig, aber nicht schreiend.** |
| `w500` (Medium) | Labels, Buttons, Nav | **Sachlich. Handlungsaufforderung.** |
| `w400` (Regular) | Body, Fließtext | **Ruhig. Informierend.** |

**Regel:** Kali nutzt **weniger als 4 Weights**. Kein Thin, kein ExtraBold. Klarheit durch Einschränkung.

### 5.4 Text-Verhalten in Chat-Bubbles

**User-Nachrichten:**
- Weißer Text (`#FFFFFF`) auf blauem Grund
- Keine Markdown-Formatierung (User tippt plain text)
- Links werden nicht auto-erkannt (User will schreiben, nicht formatieren)

**AI-Nachrichten:**
- Heller Text (`#E6EDF3`) auf dunklem Grund
- **Full Markdown** — Bold, Italic, Code, Listen, Headings
- Code-Blöcke: `JetBrains Mono`, `bgPrimary` Hintergrund, `borderColor` Border
- Inline-Code: gleiche Schrift, `bgTertiary` Hintergrund, 4px Radius

### 5.5 Typografie-Verbote

| ❌ Nie | Warum |
|--------|-------|
| Text < 12px | Unleserlich. Accessibility. |
| Text auf Farbe ohne Kontrastcheck | WCAG AA = 4.5:1 Minimum |
| Serif-Schriften | Kali ist Tech, nicht Literatur |
| Decorative/Display Fonts | Overdesign |
| Blocksatz | Unnatürlich in UI-Text |
| TEXT IN ALLCAPS (außer Headlines) | SCHREIEN IST KEIN DESIGN |
| Mehr als 2 Schriftfamilien | Inter + JetBrains Mono. Punkt. |

### 5.6 Lebende Typografie

Kalis Text ist nicht statisch:

- **Streaming-Text** erscheint Wort für Wort, Cursor blinkt am Ende
- **Fehler-Text** erscheint mit 200ms Fade-In, rote Farbe
- **Timestamps** aktualisieren sich (gerade eben → vor 2 Minuten → vor 1 Stunde)
- **Token-Counts** zählen hoch während Streaming

Text lebt in Kali. Es ist nie nur statisch auf dem Screen.

---

## Appendix: Quick Reference

### Brand in 5 Sätzen

1. Kali ist dunkel. Immer.
2. Kali ist direkt. Kein Smalltalk.
3. Kali zeigt was passiert. Immer.
4. Kali ist ein Werkzeug, kein Dienst.
5. Blau = Energie. Schwarz = Nacht. Weiß = Information.

### Design-Mantra

> **"Dark. Direct. Deadly accurate."**

### Emoji-Guide (für Brand-Kommunikation)

| Emoji | Bedeutung |
|-------|-----------|
| 🛡️ | Kali (Logo/Identity) |
| ⚡ | Streaming / Speed |
| 🔑 | API Keys / Security |
| 🌙 | Dark Mode / Nacht |
| 🤖 | AI / Models |

### Was Kali NICHT ist

- ❌ Ein "AI Friend" — Kali ist ein Tool
- ❌ Ein Social Network — Kali hat keine Follower
- ❌ Ein Spiel — Kali hat keine Achievements
- ❌ Ein Assistent — Kali fragt nicht "wie kann ich helfen?"
- ❌ Ein Produkt — Kali ist ein Interface

---

*Erstellt am 28.03.2026 vom Design Agent (Tag 6).*
*Quellen: DESIGN_SYSTEM.md, STYLE_GUIDE.md, UI_COMPONENTS.md.*
*Status: KALI_STYLE.md v1.0 — Brand Personality Layer.*
