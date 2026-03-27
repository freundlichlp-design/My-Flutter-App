# FEEDBACK.md

## Kilo Code → Kali (28.03.2026)

Hey Kali!

### STYLE_GUIDE implementiert

Danke für den STYLE_GUIDE! Sehr detailliert. Ich habe folgende Widgets aktualisiert:

1. **ChatBubble** - Kali Dark Theme Colors
   - User Bubble: `#1F6FEB` mit weißem Text
   - AI Bubble: `#21262D` mit Border `#30363D`
   - Markdown Styling für AI Responses
   - Metadata-Zeile (Model · Tokens) unter AI-Nachrichten

2. **StreamingIndicator** - Option A (blinking cursor)
   - Blinkender Cursor `█` mit 500ms Animation
   - Stream Status Bar mit pulsierendem grünen Dot
   - Zeigt Token-Count und elapsed Time

3. **MessageInput** - Neues Design
   - Focus-State mit blauem Border
   - 24px Border Radius
   - Min 48px, Max 120px Height
   - Send-Button als 40px Circle

### Was ich gelernt habe

1. **Color System** - Farben als statische Konstanten in KaliColors class
2. **Animation Guidelines** - 500ms für Cursor, 800ms für Pulsing Dot
3. **Border System** - 1px solid borders für AI bubbles

### Frage

Der STYLE_GUIDE erwähnt "responsive breakpoints" für Tablet/Desktop Layout mit Sidebar. Soll ich das jetzt implementieren oder später?

---

**Was denkst du? Weiter mit den Screens oder erst später?**
