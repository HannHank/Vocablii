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
  if(userStateVoc[word] != null)
  {
  if(userStateVoc[word]['state'] == "Iknow"){
  color = colors[5];
  }
  else if(userStateVoc[word]['state'] == "notSave"){
     color = colors[2];
  }
  else{
    // state not in index
    color = colors[0];
  }
  }
  else{
    color = colors[3];
  }
  
  return color;
}


