# FEATURE_COMPLETE.md — Onboarding, Splash, API Keys, Abo

> Feature Agent Report — 29.03.2026
> Basierend auf: KALI_APP_SPEC.md, DESIGN_MASTER.md, BUGS_COMPLETE.md

---

## 1. SPLASH SCREEN

### Flow
```
App Start → Splash (1-2s) → Check onboarding_done → Onboarding OR Chat
```

### Design
- Schwarzer Hintergrund (#0D1117)
- Kali Logo zentriert (einfach: Text "KALI" in JetBrains Mono, fett, 48px, #58A6FF)
- Subtiler Pulse-Glow (BoxShadow, 50% opacity, 2s loop)
- Lade-Balken unten (dünn, 2px, #58A6FF, animiert)

### Dart Code
```dart
// lib/features/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      onboardingDone ? '/chat' : '/onboarding',
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Center(
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF58A6FF)
                        .withOpacity(_pulseAnimation.value * 0.3),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Text(
                'KALI',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF58A6FF),
                  letterSpacing: 8,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### SharedPreferences Flag
- Key: `onboarding_done` (bool)
- Set nach: Onboarding Page 3 "Bereit." Button Tap
- Check in: SplashScreen.initState()

---

## 2. ONBOARDING (3 Pages)

### Page 1: "KALI"
- Logo groß, zentriert
- Tagline: "Dark. Direct. Deadly accurate."
- Subtitle: "Multi-Model AI Terminal"
- Weiter-Pfeil unten

### Page 2: "Wähle dein Modell"
- 3 Cards nebeneinander (oder gestapelt auf kleinen Screens):
  - 🟢 GPT-4o (OpenAI) — "Schnell, kreativ, vielseitig"
  - 🟠 Claude 3.5 (Anthropic) — "Präzise, analytisch, sicher"
  - 🔵 Gemini Pro (Google) — "Multimodal, schnell, Google-Ökosystem"
- Ein Tap = Auswahl (Glow-Effekt auf gewählter Card)
- Auswahl wird in SharedPreferences gespeichert: `selected_provider`

### Page 3: "Bereit."
- Checkmark-Animation (Lottie oder CustomPainter)
- "Bereit loszulegen." Text
- Button: "Starten" → Speichert `onboarding_done = true` → Navigate to /chat

### Dart Code (Kurzform)
```dart
// lib/features/onboarding/onboarding_screen.dart
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  String _selectedProvider = 'openai';

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'KALI',
      subtitle: 'Dark. Direct. Deadly accurate.',
      description: 'Multi-Model AI Terminal',
    ),
    _OnboardingPage(
      title: 'Wähle dein Modell',
      subtitle: '',
      description: '',
      isProviderPage: true,
    ),
    _OnboardingPage(
      title: 'Bereit.',
      subtitle: 'Bereit loszulegen.',
      description: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              // Each page content
              return _buildPage(_pages[index]);
            },
          ),
          // Skip button
          Positioned(
            top: 50, right: 20,
            child: TextButton(
              onPressed: _finish,
              child: const Text('Skip', style: TextStyle(color: Color(0xFF8B949E))),
            ),
          ),
          // Page indicator + Next/Start button
          Positioned(
            bottom: 50, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dots
                Row(children: List.generate(3, (i) =>
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? const Color(0xFF58A6FF)
                          : const Color(0xFF30363D),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )),
                // Next/Start
                ElevatedButton(
                  onPressed: _currentPage == 2 ? _finish : _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF58A6FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(_currentPage == 2 ? 'Starten' : 'Weiter'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _next() => _controller.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    await prefs.setString('selected_provider', _selectedProvider);
    if (mounted) Navigator.pushReplacementNamed(context, '/chat');
  }
}
```

---

## 3. API KEYS (VERSTECKT)

### Design
- User sieht KEINE API Keys
- Keys sind in `lib/core/config/api_config.dart` hardcoded (oder Remote Config)
- User wählt nur Modell, nicht Key
- Settings hat KEIN API Key Feld

### Dart Code
```dart
// lib/core/config/api_config.dart
class ApiConfig {
  ApiConfig._();

  // Hardcoded Keys (für Entwicklung — später Remote Config)
  static const String openAiKey = String.fromEnvironment('OPENAI_API_KEY');
  static const String claudeKey = String.fromEnvironment('ANTHROPIC_API_KEY');
  static const String geminiKey = String.fromEnvironment('GEMINI_API_KEY');

  // Models
  static const Map<String, List<String>> providerModels = {
    'openai': ['gpt-4o', 'gpt-4o-mini', 'gpt-4-turbo'],
    'claude': ['claude-3-5-sonnet', 'claude-3-haiku'],
    'gemini': ['gemini-pro', 'gemini-pro-vision'],
  };

  // Get key for provider
  static String getKey(String provider) {
    switch (provider) {
      case 'openai': return openAiKey;
      case 'claude': return claudeKey;
      case 'gemini': return geminiKey;
      default: throw Exception('Unknown provider: $provider');
    }
  }
}
```

### Error Messages (Kali Style)
| Situation | Message |
|-----------|---------|
| Key fehlt | "Modell nicht verfügbar. Anderes Modell wählen." |
| Key ungültig | "Verbindung fehlgeschlagen. Prüfe Netzwerk." |
| Rate Limit | "Rate Limit. 30s warten." |
| Timeout | "Timeout. Nochmal versuchen." |

### Settings Screen
- KEIN "API Key" Eingabefeld
- Stattdessen: "Verfügbare Modelle" Liste (grün = verfügbar, grau = nicht verfügbar)
- Model Selector im Chat: Dropdown mit verfügbaren Modellen

---

## 4. ABO SYSTEM

### Tiers
| Tier | Preis/Monat | Preis/Jahr | Features |
|------|------------|-----------|----------|
| Free | $0 | $0 | 50 Nachrichten/Tag, GPT-4o-mini nur |
| Pro | $9.99 | $99/yr | Unlimited, Alle Modelle, Memory, Voice |
| Enterprise | $29.99 | $299/yr | Alles + Priority Support + Custom Models |

### Dart Code
```dart
// lib/features/subscription/subscription_screen.dart
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isYearly = false;
  String _selectedTier = 'pro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text('Abo', style: TextStyle(color: Color(0xFFE6EDF3))),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF8B949E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Monthly/Yearly Toggle
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF21262D),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  _buildToggle('Monatlich', !_isYearly),
                  _buildToggle('Jährlich (spare 17%)', _isYearly),
                ],
              ),
            ),
          ),
          // Tier Cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTierCard('Free', '\$0', ['50 Nachrichten/Tag', 'GPT-4o-mini']),
                const SizedBox(height: 12),
                _buildTierCard('Pro', _isYearly ? '\$99/Jahr' : '\$9.99/Monat', [
                  'Unlimited Nachrichten',
                  'Alle Modelle',
                  'Memory System',
                  'Voice Mode',
                ]),
                const SizedBox(height: 12),
                _buildTierCard('Enterprise', _isYearly ? '\$299/Jahr' : '\$29.99/Monat', [
                  'Alles aus Pro',
                  'Priority Support',
                  'Custom Models',
                  'Team Features',
                ]),
              ],
            ),
          ),
          // CTA Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Payment Integration
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bald verfügbar.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58A6FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  _selectedTier == 'free' ? 'Aktuell' : 'Jetzt Upgraden',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isYearly = label.contains('Jährlich')),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF58A6FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF8B949E),
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTierCard(String name, String price, List<String> features) {
    final isSelected = _selectedTier == name.toLowerCase();
    return GestureDetector(
      onTap: () => setState(() => _selectedTier = name.toLowerCase()),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          border: Border.all(
            color: isSelected ? const Color(0xFF58A6FF) : const Color(0xFF30363D),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(
                  color: Color(0xFFE6EDF3),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
                Text(price, style: const TextStyle(
                  color: Color(0xFF58A6FF),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
            const SizedBox(height: 12),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.check, color: Color(0xFF3FB950), size: 18),
                  const SizedBox(width: 8),
                  Text(f, style: const TextStyle(color: Color(0xFF8B949E))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
```

---

## 5. SCREEN MAP (Updated)

```
lib/features/
├── splash/
│   └── splash_screen.dart          # NEU — Kali Logo + Pulse
├── onboarding/
│   └── onboarding_screen.dart      # NEU — 3 Pages
├── chat/
│   ├── screens/
│   │   └── chat_screen.dart        # ✅ Existiert
│   └── widgets/
│       ├── chat_bubble.dart        # ⚠️ Update (asymmetrisch)
│       ├── streaming_cursor.dart   # ❌ NEU
│       ├── provider_avatar.dart    # ❌ NEU
│       ├── pill_input.dart         # ❌ NEU
│       ├── token_counter.dart      # ❌ NEU
│       └── model_selector.dart     # ❌ NEU
├── settings/
│   └── screens/
│       └── settings_screen.dart    # ⚠️ Update (Config-Style, kein API Key)
├── subscription/
│   └── subscription_screen.dart    # ⚠️ Update (Tier Cards)
└── personality/                    # ❌ Phase 2
```

---

## 6. ROUTING (Updated)

```dart
// lib/routing/app_router.dart
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
    GoRoute(path: '/chat', builder: (c, s) => const ChatScreen()),
    GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
    GoRoute(path: '/subscription', builder: (c, s) => const SubscriptionScreen()),
  ],
);
```

---

*Feature Agent: 29.03.2026*
*Status: Ready for Kilo Code Implementation*
