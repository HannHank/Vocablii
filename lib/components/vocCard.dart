import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vocablii/helper/helper_functions.dart';

class VocCard extends StatefulWidget {
  final int index;
  final String word;
  final String translation;
  String description;
  Color color;
  bool expanded;
  final Function move;
  final String user;
  final String name;
  final String title;
  Map state;
  VocCard(
      {this.index,
      this.word,
      this.translation,
      this.description,
      this.color,
      this.expanded,
      this.move,
      this.user,
      this.name,
      this.title});

  @override
  _VocCardState createState() => _VocCardState(
      color: color, word: word, translation: translation, descr: description);
}

class _VocCardState extends State<VocCard> {
  Color color;
  String word;
  String translation;
  String descr;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  _VocCardState({this.color, this.word, this.translation, this.descr});
  updateState(state) {
    setState(() {
      widget.state = {'state':state,'ru':widget.word,'de':widget.translation,'descr':widget.description};
      Map stateVoc = {};
      stateVoc[widget.name] = state;
      users.doc(widget.user.toString()).update({
        'class.' + widget.title +"."+widget.name:{'state':state,'ru':widget.word,'de':widget.translation,'descr':widget.description}
      });
    });
  }

  void change() {
    setState(() {
      widget.expanded = true;
      if (widget.description == "0") {
        widget.description = "";
      }
    });
  }

  void fold() {
    setState(() {
      widget.expanded = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.expanded
        ? InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: new BorderRadius.circular(30)),
              width: 350,
              height: 600,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        blurRadius: 30,
                        offset: Offset(-11, -11),
                        color: Color(0x9900000))
                  ]),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.word,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800)),
                            Text(widget.translation,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800)),
                            Text(widget.description,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.only(bottom: 80),
                            margin: EdgeInsets.all(50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "easy",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "naja...",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "wtf",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    child: Stack(children: [
                                  FlatButton(
                                    color: Colors.white,
                                    height: 80,
                                    minWidth: 80,
                                    onPressed: () {
                                      updateState("Iknow");
                                      widget.move();
                                      fold();
                                    },
                                    child: Text(
                                      "👍",
                                      style: TextStyle(fontSize: 35),
                                    ),
                                    shape: StadiumBorder(),
                                  )
                                ])),
                                Container(
                                  child: FlatButton(
                                    color: Colors.white,
                                    height: 80,
                                    minWidth: 80,
                                    onPressed: () {
                                      updateState("notSave");
                                      widget.move();
                                      fold();
                                    },
                                    child: Text(
                                      "🤔",
                                      style: TextStyle(fontSize: 35),
                                    ),
                                    shape: StadiumBorder(),
                                  ),
                                ),
                                Container(
                                    child: FlatButton(
                                  color: Colors.white,
                                  height: 80,
                                  minWidth: 80,
                                  onPressed: () {
                                    updateState("wtf");
                                    widget.move();
                                    fold();
                                  },
                                  child: Text(
                                    "🙈",
                                    style: TextStyle(fontSize: 35),
                                  ),
                                  shape: StadiumBorder(),
                                )),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : InkWell(
            onLongPress: () {
              change();
            },
            onTap: widget.move,
            child: Container(
              decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: new BorderRadius.circular(30)),
              width: 350,
              height: 600,
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.word,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ));
  }
}
