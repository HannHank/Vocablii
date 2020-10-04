import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_stack_card/flutter_stack_card.dart';
import 'package:flutter/material.dart';
import 'card/card.dart';
import 'package:Vocablii/login.dart';
import 'auth/auth.dart';
import 'package:Vocablii/helper/helper_functions.dart';

class Trainer extends StatefulWidget {
  static const String route = "vocabulary";
  final Map<String, Map> args;

  Trainer(this.args);
  @override
  State<StatefulWidget> createState() {
    return _Trainer();
  }
}

class _Trainer extends State<Trainer> {
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');
  TCardController _controller = TCardController();
  String paul = "Hallo";
  Map voc = {};
  Map voc_shuffeled = {};
  int currentIndex;
  bool state = true;

  List<Widget> vocs = [];

  List<Color> colors = [
    Color(0xff2B969D),
    Color(0xff2B529D),
    Color(0xff862B9D),
    Color(0xff953232),
    Color(0xff3B7626),
    Color(0xff328D93),
  ];

  VocCards voc1;
  VocCards voc2;
  VocCards voc3;

  @override
  void initState() {
    super.initState();
    setState(() {
      voc = widget.args[widget.args.keys.toList()[0]];
      voc_shuffeled = shuffle_map(voc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  if (state) {
                    setState(() {
                      state = false;
                    });
                  } else {
                    setState(() {
                      state = true;
                    });
                  }
                },
                child:
                    ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return state
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: random_color(colors, voc_shuffeled[voc_shuffeled.keys.toList()[index]]['ru'].toString()),
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            child: Center(
                              child: Text(
                                voc_shuffeled[voc_shuffeled.keys.toList()[index]]['ru'].toString(),
                                style: TextStyle(
                                    fontSize: 50.0, color: Colors.white),
                              ),
                            ))
                        : Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: random_color(colors, voc_shuffeled[voc_shuffeled.keys.toList()[index]]['ru'].toString()),
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                            child: Center(
                                child: Column(children: [
                              Text(
                                voc_shuffeled[voc_shuffeled.keys.toList()[index]]['de'].toString(),
                                style: TextStyle(
                                    fontSize: 50.0, color: Colors.white),
                              ),
                              Text(voc[voc.keys.toList()[index]]['desc'].toString(), style: TextStyle(fontSize: 50.0, color: Colors.white)),
                            ])));
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class VocCards {
  Color color;
  String word;
  String translation;
  String descr;
  VocCards({this.color, this.word, this.translation, this.descr});
}
