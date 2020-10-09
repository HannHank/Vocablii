import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Vocablii/vocabulary.dart';
import '../components/vocCard.dart';

Color random_color(List<Color> colors, String word) {
  var random = new Random(word.length);
  var color = colors[random.nextInt(colors.length)];
  return color;
}


