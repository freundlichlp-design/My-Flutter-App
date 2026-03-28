# Bug Agent Tag 5 — Design Token Review

**Date:** 2026-03-28
**Scope:** `lib/theme/kali_*.dart`, `lib/theme/app_theme.dart`, `lib/features/chat/presentation/widgets/*.dart`

---

## Summary

| Category | Count | Severity |
|----------|-------|----------|
| Hardcoded Colors | 4 instances | 🔴 CRITICAL |
| Hardcoded Radius | 13 instances | 🟠 MAJOR |
| Hardcoded Durations | 6 instances | 🟠 MAJOR |
| Hardcoded Spacing | 28+ instances | 🟠 MAJOR |
| Missing Token Imports | 5 files | 🟠 MAJOR |
| Unused Design Tokens | 3 token classes | 🟡 MODERATE |

**Verdict:** KaliColors wird korrekt in allen Widgets verwendet. Aber KaliRadius, KaliDurations, KaliSpacing und KaliTextStyles werden **in keinem einzigen Widget** importiert oder benutzt. Die Token-Dateien sind sauber definiert, aber die Widgets ignorieren sie komplett.

---

## 1. Design Token Files — Review

### ✅ `kali_colors.dart` — SAUBER
- Alle Farben als `static const Color` mit Hex-Werten
- Gruppen: Background, Text, Border, Semantic, Chat Bubble, Provider Branding
- Legacy Aliases vorhanden (openAiGreen → openAiBranding)
- **Keine hardcoded Werte außerhalb der Definition**

### ✅ `kali_radius.dart` — SAUBER
- sm=4, md=8, lg=12, xl=18, pill=24, full=9999
- Convenience BorderRadius: bubbleUser, bubbleAi, inputField, card, codeBlock
- **Problem: Wird nirgendwo importiert!**

### ✅ `kali_spacing.dart` — SAUBER
- Base Unit 8px, xxs=2, xs=4, sm=8, md=16, lg=24, xl=32, xxl=48
- Convenience EdgeInsets: paddingXS bis paddingXL, paddingScreenH/V
- **Problem: Wird nirgendwo importiert!**

### ✅ `kali_durations.dart` — SAUBER
- instant=0, fast=150ms, normal=200ms, medium=250ms, slow=300ms, cursor=500ms, spinner=1000ms, pulsing=800ms
- KaliCurves: screenTransition, bubbleAppear, cursorBlink, bottomSheet, fadeIn/fadeOut, slideUp, scaleIn
- **Problem: Wird nirgendwo importiert!**

### ✅ `kali_text_styles.dart` — SAUBER
- headline, subtitle, body, bodyBold, caption, label, code, muted
- Font-Families: Inter (Body), JetBrains Mono (Code)
- **Problem: Wird nur in app_theme.dart importiert, nicht in Widgets!**

### ✅ `app_theme.dart` — SAUBER
- Importiert kali_colors, kali_radius, kali_spacing, kali_text_styles
- Vollständiges Dark Theme mit ColorScheme, AppBar, Card, FAB, Input, SegmentedButton, Dropdown, Divider, SnackBar, Dialog, TextTheme
- **Keine hardcoded Werte — alles über Tokens**

---

## 2. Widget Review — Bugs & Findings

### 🔴 `chat_bubble.dart`

**Hardcoded Colors:**
- Line 142: `borderRadius: BorderRadius.circular(8)` → hardcoded 8 statt `KaliRadius.md`
- Der Code-Block Container nutzt `borderRadius: BorderRadius.circular(8)` im Markdown StyleSheet

**Hardcoded Radius (4 instances):**
- Lines 38-42: Bubble-BorderRadius komplett hardcoded:
  ```dart
  topLeft: const Radius.circular(18),     // → KaliRadius.xl
  topRight: const Radius.circular(18),    // → KaliRadius.xl
  bottomLeft: Radius.circular(isUser ? 18 : 4),   // → KaliRadius.xl / KaliRadius.sm
  bottomRight: Radius.circular(isUser ? 4 : 18),  // → KaliRadius.sm / KaliRadius.xl
  ```
- **Gleiche Werte existieren bereits als `KaliRadius.bubbleUser` und `KaliRadius.bubbleAi`!**

**Hardcoded Spacing (3 instances):**
- Line 25: `EdgeInsets.symmetric(vertical: 2)`
- Line 35: `EdgeInsets.symmetric(vertical: 12, horizontal: 16)`
- Line 65: `EdgeInsets.only(top: 4, left: 4, right: 4)`

**Hardcoded TextStyle (3 instances):**
- Line 47: Inline TextStyle für User-Nachrichten → sollte `KaliTextStyles.body` sein
- Line 68: Inline TextStyle für Metadata → sollte `KaliTextStyles.caption` sein
- Lines 87-132: Markdown StyleSheet komplett inline definiert statt KaliTextStyles zu nutzen

**Missing Imports:** `kali_radius.dart`, `kali_spacing.dart`, `kali_text_styles.dart`

---

### 🔴 `code_block.dart`

**Hardcoded Colors (CRITICAL):**
- Line 25: `color: const Color(0xFF0D1117)` → **EXAKT** `KaliColors.bgPrimary` — Token existiert, wird nicht genutzt!
- Line 39: `color: Color(0xFF161B22)` → **EXAKT** `KaliColors.bgSecondary` — Token existiert, wird nicht genutzt!

**Hardcoded Radius (4 instances):**
- Line 26: `BorderRadius.circular(8)` → `KaliRadius.md`
- Lines 40-42: Header `Radius.circular(8)` → `KaliRadius.md`
- Line 58: Copy-Button `BorderRadius.circular(4)` → `KaliRadius.sm`

**Hardcoded Duration:**
- Line 114: `Duration(seconds: 2)` → kein direktes Token, aber SnackBar-Duration könnte konfigurierbar sein

**Hardcoded Spacing (5 instances):**
- Line 23: `EdgeInsets.symmetric(vertical: 8)`
- Line 37: `EdgeInsets.symmetric(horizontal: 12, vertical: 8)`
- Line 60: `EdgeInsets.symmetric(horizontal: 4, vertical: 2)`
- Line 69: `SizedBox(width: 4)`
- Line 95: `EdgeInsets.all(12)`

**Hardcoded TextStyle (2 instances):**
- Lines 44-48: Language label TextStyle inline
- Lines 96-100: Code TextStyle inline → sollte `KaliTextStyles.code` sein

**Missing Imports:** `kali_radius.dart`, `kali_spacing.dart`, `kali_text_styles.dart`, `kali_durations.dart`

---

### 🔴 `message_input.dart`

**Hardcoded Colors:**
- Line 88: `color: Colors.white` → sollte `KaliColors.textInverse` oder `KaliColors.textPrimary` sein
- Line 121: `color: Colors.white` → gleiche Issue

**Hardcoded Radius (1 instance):**
- Line 71: `BorderRadius.circular(24)` → sollte `KaliRadius.pill` sein (24 = pill)

**Hardcoded Spacing (4 instances):**
- Line 53: `EdgeInsets.symmetric(horizontal: 8, vertical: 8)`
- Line 98: `EdgeInsets.symmetric(horizontal: 16, vertical: 12)`
- Line 106: `SizedBox(width: 8)`
- Line 124: `EdgeInsets.zero`

**Hardcoded TextStyle (2 instances):**
- Line 85-88: Input text style inline
- Line 93-96: Hint text style inline

**Design Inconsistency:**
- Input-Feld Hintergrund = `KaliColors.bgTertiary` (line 69), Container Hintergrund = `KaliColors.bgTertiary` (line 56) → kein visueller Kontrast. Input sollte `KaliColors.bgPrimary` nutzen.

**Missing Imports:** `kali_radius.dart`, `kali_spacing.dart`, `kali_text_styles.dart`

---

### 🔴 `streaming_indicator.dart`

**Hardcoded Radius (4 instances):**
- Lines 53-57: Bubble-BorderRadius komplett hardcoded:
  ```dart
  topLeft: Radius.circular(18),      // → KaliRadius.xl
  topRight: Radius.circular(18),     // → KaliRadius.xl
  bottomRight: Radius.circular(18),  // → KaliRadius.xl
  bottomLeft: Radius.circular(4),    // → KaliRadius.sm
  ```
- **Sollte `KaliRadius.bubbleAi` nutzen!**

**Hardcoded Durations (2 instances):**
- Line 29: `Duration(milliseconds: 500)` → **EXAKT** `KaliDurations.cursor` (500ms)!
- Line 163: `Duration(milliseconds: 800)` → **EXAKT** `KaliDurations.pulsing` (800ms)!

**Hardcoded Spacing (4 instances):**
- Line 42: `EdgeInsets.symmetric(vertical: 2)`
- Line 50: `EdgeInsets.symmetric(vertical: 12, horizontal: 16)`
- Line 90: `EdgeInsets.only(top: 4, left: 4)`
- Line 91: `EdgeInsets.symmetric(horizontal: 8, vertical: 4)`

**Hardcoded TextStyle (4 instances):**
- Lines 72-76: Cursor TextStyle inline
- Lines 99-102: "Streaming" label inline
- Lines 110, 119: Token/time text inline

**Missing Imports:** `kali_radius.dart`, `kali_spacing.dart`, `kali_text_styles.dart`, `kali_durations.dart`

---

### 🟡 `conversation_list_item.dart`

**Hardcoded Radius (1 instance):**
- Line 51: `BorderRadius.circular(12)` → `KaliRadius.lg`

**Hardcoded Durations (2 instances):**
- Line 116: `Duration(milliseconds: 200)` → `KaliDurations.normal`
- Line 117: `Duration(milliseconds: 200)` → `KaliDurations.normal`

**Hardcoded Spacing (7 instances):**
- Lines 98, 108: Archive/Delete padding `EdgeInsets.only(left/right: 24)`
- Line 122: `EdgeInsets.symmetric(horizontal: 16)`
- Line 143: `SizedBox(width: 12)`
- Line 159: `SizedBox(height: 4)`
- Line 172: `SizedBox(width: 8)`

**Hardcoded TextStyle (4 instances):**
- Dialog title inline (line 55)
- Dialog content inline (line 63)
- Conversation title inline (line 150)
- Subtitle inline (line 162)

**Missing Imports:** `kali_radius.dart`, `kali_spacing.dart`, `kali_text_styles.dart`, `kali_durations.dart`

---

### 🟡 `conversation_list_skeleton.dart`

**Hardcoded Duration:**
- Line 28: `Duration(milliseconds: 1500)` → kein direktes Token, könnte `KaliDurations.skeleton` sein (neues Token vorschlagen)

**Hardcoded Radius (2 instances):**
- Lines 100, 109: `BorderRadius.circular(8)` → `KaliRadius.md`

**Hardcoded Spacing (3 instances):**
- Line 73: `EdgeInsets.symmetric(horizontal: 16)`
- Line 90: `SizedBox(width: 12)`
- Line 104: `SizedBox(height: 8)`

**Missing Imports:** `kali_radius.dart`, `kali_spacing.dart`, `kali_durations.dart`

---

## 3. Import-Analyse

| File | kali_colors | kali_radius | kali_spacing | kali_text_styles | kali_durations |
|------|:-----------:|:-----------:|:------------:|:----------------:|:--------------:|
| app_theme.dart | ✅ | ✅ | ✅ | ✅ | ❌ |
| chat_bubble.dart | ✅ | ❌ | ❌ | ❌ | ❌ |
| code_block.dart | ✅ | ❌ | ❌ | ❌ | ❌ |
| conversation_list_item.dart | ✅ | ❌ | ❌ | ❌ | ❌ |
| conversation_list_skeleton.dart | ✅ | ❌ | ❌ | ❌ | ❌ |
| message_input.dart | ✅ | ❌ | ❌ | ❌ | ❌ |
| streaming_indicator.dart | ✅ | ❌ | ❌ | ❌ | ❌ |

**Fazit:** Nur KaliColors wird durchgehend genutzt. Alle anderen Token-Klassen sind ungenutzt.

---

## 4. Breaking Changes

**Keine Breaking Changes gefunden.** Die Token-Dateien sind additive — sie existieren parallel zu den hardcoded Werten und brechen nichts. Das Problem ist das Gegenteil: die Tokens werden ignoriert.

**Potenzielle zukünftige Breaking Changes:**
- Wenn `KaliRadius.bubbleUser`/`KaliBubbleAi` geändert werden, ändert sich das UI nicht, weil die Widgets hardcoded Werte nutzen
- Wenn Farben in `KaliColors` angepasst werden, bleiben `code_block.dart`'s hardcoded Hex-Werte unberührt

---

## 5. Empfehlungen

### Sofort (P0):
1. **code_block.dart:** Ersetze `Color(0xFF0D1117)` → `KaliColors.bgPrimary` und `Color(0xFF161B22)` → `KaliColors.bgSecondary`
2. **message_input.dart:** Ersetze `Colors.white` → `KaliColors.textInverse`
3. **Alle Widgets:** Importiere und nutze `KaliRadius` statt hardcoded Radius-Werte

### Bald (P1):
4. Ersetze alle hardcoded `Duration` mit `KaliDurations`
5. Ersetze alle hardcoded `EdgeInsets`/`SizedBox` mit `KaliSpacing`
6. Ersetze alle inline `TextStyle` mit `KaliTextStyles`
7. Nutze `KaliRadius.bubbleUser`/`bubbleAi` in chat_bubble und streaming_indicator

### Nice-to-have (P2):
8. Füge `KaliDurations.skeleton` Token hinzu (1500ms für Shimmer)
9. Erstelle eine `KaliMarkdownStyleSheet` Factory für wiederverwendbare Markdown-Styles
10. Input-Feld Hintergrund: `KaliColors.bgPrimary` statt `KaliColors.bgTertiary`

---

## 6. Token Quality Score

| Token Class | Defined | Used | Coverage |
|-------------|---------|------|----------|
| KaliColors | 25 tokens | 25 used | 100% |
| KaliRadius | 10 values | 0 used | 0% |
| KaliSpacing | 14 values | 0 used | 0% |
| KaliDurations | 8 values | 0 used | 0% |
| KaliCurves | 8 values | 0 used | 0% |
| KaliTextStyles | 8 styles | 0 used in widgets | 0% |
| KaliElevation | 3 values | 0 used | 0% |

**Overall: Token-System ist definiert aber nicht integriert.**
