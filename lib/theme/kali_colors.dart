import 'package:flutter/material.dart';

/// Design Tokens — Kali Chat App
/// Alle Farben als Color-Konstanten. Dark-Mode-First.
/// Hex-Werte sind die Single Source of Truth.
class KaliColors {
  KaliColors._();

  // ═══════════════════════════════════════════════════════
  //  BACKGROUND TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color bgPrimary   = Color(0xFF0D1117);
  static const Color bgSecondary = Color(0xFF161B22);
  static const Color bgTertiary  = Color(0xFF21262D);
  static const Color bgOverlay   = Color(0x99000000);

  // ═══════════════════════════════════════════════════════
  //  TEXT TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color textPrimary   = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted     = Color(0xFF484F58);
  static const Color textInverse   = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════
  //  BORDER TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color borderColor  = Color(0xFF30363D);
  static const Color borderFocus  = Color(0xFF58A6FF);
  static const Color borderDanger = Color(0xFFF85149);

  // ═══════════════════════════════════════════════════════
  //  SEMANTIC / ACCENT TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color accentPrimary   = Color(0xFF58A6FF);
  static const Color accentSecondary = Color(0xFF388BFD);
  static const Color accentSuccess   = Color(0xFF3FB950);
  static const Color accentWarning   = Color(0xFFD29922);
  static const Color accentDanger    = Color(0xFFF85149);

  // ═══════════════════════════════════════════════════════
  //  CHAT BUBBLE TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color bubbleUser     = Color(0xFF1F6FEB);
  static const Color bubbleUserText = Color(0xFFFFFFFF);
  static const Color bubbleAi       = Color(0xFF21262D);
  static const Color bubbleAiText   = Color(0xFFE6EDF3);
  static const Color bubbleAiBorder = Color(0xFF30363D);

  // ═══════════════════════════════════════════════════════
  //  PROVIDER BRANDING TOKENS
  // ═══════════════════════════════════════════════════════
  static const Color openAiBranding = Color(0xFF10A37F);
  static const Color claudeBranding = Color(0xFFD97706);
  static const Color geminiBranding = Color(0xFF4285F4);

  // Legacy aliases (backward compatibility)
  static const Color openAiGreen = openAiBranding;
  static const Color claudeOrange = claudeBranding;
  static const Color geminiBlue = geminiBranding;
}
