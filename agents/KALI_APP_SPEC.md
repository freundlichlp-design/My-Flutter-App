# KALI_APP_SPEC.md — Vollständige App-Spec für Kilo Code

> Erstellt: 29.03.2026
> Basierend auf: STYLE_GUIDE.md, FEATURES.md, DESIGN_SYSTEM.md, KALI_RICHTUNG.md, 83 existierenden Dart Files
> Zweck: Alles was Kilo Code wissen muss um die App fertigzubauen

---

## 🛡️ WAS IST KALI?

Kali ist eine **Multi-AI Chat App** — nicht ChatGPT, nicht Claude, nicht Gemini. **Alle** in einer App, schwarzer Hintergrund, direkte Antworten, eigene Persönlichkeit.

**Mantra:** "Dark. Direct. Deadly accurate."

**Target:** Power User, Developer, Leute die wissen was sie tun.

---

## 📊 AKTUELLER STAND (83 Dart Files)

### ✅ Bereits gebaut:
- Multi-Provider Support (OpenAI, Gemini, Claude)
- Dark Theme mit Kali-Farbsystem
- Chat UI mit Bubbles
- Memory System (Hive Storage)
- Emotion Engine
- Voice Service
- Subscription System
- Settings Provider
- Models: Message, MemoryEntry, PrivacySettings, Subscription

### ⚠️ Bekannte Bugs (aus BUGS.md):
- Siehe `agents/BUGS.md` für vollständige Liste
- 13 Bugs dokumentiert vom Bug Agent
- 7 Sicherheitslücken vom Security Agent

---

## 🎯 WAS FEHLT (Priorisiert)

### Phase 1: Kali's Identity (SOFORT)
| # | Feature | Datei(en) | Beschreibung |
|---|---------|-----------|--------------|
| 1 | **Streaming Cursor █** | `lib/features/chat/widgets/streaming_cursor.dart` | Terminal-Block-Cursor, blinkt 500ms. Kalis Markenzeichen. |
| 2 | **Provider Avatare** | `lib/features/chat/widgets/provider_avatar.dart` | Grün=OpenAI, Orange=Claude, Blau=Gemini. Mit Modell-Initial. |
| 3 | **Asymmetrische Bubbles** | `lib/features/chat/widgets/chat_bubble.dart` | 18px außen, 4px innen. Pfeil-Richtung. |
| 4 | **Pill Input** | `lib/features/chat/widgets/pill_input.dart` | Volle Pill-Form (24px). Fühlt sich an wie Kommandozeile. |
| 5 | **Config Settings** | `lib/features/settings/screens/config_settings_screen.dart` | Flat Key-Value-Liste wie Config-Datei. |

### Phase 2: Kali's Brain (NÄCHSTE)
| # | Feature | Datei(en) | Beschreibung |
|---|---------|-----------|--------------|
| 6 | **Personality Switch** | `lib/features/personality/` | Kali Default, Zen, Nerd, Creative. System-Prompt pro Persönlichkeit. |
| 7 | **Model Selector** | `lib/features/chat/widgets/model_selector.dart` | Dropdown mit allen verfügbaren Modellen. |
| 8 | **Reply/Edit/Delete** | `lib/features/chat/actions/` | Swipe-to-Delete (ohne Confirm), Reply auf Nachrichten, Edit eigene Nachrichten. |
| 9 | **Error Messages** | `lib/core/errors/kali_error_handler.dart` | "API-Key ungültig. Settings → API Keys." — Kein "Something went wrong". |
| 10 | **Token Counter** | `lib/features/chat/widgets/token_counter.dart` | Live-Anzeige: "Streaming · 247 tokens · 2.3s" |

### Phase 3: Kali's Power (SPÄTER)
| # | Feature | Beschreibung |
|---|---------|--------------|
| 11 | **Model Compare** | Frage an GPT + Claude + Gemini gleichzeitig, vergleiche Antworten nebeneinander. |
| 12 | **Memory Toggle** | Ein/Aus für Memory pro Chat. Privacy-Feature. |
| 13 | **Voice Toggle** | Handsfreier Modus mit TTS. |
| 14 | **Chat Search** | Suche in allen Chats. |
| 15 | **Image Generation** | DALL-E / Stable Diffusion Integration. |
| 16 | **Export** | Chat als Markdown/PDF exportieren. |

---

## 🎨 DESIGN SYSTEM (Auszug)

### Farben (Dark Only)
```
bgPrimary:    #0D1117
bgSecondary:  #161B22
bgTertiary:   #21262D
textPrimary:  #E6EDF3
textSecondary:#8B949E
accentPrimary:#58A6FF
bubbleUser:   #1F6FEB
bubbleAi:     #21262D
```

### Provider Farben
```
OpenAI:  #10A37F (Grün)
Claude:  #D97706 (Orange)
Gemini:  #4285F4 (Blau)
```

### Typography
- UI: Inter / SF Pro
- Code: JetBrains Mono
- Headlines: Bold, 24px
- Body: Regular, 16px
- Caption: 12px, textSecondary

### Komponenten
- Bubbles: Asymmetrisch (18px außen, 4px innen)
- Input: Pill-Form (24px Radius)
- Buttons: Ghost Style, kein Fill
- Cards: bgSecondary, borderColor Border

---

## 🔌 API INTEGRATIONEN

| Service | Zweck | Status |
|---------|-------|--------|
| OpenAI API | GPT-4, GPT-4o, DALL-E | ✅ Implementiert |
| Anthropic API | Claude 3.5 Sonnet | ✅ Implementiert |
| Google AI | Gemini Pro | ✅ Implementiert |
| Hive | Lokaler Storage | ✅ Implementiert |
| SharedPreferences | Settings | ✅ Implementiert |
| flutter_secure_storage | API Keys | ✅ Implementiert |

---

## 📱 SCREEN MAP

```
lib/
├── main.dart                    # App Entry
├── core/
│   ├── errors/                  # Error Handling
│   ├── constants/               # App Constants
│   └── utils/                   # Helpers
├── theme/
│   ├── kali_colors.dart         # ✅ Done
│   ├── kali_text_styles.dart    # ✅ Done
│   ├── kali_spacing.dart        # ✅ Done
│   └── app_theme.dart           # ✅ Done
├── features/
│   ├── chat/
│   │   ├── screens/
│   │   │   └── chat_screen.dart # ✅ Main Chat
│   │   └── widgets/
│   │       ├── chat_bubble.dart     # ⚠️ Needs asymmetry
│   │       ├── streaming_cursor.dart # ❌ TODO
│   │       ├── provider_avatar.dart  # ❌ TODO
│   │       ├── pill_input.dart       # ❌ TODO
│   │       ├── token_counter.dart    # ❌ TODO
│   │       └── model_selector.dart   # ❌ TODO
│   ├── settings/
│   │   └── screens/
│   │       └── settings_screen.dart # ⚠️ Needs Config style
│   ├── personality/             # ❌ TODO
│   ├── memory/                  # ✅ Partially done
│   └── search/                  # ❌ TODO
├── services/
│   ├── openai_service.dart      # ✅ Done
│   ├── claude_service.dart      # ✅ Done
│   ├── gemini_service.dart      # ✅ Done
│   └── voice_service.dart       # ✅ Done
├── providers/
│   ├── chat_provider.dart       # ✅ Done
│   ├── settings_provider.dart   # ✅ Done
│   └── memory_provider.dart     # ✅ Done
├── models/
│   ├── message.dart             # ✅ Done
│   ├── memory_entry.dart        # ✅ Done
│   └── subscription.dart        # ✅ Done
├── storage/
│   ├── hive_storage.dart        # ✅ Done
│   └── memory_storage.dart      # ✅ Done
└── routing/
    └── app_router.dart          # ✅ Done
```

---

## 🐛 WAS FIXEN MUSS

1. Siehe `agents/BUGS.md` — 13 Bugs
2. Siehe `agents/SECURITY.md` — 7 Sicherheitslücken
3. Siehe `agents/BUGS_DESIGN.md` — Design-Inkonsistenzen

---

## 📋 FÜR KILO CODE — TASK FORMAT

### Task Template:
```markdown
## TASK: [Feature Name]
**Priority:** P1 (Sofort) | P2 (Nächste) | P3 (Später)
**Files:** [Liste der betroffenen Dateien]

### Was bauen:
[Detailierte Beschreibung]

### Design Specs:
[Farben, Spacing, Typography aus STYLE_GUIDE.md]

### Acceptance Criteria:
- [ ] Feature funktioniert
- [ ] Dark Theme
- [ ] Keine Bugs
- [ ] Code Review bestanden

### Referenz:
[Link zu STYLE_GUIDE.md, DESIGN_SYSTEM.md, etc.]
```

---

## 🚀 NÄCHSTE SCHRITTE

1. **Agent 2 (Bug Agent)** — Alle 13 Bugs reproduzieren und fixen
2. **Agent 3 (Design Agent)** — Phase 1 Features bauen (Streaming Cursor, Provider Avatar, etc.)
3. **Agent 4 (Feature Agent)** — Phase 2 Features spezifizieren
4. **Kali** — Tasks auf GitHub erstellen für Kilo Code

---

*Spec Version: 1.0*
*Letztes Update: 29.03.2026 19:34 UTC*
*Status: Bereit für Agenten-Durchlauf*
