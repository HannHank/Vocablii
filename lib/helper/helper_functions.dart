import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Vocablii/vocabulary.dart';
import '../components/vocCard.dart';

Color get_color(List<Color> colors, String word,Map userStateVoc) {

  Color color;
  if(userStateVoc[word] == "wtf"){
  color = colors[3];

  }else{
    color = colors[0];
  }
  return color;
}


