import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Vocablii/vocabulary.dart';
import '../components/vocCard.dart';

Color get_color(List<Color> colors, String word,Map userStateVoc) {

  Color color;
  if(userStateVoc[word] == "Iknow"){
  color = colors[5];
  }
  else if(userStateVoc[word] == "notSave"){
     color = colors[1];
  }else{
    color = colors[1];
  }
  return color;
}


