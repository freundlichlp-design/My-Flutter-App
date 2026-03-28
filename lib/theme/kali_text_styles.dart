import 'package:flutter/material.dart';

import 'kali_colors.dart';

/// Typografie-Tokens. Font-Families:
///   - Body/UI: 'Inter' (Fallback: 'SF Pro Display' / 'Roboto')
///   - Code:    'JetBrains Mono' (Fallback: 'monospace')
class KaliTextStyles {
  KaliTextStyles._();

  // ─── Display / Headline ───────────────────────────────
  static const TextStyle headline = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: KaliColors.textPrimary,
  );

  // ─── Subtitle / Section Headers ──────────────────────
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: KaliColors.textPrimary,
  );

  // ─── Body (Chat Messages) ────────────────────────────
  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: KaliColors.textPrimary,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: KaliColors.textPrimary,
  );

  // ─── Caption / Metadata ──────────────────────────────
  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: KaliColors.textSecondary,
  );

  // ─── Label / Buttons ─────────────────────────────────
  static const TextStyle label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: KaliColors.textPrimary,
  );

  // ─── Inline Code ─────────────────────────────────────
  static const TextStyle code = TextStyle(
    fontFamily: 'JetBrains Mono',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: KaliColors.textPrimary,
    backgroundColor: KaliColors.bgPrimary,
  );

  // ─── Muted / Placeholder ─────────────────────────────
  static const TextStyle muted = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: KaliColors.textMuted,
  );
}
