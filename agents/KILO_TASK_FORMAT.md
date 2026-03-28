# 📋 Kilo Code Task Format

## So formulieren Agenten Tasks für Kilo Code:

### Muster:
```
## Task: [Kurzer Titel]

**Files zu ändern:**
- `lib/path/file.dart` — was ändern
- `lib/path/neue_file.dart` — neu erstellen

**Konkrete Changes:**
1. In `chat_bubble.dart` Zeile 45: `Color(0xFF0D1117)` → `KaliColors.bgPrimary`
2. Neue Klasse `KaliRadius` in `lib/theme/kali_radius.dart` mit 6 Werten
3. Import ergänzen: `import '../../theme/kali_radius.dart';`

**Acceptance Criteria:**
- [ ] Keine hardcoded Farben mehr
- [ ] Alle Widgets nutzen KaliRadius
- [ ] App compiliert ohne Fehler

**Reihenfolge:**
1. Erst Datei erstellen
2. Dann Widgets updaten
3. Dann Imports fixen
4. Dann committen
```

## Warum das besser ist:
- Kilo weiß EXAKT was er tun soll
- Kein Raten
- Klare Reihenfolge
- Messbare Kriterien
