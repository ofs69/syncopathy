import 'package:flutter/material.dart';
import 'package:syncopathy/helper/extensions.dart';

const double speedNormalizationValue = 0.4;
Color get favoriteColor => Colors.amber.shade600;
Color get dislikeColor => Colors.lightBlue.shade500;

BoxDecoration stdBoxShadow() => BoxDecoration(
  color: Colors.transparent,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withAlphaF(0.50),
      blurRadius: 60,
      spreadRadius: 0,
    ),
  ],
);

const List<Color> heatmapColorsBase = [
  Color(0xFF64B5F6), // Colors.blue.shade300,
  Color(0xFF4CAF50), // Colors.green.shade500,
  Color(0xFFFFEB3B), //  Colors.yellow.shade500,
  Color(0xFFE53935), // Colors.red.shade600,
];

const List<Color> heatmapColors = [Colors.transparent, ...heatmapColorsBase];
const List<Color> heatmapGraphColors = [
  Color(0xFF424242), // Colors.grey.shade800
  ...heatmapColorsBase,
];
