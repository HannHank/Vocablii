import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Vocablii/vocabulary.dart';

Color random_color(List<Color> colors, String word) {
  var random = new Random(word.length);
  var color = colors[random.nextInt(colors.length)];
  return color;
}

List generate_cards(Map voc, List<Color> colors) {
  List voc_list = List.generate(voc.length, (i) => {
    VocCard(index: i, 
            word: voc[i].ru,
            translation: voc[i].de,
            description: voc[i].desc,
            color: random_color(colors, voc[i].descr)),
  });

  voc_list.shuffle();
  return voc_list;
  // for(int i = 0; i < voc.length; i++) {
  //   print(voc[i]);
  // }
}