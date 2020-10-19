import 'package:Vocablii/components/InputField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class VocCard extends StatefulWidget {
  final int index;
  String word;
  String translation;
  String description;
  Map stateCard;
  bool expanded;
  final Function remove;
  final Function move;
  final User user;
  final bool adminState;
  final String name;
  final String title;
  final String databaseTitle;
  String state;
  VocCard(
      {this.index,
      this.word,
      this.translation,
      this.description,
      this.stateCard,
      this.expanded,
      this.move,
      this.user,
      this.name,
      this.title,
      this.databaseTitle,
      this.remove,
      this.adminState});

  @override
  _VocCardState createState() => _VocCardState(
      stateCard: stateCard, word: word, translation: translation, descr: description);
}

class _VocCardState extends State<VocCard> {
  Map stateCard;
  String word;
  String translation;
  String descr;
  String url;
  int percent;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');
  final ruController = TextEditingController();
  final deController = TextEditingController();
  final descrController = TextEditingController();
  final assetsAudioPlayer = AssetsAudioPlayer();

  _VocCardState({this.stateCard, this.word, this.translation, this.descr});
  saveNewContent() {
    setState(() {
      widget.word = ruController.text.trim();
      widget.translation = deController.text.trim();
      widget.description = descrController.text.trim();
      if (descrController.text.trim() == "") {
        widget.description = "0";
      }
      // need to be dynamic
      topics.doc(widget.databaseTitle).update({
        "vocabulary." + widget.name: {
          "de": widget.translation,
          "desc": widget.description,
          "ru": widget.word
        }
      });
    });
  }

  deleteCard() async {
    Map data;
    await topics
        .doc(widget.databaseTitle)
        .get()
        .then((snapshot) => {
          data = snapshot.data()
        });
    data['vocabulary'].removeWhere((key, value) => key == widget.name);
    await topics.doc(widget.databaseTitle).update(data);
     
  }

  updateState(state) async {
    setState(() {
       widget.stateCard['state'] = state;
    });
  }

  updateDatabase(state) async {
    await users.doc(widget.user.uid).get().then(
        (snapshot) => {percent = snapshot['class'][widget.title]['percent']});
    if (state == "wtf" && percent != 0 && widget.state != "wtf") {
      percent -= 1;
    } else if (state == "Iknow" && widget.state != "Iknow") {
      percent += 1;
    } else {
      // do nothing
    }
    try {
      // url = await FirebaseStorage().ref().child('/vocabulary_audio/' + word.toString() + '.mp3').getDownloadURL();
      url = await FirebaseStorage()
          .ref()
          .child('/vocabulary_audio/word.mp3')
          .getDownloadURL();

      // await assetsAudioPlayer.open(
      //   Audio.network(url),
      // );
    } catch (e) {
      print(e);
    }
    setState(() {
      print("state bevor: " + widget.state.toString());
      users.doc(widget.user.uid).update({
        'class.' + widget.title + "." + widget.name: state,
        'class.' + widget.title + "." + "percent": percent
      });
    });
  }

  void play() {
     assetsAudioPlayer.play();
  }

  void change() {
    play();
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
    ScreenUtil.init(context, designSize: Size(1080 , 1920), allowFontScaling: false);
    return widget.expanded
        ? InkWell(
            borderRadius: new BorderRadius.circular(30),
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(5, 5),
                        blurRadius: 10,
                        color: Color(0x80000000))
                  ],
                  color: widget.stateCard['color'],
                  borderRadius: new BorderRadius.circular(30)),
              width: 950.w,
              height: 1500.h,
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
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(widget.word,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800)),
                              Text(widget.translation,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                    onPressed: () {
                                      play();
                                    },
                                    child: Icon(Icons.play_arrow_rounded,
                                        color: Colors.white),
                                  ),
                                  widget.adminState ? FlatButton(
                                    onPressed: () {
                                      deleteCard();
                                      widget.remove();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ):SizedBox(),
                                   widget.adminState ? FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        ruController.text = widget.word;
                                        deController.text = widget.translation;
                                        descrController.text =
                                            widget.description;
                                      });
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) => Container(
                                              margin: EdgeInsets.only(
                                                  left: 60.w,
                                                  right: 60.w,
                                                  bottom: 100.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  50.h, 50.h, 50.h, 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30)),
                                            width: 950.w,
                                            height: 1600.h,
                                              child: Center(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 30,
                                                                offset: Offset(
                                                                    -11, -11),
                                                                color: Color(
                                                                    0x9900000))
                                                          ]),
                                                      child: Center(
                                                          child: Column(
                                                        children: [
                                                          Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // Settings
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              0,
                                                                          bottom:
                                                                              7.h),
                                                                  child: Text(
                                                                    'VoKabel bearbeiten',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                                basicForm(
                                                                    "Russisch",
                                                                    12,
                                                                    "not working",
                                                                    false,
                                                                    1,
                                                                    ruController),
                                                                basicForm(
                                                                    "Deutsch",
                                                                    12,
                                                                    "not working",
                                                                    false,
                                                                    1,
                                                                    deController),
                                                                basicForm(
                                                                    "Beschreibung",
                                                                    12,
                                                                    "not working",
                                                                    false,
                                                                    null,
                                                                    descrController),
                                                                Center(
                                                                    child:
                                                                        Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              25.h),
                                                                  child:
                                                                      FloatingActionButton(
                                                                    onPressed:
                                                                        () {
                                                                      saveNewContent();
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Icon(
                                                                        Icons
                                                                            .save),
                                                                  ),
                                                                )),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ))))));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ):SizedBox(),
                                ],
                              ),
                              Text(widget.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.only(right: 135.h,bottom: 300.h, left:120.h),
                            //margin: EdgeInsets.all(130.h),
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
                            padding: EdgeInsets.only(bottom: 80.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    child: Stack(children: [
                                  FlatButton(
                                    color: Colors.white,
                                    height: 170.h,
                                    minWidth: 170.w,
                                    onPressed: () async{
                                     await updateState("Iknow");
                                     updateDatabase("Iknow");
                                     await widget.move();
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
                                    height: 170.h,
                                    minWidth: 170.h,
                                    onPressed: () {
                                      updateState("notSave");
                                      updateDatabase("notSave");
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
                                  height: 170.h,
                                  minWidth: 170.h,
                                  onPressed: () {
                                    updateState("wtf");
                                    updateDatabase("wtf");
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
            borderRadius: new BorderRadius.circular(30),
            onLongPress: () {
              change();
            },
            onTap: widget.move,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(5, 5),
                        blurRadius: 10,
                        color: Color(0x80000000))
                  ],
                  color: widget.stateCard['color'],
                  borderRadius: new BorderRadius.circular(30)),
              width: 950.w,
              height: 1500.h,
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
