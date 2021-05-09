import 'package:flutter/material.dart';

Widget basicForm(String name, double fontSize, String errmsg, bool _obscureText,
    dynamic _maxLine, TextEditingController controller,
    {double height = 200}) {
  return Container(
      constraints: BoxConstraints(maxHeight: height),
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
            textInputAction: TextInputAction.done,
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
            maxLines: _maxLine,
            maxLength: null,
            style:
                TextStyle(fontSize: fontSize, height: 1.6, color: Colors.black),
            obscureText: _obscureText
            // controller: _locationNameTextController,
            ),
      ));
}
