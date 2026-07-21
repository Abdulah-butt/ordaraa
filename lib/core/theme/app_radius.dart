import 'package:flutter/widgets.dart';

/// ORDARA radius tokens (Figma: small 8 · medium 12 · large 16 · xlarge 20).
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8; // chips, small controls
  static const double md = 12; // buttons, inputs, list tiles
  static const double lg = 16; // cards
  static const double xl = 20; // sheets, dialogs, hero surfaces
  static const double pill = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius field = BorderRadius.all(Radius.circular(md));
  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius sheet = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
}
