import 'package:flutter/material.dart';

/// Elevation-Tokens (minimal — Flat Design First)
class KaliElevation {
  KaliElevation._();

  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x20000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> none = <BoxShadow>[];
}
