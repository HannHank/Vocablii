import 'dart:ffi';

import 'package:flutter/material.dart';

Widget basicForm(String name,double fontSize,double height, String errmsg, TextEditingController controller) {
        return Container(
            height: height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, 15),
                      color: Colors.grey.withOpacity(.6),
                      spreadRadius: -9),
                ]),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  isDense: true,
                  counterText: "",
                  contentPadding: EdgeInsets.all(10.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: name),
              textAlign: TextAlign.start,
              maxLines: 1,
              maxLength: 20,
              style:
                  TextStyle(fontSize: fontSize, height: 1.6, color: Colors.black),
              // controller: _locationNameTextController,
            ));
      
}
