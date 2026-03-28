import 'package:flutter/material.dart';

/// Animation-Duration-Tokens
class KaliDurations {
  KaliDurations._();

  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast    = Duration(milliseconds: 150);
  static const Duration normal  = Duration(milliseconds: 200);
  static const Duration medium  = Duration(milliseconds: 250);
  static const Duration slow    = Duration(milliseconds: 300);
  static const Duration cursor  = Duration(milliseconds: 500);
  static const Duration spinner = Duration(milliseconds: 1000);
  static const Duration pulsing  = Duration(milliseconds: 800);
  static const Duration skeleton = Duration(milliseconds: 1500);
}

/// Standard-Curves für die App.
class KaliCurves {
  KaliCurves._();

  static const Curve screenTransition = Curves.easeOutCubic;
  static const Curve bubbleAppear     = Curves.easeOut;
  static const Curve cursorBlink      = Curves.easeInOut;
  static const Curve bottomSheet      = Curves.easeOutQuart;
  static const Curve fadeIn           = Curves.easeOut;
  static const Curve fadeOut          = Curves.easeIn;
  static const Curve slideUp          = Curves.easeOut;
  static const Curve scaleIn          = Curves.easeOut;
}
