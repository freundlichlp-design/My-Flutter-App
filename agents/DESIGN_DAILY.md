# DESIGN_DAILY.md — Tag 4 (28.03.2026)

> Tägliche Design-Tasks. 2 Tasks pro Tag, fokusiert auf umsetzbare Verbesserungen.

---

## Task 1: ConversationListItem — Swipe-Action Animationen definieren

**Status:** Offen
**Priorität:** Mittel
**Geschätzter Aufwand:** ~30 Min (Design-Spec)

**Problem:** STYLE_GUIDE.md Abschnitt 7 erwähnt Swipe Actions (Delete rot, Archive blau) ohne konkrete Animations-Parameter. Kilo Code braucht präzise Specs für die Swipe-Dismiss-Animation.

**Ziel:** Vollständige Spezifikation für Swipe-gestützte Aktionen in der Conversation-List.

**Details:**
- Swipe-Threshold: `40%` der Item-Breite bevor Action triggert
- Delete-Icon: `Icons.delete_outline`, Farbe: `accentDanger` (#F85149), Background: `#F8514920` (20% Opacity)
- Archive-Icon: `Icons.archive_outlined`, Farbe: `accentPrimary` (#58A6FF), Background: `#58A6FF20`
- Reveal-Speed: `Curves.easeOutCubic`, `200ms`
- Snap-Back wenn unter Threshold: `Curves.elasticOut`, `300ms`
- Haptic Feedback bei Threshold-Überschreitung: `HapticFeedback.mediumImpact()`
- Confirm-Dialog bei Delete: Standard AlertDialog mit Style aus STYLE_GUIDE.md (bgTertiary, borderRadius 12px)

**Referenz:** STYLE_GUIDE.md Abschnitt 7 (Conversation List), Abschnitt 11 (Animation Guidelines)

---

## Task 2: Loading Skeleton für Conversation-Liste spezifizieren

**Status:** Offen
**Priorität:** Niedrig
**Geschätzter Aufwand:** ~20 Min (Design-Spec)

**Problem:** Beim App-Start oder Channel-Wechsel fehlt ein Loading-State für die Conversation-Liste. Aktuell vermutlich ein leerer Screen oder Standard-Spinner — nicht ideal für UX.

**Ziel:** Shimmer/Skeleton-Loading das wie die echte Liste aussieht, aber geladen wird.

**Details:**
- 5 Skeleton-Items (simulieren typische Listenlänge)
- Item-Struktur: Avatar-Kreis (40px) + 2 Textzeilen (Titel + Subtitle)
- Shimmer-Farbe: `bgSecondary` (#161B22) → `bgTertiary` (#21262D) → zurück
- Shimmer-Duration: `1500ms`, `Curves.easeInOut`, loop
- Border-Radius: Items = `8px`, Avatar = `circle`
- Kein Text — nur farbige Rechtecke/Kreise
- Animation startet sofort bei Widget-Build

**Referenz:** STYLE_GUIDE.md Abschnitt 3 (Spacing), Abschnitt 7 (Conversation List), Abschnitt 11 (Animation)

---

*Erstellt am 28.03.2026 vom Design Agent (Tag 4).*
*Nächster Schritt: Kilo Code implementiert Task 1 (Swipe Actions) nach Freigabe.*
