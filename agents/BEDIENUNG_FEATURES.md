# BEDIENUNG_FEATURES.md — User-Facing Feature Specification

> **Zweck:** Vollständige Spezifikation aller Features die der User bedienen kann.
> **Status:** Living Document — wird bei Feature-Updates aktualisiert.
> **Priorisierung:** 🔴 Hoch | 🟡 Mittel | 🟢 Low

---

## 1. 💬 Chat Features

### 1.1 Reply (Zitieren)
- **Status:** 🔴 Hoch
- **Beschreibung:** User kann eine Nachricht zitieren und darauf antworten.
- **UI:** Swipe-right auf Nachricht oder Long-Press → Reply-Button
- **Verhalten:**
  - Zitierte Nachricht wird als Preview über dem Input angezeigt
  - Tap auf Zitat → scrollt zur Original-Nachricht
  - Zitat zeigt: Avatar, Name, Text-Vorschau (max 2 Zeilen)
- **Daten:**
  - `replyTo: MessageId` im Message-Model
  - Quote-Preview wird clientseitig gerendert

### 1.2 Edit (Bearbeiten)
- **Status:** 🔴 Hoch
- **Beschreibung:** User kann eigene gesendete Nachrichten bearbeiten.
- **UI:** Long-Press → Edit-Button (nur eigene Nachrichten)
- **Verhalten:**
  - Nachricht wird in den Input geladen
  - Nach Senden: Original wird ersetzt, "(edited)" Tag angezeigt
  - Edit-History wird gespeichert (für Audit)
  - AI-Responses auf editierte Nachricht: neu generieren optional
- **Daten:**
  - `editedAt: DateTime?` im Message-Model
  - `editHistory: List<String>?` für Originaltext

### 1.3 Delete (Löschen)
- **Status:** 🔴 Hoch
- **Beschreibung:** User kann Nachrichten löschen.
- **UI:** Long-Press → Delete-Button
- **Optionen:**
  - "Für mich löschen" — Nachricht bleibt für AI
  - "Für alle löschen" — Nachricht wird komplett entfernt
- **Verhalten:**
  - Confirmation Dialog vor dem Löschen
  - Gelöschte Nachricht: "Diese Nachricht wurde gelöscht" Placeholder
  - Zugehörige AI-Responses werden markiert (nicht gelöscht)
- **Daten:**
  - `deletedAt: DateTime?` im Message-Model
  - `deletedFor: List<String>?` (userId-basiert)

### 1.4 Copy (Kopieren)
- **Status:** 🟡 Mittel
- **Beschreibung:** User kann Nachrichten-Text in die Zwischenablage kopieren.
- **UI:** Long-Press → Copy-Button oder Tap auf Nachricht
- **Optionen:**
  - "Text kopieren" — Plain Text
  - "Als Markdown kopieren" — mit Formatting
  - "Code kopieren" — bei Code-Blöcken separat
- **Verhalten:**
  - Visuelles Feedback (Snackbar: "Kopiert!")
  - Bilder: URL kopieren

### 1.5 Share (Teilen)
- **Status:** 🟢 Low
- **Beschreibung:** User kann Nachrichten extern teilen.
- **UI:** Long-Press → Share-Button
- **Optionen:**
  - Share als Text (andere Apps)
  - Share als Bild (Screenshot-Generierung)
  - Share als Link (wenn Backend-URL verfügbar)
- **Verhalten:**
  - Native Share Sheet (iOS/Android)
  - Formatiert mit: Zitat, Timestamp, optional Kontext

---

## 2. 📋 Conversation Features

### 2.1 Pin Conversation
- **Status:** 🔴 Hoch
- **Beschreibung:** User kann wichtige Chats oben anpinnen.
- **UI:** Swipe-left auf Conversation → Pin oder Long-Press → Pin
- **Verhalten:**
  - Max 5 gepinnte Conversations
  - Pin-Icon neben dem Chat-Namen
  - Gepinnte Chats immer oben, sortiert nach Pin-Datum
  - Erneutes Pin → Unpin
- **Daten:**
  - `pinnedAt: DateTime?` im Conversation-Model
  - `pinOrder: int?` für Sortierung

### 2.2 Archive Conversation
- **Status:** 🟡 Mittel
- **Beschreibung:** User kann Chats archivieren (ausblenden ohne zu löschen).
- **UI:** Swipe-left → Archive oder Multi-Select → Archive
- **Verhalten:**
  - Archivierte Chats verschwinden aus der Hauptliste
  - "Archiviert"-Sektion am Ende der Chat-Liste
  - Neue Nachricht in archiviertem Chat → automatisch unarchiviert
  - Batch-Archive möglich
- **Daten:**
  - `archivedAt: DateTime?` im Conversation-Model

### 2.3 Search Conversations & Messages
- **Status:** 🔴 Hoch
- **Beschreibung:** User kann durch alle Chats und Nachrichten suchen.
- **UI:** Search-Icon in AppBar → Search-Screen
- **Features:**
  - **Global Search:** Durch alle Conversations
  - **Local Search:** Innerhalb eines Chats
  - **Filter:** Nach Datum, Sender (User/AI), Message-Type
  - **Highlight:** Suchbegriffe werden in Ergebnissen hervorgehoben
- **Verhalten:**
  - Debounced Search (300ms)
  - Max 50 Ergebnisse pro Suche
  - Tap auf Ergebnis → springt zur Nachricht
- **Daten:**
  - Full-Text-Search über SQLite FTS5 oder clientseitige Indexierung

### 2.4 Sort Conversations
- **Status:** 🟡 Mittel
- **Beschreibung:** User kann die Chat-Liste sortieren.
- **Sortieroptionen:**
  - **Neueste zuerst** (Default) — nach letzter Nachricht
  - **Älteste zuerst** — nach Erstellungsdatum
  - **Alphabetisch** — nach Titel
  - **Nach Modell** — gruppiert nach AI-Modell
- **UI:** Dropdown oder Filter-Chips oben in der Chat-Liste
- **Daten:**
  - Sortierung clientseitig über Conversation-Metadaten

---

## 3. ⚙️ Settings Features

### 3.1 Model Select (Modell-Auswahl)
- **Status:** 🔴 Hoch
- **Beschreibung:** User kann das AI-Modell pro Chat oder global auswählen.
- **UI:** Settings → Model Select oder per-Chat im AppBar
- **Modelle (Beispiel):**
  - GPT-4o, GPT-4o-mini
  - Claude 3.5 Sonnet, Claude 3 Opus
  - Gemini 1.5 Pro
  - Lokale Modelle (Ollama)
- **Verhalten:**
  - Default-Modell in Settings konfigurierbar
  - Per-Chat Override möglich
  - Modell-Wechsel während laufendem Chat: nächste Antwort nutzt neues Modell
  - Token-Kosten/Info pro Modell anzeigen
- **Daten:**
  - `defaultModel: String` in Settings
  - `modelOverride: String?` in Conversation

### 3.2 Theme Toggle (Design-Modus)
- **Status:** 🔴 Hoch
- **Beschreibung:** User kann zwischen Light, Dark und System-Theme wechseln.
- **UI:** Settings → Theme oder Quick-Toggle in AppBar
- **Optionen:**
  - ☀️ Light Mode
  - 🌙 Dark Mode
  - 📱 System (folgt OS-Einstellung)
- **Verhalten:**
  - Smooth-Transition beim Wechsel (300ms)
  - Akzentfarbe bleibt in beiden Modi konsistent
  - Chat-Hintergrund optional anpassbar
- **Daten:**
  - `themeMode: ThemeMode` in Settings (local storage)
  - Material Design 3 Theme System

### 3.3 Export Chat
- **Status:** 🟡 Mittel
- **Beschreibung:** User kann Conversations exportieren.
- **UI:** Chat-Menu → Export oder Settings → Export All
- **Export-Formate:**
  - **JSON** — Vollständige Datenstruktur (inkl. Metadaten)
  - **Markdown** — Menschlich lesbar, mit Timestamps
  - **Plain Text** — Nur Text-Inhalt
  - **PDF** — Formatiert mit Styling (Premium)
- **Verhalten:**
  - Export-Option pro Chat oder alle Chats
  - Progress-Indicator bei großen Exports
  - Share Sheet nach Export
- **Daten:**
  - Export-Service nutzt bestehende Message-Daten
  - PDF: `pdf` Package oder Native-Printing

### 3.4 Clear History
- **Status:** 🟡 Mittel
- **Beschreibung:** User kann Chat-History löschen.
- **UI:** Settings → Clear History oder per-Chat → Clear
- **Optionen:**
  - "Diesen Chat löschen" — eine Conversation
  - "Alle Chats löschen" — alles weg
  - "Nur Nachrichten behalte Chats" — leert Nachrichten, behält Struktur
- **Verhalten:**
  - **KRITISCH:** Confirmation Dialog mit Warnung
  - "Tippe 'LÖSCHEN' um zu bestätigen" — Safety-Mechanismus
  - Backup-Prompt: "Möchtest du vorher exportieren?"
  - Undo-Option (10 Sekunden)
- **Daten:**
  - Cascade Delete: Conversation → Messages → Attachments
  - Undo über Soft-Delete (`deletedAt` Timestamp)

---

## 4. 🛡️ Kali Features (AI Personality)

### 4.1 Personality Switch (Persönlichkeit)
- **Status:** 🔴 Hoch
- **Beschreibung:** User kann Kalis Persönlichkeit/Verhalten anpassen.
- **UI:** Settings → Kali Personality oder per-Chat im AppBar
- **Persönlichkeiten:**
  - 🔥 **Kali Default** — Sassy, direkt, hilfreich
  - 🧘 **Zen** — Ruhig, reflektiert, minimalistisch
  - 🤓 **Nerd** — Technisch, detailliert, analytisch
  - 🎭 **Creative** — Kreativ, bildlich, assoziativ
  - 📋 **Professional** — Formal, strukturiert, Business
  - 🎨 **Custom** — User-definiertes System-Prompt
- **Verhalten:**
  - Switch während laufendem Chat möglich
  - System-Prompt wird dynamisch angepasst
  - Persönlichkeit wird per-Chat gespeichert
  - "Custom" zeigt Editor für System-Prompt
- **Daten:**
  - `personality: String` in Conversation-Settings
  - System-Prompt Templates als Assets

### 4.2 Memory Toggle (Gedächtnis)
- **Status:** 🟡 Mittel
- **Beschreibung:** User kann Kalis Memory/Context-Fenster steuern.
- **UI:** Settings → Memory oder per-Chat Toggle
- **Optionen:**
  - **Memory ON** — Kali erinnert sich an vorherige Nachrichten
  - **Memory OFF** — Jede Nachricht ist isoliert (Privacy)
  - **Memory Window** — Nur letzte N Nachrichten als Kontext
- **Verhalten:**
  - Toggle in Chat-Settings
  - Slider für Window-Size (5, 10, 20, 50, All)
  - Visual Indicator: "Kali erinnert sich an X Nachrichten"
  - Privacy-Hinweis bei OFF
- **Daten:**
  - `memoryEnabled: bool` in Conversation
  - `memoryWindow: int?` in Conversation

### 4.3 Voice Toggle (Sprach-Ausgabe)
- **Status:** 🟡 Mittel
- **Beschreibung:** User kann Kalis Antworten als Audio hören.
- **UI:** Toggle im Chat-Input oder Settings → Voice
- **Optionen:**
  - **Voice OFF** — Nur Text (Default)
  - **Voice ON** — Auto-TTS für AI-Antworten
  - **Voice Select** — Verschiedene Stimmen
  - **Speed** — Sprechgeschwindigkeit (0.5x - 2x)
- **Verhalten:**
  - TTS-Button pro Nachricht (auch bei OFF)
  - Auto-Play bei ON (mit Mute-Option)
  - Streaming-TTS: Audio wird parallel zum Text generiert
  - Voice-Input: User kann auch sprechen (STT)
- **Daten:**
  - `voiceEnabled: bool` in Settings
  - `voiceModel: String?` (TTS-Stimme)
  - `voiceSpeed: double?` in Settings

### 4.4 Image Generation (Bilder erstellen)
- **Status:** 🟢 Low
- **Beschreibung:** User kann Kali bitten, Bilder zu generieren.
- **UI:** `/imagine` Command oder Image-Button im Input
- **Features:**
  - Text-to-Image über API (DALL-E, Stable Diffusion)
  - Image-to-Image: Bild als Referenz hochladen
  - Style-Select: Realistic, Anime, Artistic, Sketch
  - Size-Select: 512x512, 1024x1024, 1792x1024
- **Verhalten:**
  - Prompt-Input: User beschreibt gewünschtes Bild
  - Loading-Indicator während Generierung
  - Ergebnis wird als Chat-Nachricht angezeigt
  - Tap auf Bild: Fullscreen + Download/Share
  - Gallery-View für mehrere generierte Bilder
- **Daten:**
  - GeneratedImage-Model: `url`, `prompt`, `model`, `size`, `createdAt`
  - Images werden als Attachment an Message gehängt

---

## 📊 Priorisierung — Was kommt als nächstes?

### Phase 1: Core Chat Experience 🔴
| # | Feature | Reason | Effort |
|---|---------|--------|--------|
| 1 | **Theme Toggle** | Basis-UX, schnell implementiert | 2h |
| 2 | **Reply** | Essential für Chat-UX | 4h |
| 3 | **Copy** | Quick Win, hoher Nutzen | 1h |
| 4 | **Model Select** | Kern-Funktionalität | 3h |
| 5 | **Personality Switch** | USP, Kali-Differenzierung | 4h |

### Phase 2: Chat Management 🟡
| # | Feature | Reason | Effort |
|---|---------|--------|--------|
| 6 | **Pin Conversation** | Organisation, häufig genutzt | 3h |
| 7 | **Edit** | Korrektur-Funktion, erwartet | 3h |
| 8 | **Delete** | Safety/Privacy, erwartet | 2h |
| 9 | **Search** | Navigation, wird mit Chats wichtiger | 6h |
| 10 | **Memory Toggle** | Privacy-Feature, Kali-spezifisch | 2h |

### Phase 3: Advanced Features 🟢
| # | Feature | Reason | Effort |
|---|---------|--------|--------|
| 11 | **Archive** | Power-User Feature | 2h |
| 12 | **Sort** | Nice-to-have | 1h |
| 13 | **Voice Toggle** | Premium Feature | 6h |
| 14 | **Export Chat** | Backup/Portability | 4h |
| 15 | **Clear History** | Maintenance | 2h |
| 16 | **Share** | Social Feature | 3h |
| 17 | **Image Generation** | Premium/Kali Feature | 8h |

### Implementation Order (Empfehlung):
```
Woche 1: Theme Toggle → Reply → Copy → Model Select
Woche 2: Personality Switch → Pin → Edit → Delete
Woche 3: Search → Memory Toggle → Archive
Woche 4: Sort → Voice → Export → Clear History → Share
Woche 5: Image Generation (wenn API-Integration steht)
```

---

## 📝 Implementation Notes

### Dependencies:
- **Reply, Edit, Delete:** Message-Model Update + Firebase/SQLite Schema Migration
- **Search:** Full-Text-Search Setup (FTS5 oder Algolia)
- **Voice:** TTS/STT API Integration (ElevenLabs, Whisper)
- **Image Gen:** DALL-E/Stable Diffusion API Integration
- **Theme:** Flutter Theme System (bereits vorhanden)

### Testing Requirements:
- Jedes Feature braucht Widget-Tests
- Integration-Tests für Chat-Flows
- Manual Testing auf iOS + Android

### Accessibility:
- Alle Features müssen Screen-Reader kompatibel sein
- Voice-Features: Alternative Text-Inputs
- Theme: Sufficient Contrast Ratios

---

*Letzte Aktualisierung: 2026-03-28*
*Verantwortlich: Feature Agent*
