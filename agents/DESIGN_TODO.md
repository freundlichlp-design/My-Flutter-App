# DESIGN_TODO.md — Design Agent Tasks

> Basierend auf UI_COMPONENTS.md (28.03.2026) und bekannten offenen Punkten.
> Priorisiert nach Impact: Was den visuellen Eindruck am meisten verbessert.

---

## Task 1: Code Highlighting in ChatBubble integrieren

**Status:** Offen (Vorbereitung in FEEDBACK.md + UI_COMPONENTS.md Abschnitt 1 & 6)

**Problem:** AI-Responses mit Code-Blöcken werden aktuell nur als einfaches Mono-Text gerendert. Das `flutter_highlight` Paket ist als Abhängigkeit dokumentiert, aber noch nicht in der ChatBubble verbunden.

**Ziel:** Syntax-Highlighting für Code-Blöcke in AI-Bubbles — gleicher Dark-Theme-Stil (GitHub-Dark-kompatibel, `#0D1117` Background).

**Details:**
- `MarkdownStyleSheet.codeblockDecoration` + Custom Code-Builder nutzen
- Sprache auto-detecten oder über Markdown-Sprach-Tags (`\`\`\`dart`) parsen
- Farbschema passend zu `KaliColors` (Text: `#E6EDF3`, Keyw: `#FF7B72`, String: `#A5D6FF`, Comment: `#8B949E`)
- Scrollable Code-Blöcke bei langem Code (horizontal)
- Kein Fallback nötig — wenn Paket fehlschlägt, bleibt Standard-Mono

**Referenz:** UI_COMPONENTS.md Abschnitt 1 (Markdown Styling), Abschnitt 6 (Pakete)

---

## Task 2: Provider-Branding-Colors in ConversationListItem Avatar

**Status:** Empfohlen, nicht implementiert (UI_COMPONENTS.md Abschnitt 4 & 7)

**Problem:** Die `_providerColor()` Funktion ist dokumentiert aber nicht im Code. Avatare nutzen aktuell vermutlich eine Default-Farbe statt provider-spezifischer Branding-Farben.

**Ziel:** Visuell sofort erkennbar ob OpenAI (grün), Claude (orange) oder Gemini (blau) — ohne Text lesen zu müssen.

**Details:**
- `_providerColor()` implementieren wie in UI_COMPONENTS.md Spezifikation
- Mapping: OpenAI → `#10A37F`, Claude → `#D97706`, Gemini → `#4285F4`
- Fallback auf `KaliColors.accentPrimary` für unbekannte Provider
- Kein Breaking Change — nur Farbe ändern sich, Struktur bleibt gleich

**Referenz:** UI_COMPONENTS.md Abschnitt 4 (Provider-Branding-Tabelle), Abschnitt 7 (Known Bugs)

---

## Task 3: StreamingIndicator — AnimatedBuilder Bugfix prüfen

**Status:** Offen (potenzieller Bug)

**Problem:** In UI_COMPONENTS.md Abschnitt 3 wird `AnimatedBuilder` verwendet — der korrekte Widget-Name in Flutter ist aber `AnimatedBuilder`. Prüfen ob dies ein Tippfehler in der Doku ist oder ob der Code den gleichen Fehler hat.

**Ziel:** Sicherstellen dass Streaming-Animation korrekt rendert ohne Yellow-Screen-of-Death.

**Details:**
- Code in `streaming_indicator.dart` gegenprüfen
- Falls `AnimatedBuilder` im Code steht → zu `AnimatedBuilder` korrigieren
- Falls Code korrekt ist → Doku-Fix in UI_COMPONENTS.md
- Auch `_PulsingDot` auf selben Fehler prüfen
- Unit-Test: Animation startet ohne Exception

**Referenz:** UI_COMPONENTS.md Abschnitt 3 (Dart Code Snippet, Hinweise für Kilo Code)

---

*Erstellt am 28.03.2026 vom Design Agent.*
*Nächster Schritt: Kilo Code übernimmt Task 1 (Code Highlighting) — höchster visueller Impact.*
