import 'package:flutter/material.dart';

/*
  Extension method because withOpacity is deprecated and IDGAF about precision
 */
extension WithOpacity on Color {
  Color withAlphaF(double alpha) {
    return withAlpha((255.0 * alpha).clamp(0.0, 255.0).round());
  }
}
