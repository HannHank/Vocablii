import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Vocablii/vocabulary.dart';
import '../components/vocCard.dart';

  List<Color> colors = [
    Color(0xff2B969D),
    Color(0xff2B529D),
    Color(0xff862B9D),
    Color(0xff953232),
    Color(0xff3B7626),
    Color(0xff328D93),
  ];

Color get_color(String word,Map userStateVoc) {

  Color color;
  if(userStateVoc[word] == "Iknow"){
  color = colors[5];
  }
  else if(userStateVoc[word] == "notSave"){
     color = colors[4];
  }else{
    color = colors[1];
  }
  return color;
}


