import 'package:flutter/material.dart';

Widget settingButton(String icon, String text, Function action) {
  return Container(
    margin: EdgeInsets.only(top: 5, bottom: 5),
    child: InkWell(
      onTap:action,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[600],
                  blurRadius: 10,
                  offset: Offset(4, 4)),
            ]),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              // TODO: make dynamic
              Padding(padding: EdgeInsets.only(right: 5), child: Text(icon)),
              Text(text)
            ],
          ),
        ),
      ),
    ),
  );
}
