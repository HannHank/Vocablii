import 'package:flutter/material.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/components/InputField.dart';

class AddVoc extends StatefulWidget{
  static const String route = "addVoc";
  final Map<String, String> args;

  AddVoc(this.args);
  @override
  _AddVoc createState() => _AddVoc();
}
class _AddVoc extends State<AddVoc>{
   final ruController = TextEditingController();
    @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Stack(
        children: [
          basicForm("Russisches Wort", 15, "muss ausgefüllt sein",false, 1,ruController)
        ],
      )

    );
  }
}