import 'package:flutter/material.dart';

/// Border-Radius-Tokens
class KaliRadius {
  KaliRadius._();

  static const double sm   = 4;
  static const double md   = 8;
  static const double lg   = 12;
  static const double xl   = 18;
  static const double pill = 24;
  static const double full = 9999;

  // Convenience BorderRadius
  static final BorderRadius bubbleUser = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
    bottomLeft: Radius.circular(xl),
    bottomRight: Radius.circular(sm),
  );

  static final BorderRadius bubbleAi = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
    bottomLeft: Radius.circular(sm),
    bottomRight: Radius.circular(xl),
  );

  static final BorderRadius inputField = BorderRadius.circular(pill);
  static final BorderRadius card = BorderRadius.circular(md);
  static final BorderRadius codeBlock = BorderRadius.circular(md);
}
