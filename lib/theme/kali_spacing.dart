import 'package:flutter/material.dart';

/// Spacing-Tokens. Base Unit: 8px
/// Alle Abstände sind Vielfache von 8px (außer 4px für Feinjustierung).
class KaliSpacing {
  KaliSpacing._();

  static const double xxs = 2;
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 48;

  // Convenience EdgeInsets
  static const EdgeInsets paddingXS = EdgeInsets.all(4);
  static const EdgeInsets paddingSM = EdgeInsets.all(8);
  static const EdgeInsets paddingMD = EdgeInsets.all(16);
  static const EdgeInsets paddingLG = EdgeInsets.all(24);
  static const EdgeInsets paddingXL = EdgeInsets.all(32);

  static const EdgeInsets paddingScreenH = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets paddingScreenV = EdgeInsets.symmetric(vertical: 32);
}
