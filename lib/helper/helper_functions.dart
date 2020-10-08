import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Vocablii/vocabulary.dart';
import '../components/vocCard.dart';

Color random_color(List<Color> colors, String word) {
  var random = new Random(word.length);
  var color = colors[random.nextInt(colors.length)];
  return color;
}

generate_cards(Map voc, List<Color> colors) {
  print("lele: " + voc.keys.toList().length.toString());
   List voc_list = List.generate(voc.keys.toList().length, (i) => {
    VocCard(index: i, 
            word: "voc[voc.keys.toList()[i]]['ru']",
            translation: "voc[voc.keys.toList()[i]]['de']",
            description:" voc[voc.keys.toList()[i]]['translation']",
            color: Colors.black,)
  });

 // voc_list.shuffle();
  return voc_list;
  // for(int i = 0; i < voc.length; i++) {
  //   print(voc[i]);
  // }
}