# 🎯 KALI CHAT — HEUTIGE AUFGABEN FÜR KILO CODE

## Was du machst:
1. Lies die Dateien unten
2. Implementiere jeden Task
3. Nach jedem: git add + git commit + git push

---

## TASK 1: Empty States (Kali Style)
**File:** `lib/features/chat/presentation/pages/conversations_screen.dart`
**Was:** Wenn keine Konversationen da sind → zeige Kali-Attitude statt "No conversations"
**Sprüche (rotieren zufällig):**
- "Noch da. Warte auf deine erste Frage."
- "Stille. Entweder du denkst oder du schreibst."
- "Nichts hier. Fang an."
- "Die Leere antwortet schneller als du denkst."
- "Keine Gespräche. Noch."
**Design:** `agents/DESIGN_MASTER.md` Section 2.1

---

## TASK 2: Error States (Kali reagiert)
**File:** `lib/providers/chat_provider.dart`
**Was:** Wenn API Error → zeige Kali's Reaktion statt Standard-Error
**Messages:**
- API Key: "Du hast mich ohne Schlüssel losgeschickt."
- Network: "Die Verbindung ist so stabil wie eine Beziehung auf Tinder."
- Rate Limit: "Du hast zu viel gefragt. Mach eine Pause."
**Design:** `agents/DESIGN_MASTER.md` Section 3

---

## TASK 3: Loading States (Neon Pulse)
**File:** `lib/widgets/streaming_indicator.dart`
**Was:** Wenn Kali denkt → zeige Neon Pulse statt langweiligem Spinner
**Design:** Neon-Blaue Pulsader die pulsiert
**Animation:** 1200ms, easeInOut, loop
**Style:** `agents/KALI_STYLE.md` Section 2

---

## TASK 4: Hardcoded Werte ersetzen
**Files:** ALLE .dart Files in lib/
**Was:** Ersetze hardcoded Farben/Radius/Spacing mit Design Tokens
**Tokens:** `lib/theme/kali_*.dart`
**Bug Report:** `agents/BUGS_DESIGN.md`
**Format:** `agents/KILO_TASK_FORMAT.md`

---

## TASK 5: Theme Toggle
**File:** `lib/screens/settings_screen.dart`
**Was:** Dark/Light Mode Switch
**Default:** Dark (immer)
**Style:** `agents/DESIGN_SYSTEM.md` Section 4

---

## WICHTIG:
- Lies IMMER `agents/` zuerst!
- Nach jedem Task: git add + git commit + git push
- Bei Problemen: Schreibe in `agents/FEEDBACK.md`
- KALI IST KEIN CHATGPT. KALI HAT ATTITUDE.
