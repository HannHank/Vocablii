import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_stack_card/flutter_stack_card.dart';
import 'package:flutter/material.dart';
import 'card/card.dart';
import 'package:Vocablii/login.dart';
import 'auth/auth.dart';
import 'dart:math';





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
  int currentIndex;
  bool state = true;

  List<Widget> vocs = [];
 List<Color> colors = [
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.orange,
  Colors.pink,
  Colors.amber,
  Colors.cyan,
  Colors.purple,
  Colors.brown,
  Colors.teal,
];


  // var colors = <int>[
  //   0xff2B969D,
  //   0xff2B529D,
  //   0xff862B9D,
  //   0xff953232,
  //   0xff3B7626,
  //   0xff328D93
  // ];

  var random = new Random();

  VocCards voc1;
  VocCards voc2;
  VocCards voc3;

  @override
  void initState() {
    super.initState();
    setState(() {
      voc = widget.args[widget.args.keys.toList()[0]];
      // voc.forEach((key, value) {
      //   vocs.add(
      //     FancyCard
      //     (
      //       value["ru"]
      //   ),
      //  ) ;
    });
    print("voc: " + voc.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Expanded(child:InkWell(
              onTap: (){
                print("yes");
                print("state: " + state.toString());
                if(state){
                  setState(() {
                    state = false;
                  });
                }else{
                   setState(() {
                    state = true;
                  });
                }
              },
              child:
            // TCard(
            //   cards: 
            ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext ctxt, int index) {
             
                return state ? Container(
                  
                  alignment: Alignment.center,
                   decoration: BoxDecoration(
                    color: colors[0],
                    borderRadius:
                        new BorderRadius.circular(20.0),
                    ),
                  child: Center(child:Text(
                    voc[voc.keys.toList()[index]]['ru'].toString(),
                    style: TextStyle(fontSize: 50.0, color: Colors.white),
                  ),)
                ):Container(
                  
                  alignment: Alignment.center,
                   decoration: BoxDecoration(
                    color: colors[0],
                    borderRadius:
                        new BorderRadius.circular(20.0),
                    ),
                  child: Center(child:Column(children: [
                    Text(
                      voc[voc.keys.toList()[index]]['de'].toString(),
                      style: TextStyle(fontSize: 50.0, color: Colors.white),
                    ),
                    // Text(voc[voc.keys.toList()[index]]['desc'].toString(), style: TextStyle(fontSize: 50.0, color: Colors.white)),
                  ]))
                );
              },
              ),
              // size: Size(400, 700),
              // controller: _controller,
              // onForward: (index, info) {
              //   print(index);
              // },
              // onBack: (index) {
              //   print(index);
              // },
              // onEnd: () {
              //   print('end');
              // },
            // ),
            // )
            ),
            ),
            SizedBox(
              height: 40,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     OutlineButton(
            //       onPressed: () {
            //         print(_controller);
            //         _controller.back();
            //       },
            //       child: Text('Back'),
            //     ),
            //     OutlineButton(
            //       onPressed: () {
            //         _controller.reset();
            //       },
            //       child: Text('Reset'),
            //     ),
            //     OutlineButton(
            //       onPressed: () {
            //         _controller.forward();
            //       },
            //       child: Text('Forward'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );

    // child: ListView.builder(
    //     itemCount: 3,
    //     itemBuilder: (BuildContext ctxt, int index) {
    //       return new InkWell(
    //           onTap: () {},
    //           child: Container(
    //               height: 100,
    //               decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: new BorderRadius.circular(20.0),
    //                   boxShadow: [
    //                     BoxShadow(
    //                         blurRadius: 8,
    //                         offset: Offset(0, 15),
    //                         color: Colors.grey.withOpacity(.6),
    //                         spreadRadius: -9),
    //                   ]),
    //               child: Center(
    //                   child: Column(
    //                 children: <Widget>[
    //                   Text("Hallo"),
    //                 ],
    //               ))));
    //     })),
  }
}

class VocCards {
  Color color;
  String word;
  String translation;
  String descr;
  VocCards({this.color, this.word, this.translation, this.descr});
}
