import 'dart:math';
import 'package:flutter/material.dart';

Map shuffle_map(Map items) {
  var items_shuffeled = {};

  var keys = items.keys.toList()..shuffle(); 
  for(var k in keys) { 
    items_shuffeled[k] = items[k];
  }

  return items_shuffeled;
}

Color random_color(List<Color> colors, String word) {
  var random = new Random(word.length);
  var color = colors[random.nextInt(colors.length)];
  return color;
}