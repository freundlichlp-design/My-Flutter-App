# DESIGN_TODO.md — Design Agent Tag 3

> Basierend auf UI_COMPONENTS.md, STYLE_GUIDE.md und aktuellem Code-Stand (28.03.2026).
> 3 neue Tasks — fokussiert auf noch fehlende UI-Bereiche und Interaction-Patterns.

---

## Task 1: SettingsScreen UI-Spezifikation erstellen

**Status:** Offen — SettingsScreen existiert im Code, aber es fehlt eine vollständige Design-Spezifikation

**Problem:** `settings_screen.dart` wird in der Architektur erwähnt, aber weder in UI_COMPONENTS.md noch in STYLE_GUIDE.md gibt es eine detaillierte Widget-Spezifikation. Die App braucht eine konsistente Settings-Oberfläche für API-Key-Verwaltung, Model-Auswahl und Personality-Konfiguration.

**Ziel:** Fertige Settings-UI die zu KaliColors passt — Dark-Theme, klare Sections, Provider-Branding.

**Details:**
- 3 Sections: **API Keys** (OpenAI/Claude/Gemini Input-Felder), **Model Selection** (Dropdown pro Provider), **Personality** (5 Templates aus `kali_personality.dart`)
- API-Key-Felder: `obscureText: true`, Paste-Button rechts, grüner Check wenn Key vorhanden
- Section-Header: `subtitle` 18px w600, `textPrimary`, Abstand `space.lg`
- Card-Style: `bgSecondary`, Border `1px borderColor`, Radius `12px`, Padding `space.md`
- Model-Dropdown: `bgTertiary`, aktives Model = `accentPrimary` Text
- Personality-Templates: Radio-List mit kurzer Beschreibung (1 Zeile)
- Spacing: `space.md` zwischen Feldern, `space.xl` zwischen Sections

**Referenz:** STYLE_GUIDE.md (Colors, Typography, Spacing), UI_COMPONENTS.md Abschnitt 4 (Provider-Branding)

---

## Task 2: Message-Grouping und Timestamp-Divider implementieren

**Status:** Offen — aktuell werden alle Messages gleich behandelt, keine visuelle Gruppierung

**Problem:** Wenn ein User mehrere Nachrichten hintereinander sendet (oder die AI mehrere Responses gibt), erscheinen sie als einzelne Bubbles mit Abstand. Professionelle Chat-Apps gruppieren aufeinanderfolgende Messages vom selben Sender und zeigen Timestamps nur bei Sprüngen.

**Ziel:** WhatsApp/iMessage-Style Message-Grouping — weniger visuelles Rauschen, bessere Lesbarkeit.

**Details:**
- Consecutive Messages vom selben Sender: `margin: 0px` zwischen Bubbles (statt `2px`), Radius nur an erster/letzter Bubble
- Timestamp-Divider: Nur anzeigen wenn >5 Min Abstand zwischen Messages — z.B. `"Heute, 14:32"` zentriert, `caption` Font, `textSecondary`
- Group Avatar: Nur bei letzter Bubble einer Gruppe (AI-Bubbles) — vermeidet Wiederholung
- `ChatBubble` bekommt neue Props: `isFirstInGroup: bool`, `isLastInGroup: bool`
- Border-Radius-Anpassung: `isFirstInGroup` = top-radius 18px, `!isFirstInGroup` = top-radius 4px
- Kein Breaking Change — Default `isFirstInGroup: true, isLastInGroup: true` = aktuelles Verhalten

**Referenz:** STYLE_GUIDE.md §4 (Chat Bubble Design), UI_COMPONENTS.md §1 (ChatBubble Widget)

---

## Task 3: Long-Press Copy & Swipe-Actions für ChatBubble

**Status:** In Doku erwähnt, nicht implementiert — `onLongPress → Clipboard` fehlt

**Problem:** UI_COMPONENTS.md dokumentiert `onLongPress → Content in Clipboard` für ChatBubble, aber das Feature ist nicht umgesetzt. Außerdem fehlen Swipe-Actions auf Messages (Reply, Delete, Copy).

**Ziel:** Native-feelende Interaction-Patterns: Long-Press für Copy mit visuellem Feedback, optionale Swipe-Actions.

**Details:**
- **Long-Press Copy:**
  - `GestureDetector.onLongPress` → `Clipboard.setData(ClipboardData(text: message.content))`
  - Visuelles Feedback: Helligkeit-Shift (`Color.withOpacity(0.8)`) für 200ms + `SnackBar` "Kopiert" (2s, `accentSuccess` Background)
  - Haptic Feedback: `HapticFeedback.mediumImpact()`
- **Swipe Reply (optional, Phase 2):**
  - `endToStart` Swipe → Reply-Icon erscheint, Message wird zitiert im Input
  - Background: `accentPrimary` mit `Icons.reply` rechts
- **ChatBubble Wrapper:**
  - `Dismissible` nur für Reply (nicht Delete — zu gefährlich)
  - Long-Press unabhängig von Dismissible
- Bereits dokumentiert in STYLE_GUIDE.md §8 (Icons.copy, Icons.refresh)

**Referenz:** UI_COMPONENTS.md §1 (Status-Anzeige, Copy), STYLE_GUIDE.md §8 (Iconography)

---

## Priorisierung

| Task | Impact | Effekt | Empfohlene Reihenfolge |
|------|--------|--------|----------------------|
| 1 — SettingsScreen | Hoch | User kann API-Keys verwalten | **1. zuerst** |
| 2 — Message Grouping | Hoch | Chat sieht professioneller aus | **2. danach** |
| 3 — Long-Press Copy | Mittel | Quality-of-Life, täglich genutzt | **3. zuletzt** |

---

*Erstellt am 28.03.2026 vom Design Agent (Tag 3).*
*Nächster Schritt: Kilo Code übernimmt Task 1 (SettingsScreen UI).*
