import 'package:flutter/material.dart';

Widget basicForm(String name, double fontSize, String errmsg,
    TextEditingController controller) {
  return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[600], blurRadius: 10, offset: Offset(4, 4)),
          ]),
      child: Padding(
        padding: EdgeInsets.all(2),
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
          style: TextStyle(fontSize: fontSize, height: 1.6, color: Colors.black),
          // controller: _locationNameTextController,
        ),
      ));
}
