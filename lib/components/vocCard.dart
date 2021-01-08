import 'package:Vocablii/components/InputField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/components/custom_icons.dart';

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
  String nickName;
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
      this.adminState,
      this.nickName});

  @override
  _VocCardState createState() => _VocCardState(
      stateCard: stateCard,
      word: word,
      translation: translation,
      descr: description);
}

class _VocCardState extends State<VocCard> {
  Map stateCard;
  String word;
  String translation;
  String descr;
  String url;
  int percent;
  int active;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');
  CollectionReference ranking = FirebaseFirestore.instance.collection('ranking');
  CollectionReference deleted =
      FirebaseFirestore.instance.collection('deleted');
  final ruController = TextEditingController();
  final deController = TextEditingController();
  final descrController = TextEditingController();
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool audioNotFound = false;

  _VocCardState({this.stateCard, this.word, this.translation, this.descr});
  saveNewContent() {
    setState(() {
      audioNotFound = false;
      widget.word = ruController.text.trim();
      widget.translation = deController.text.trim();
      widget.description = descrController.text.trim();
      if (descrController.text.trim() == "") {
        widget.description = "0";
      }
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Karte löschen"),
          content: new Text(widget.word),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("cancel"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("delete"),
              onPressed: () async {
                Navigator.of(context).pop();
                Map data;
                await topics
                    .doc(widget.databaseTitle)
                    .get()
                    .then((snapshot) => {data = snapshot.data()});
                data['vocabulary']
                    .removeWhere((key, value) => key == widget.name);
                await topics.doc(widget.databaseTitle).update(data);
                await deleted.doc(widget.databaseTitle).set({
                  widget.name: {
                    'ru': widget.word,
                    'desc': widget.description,
                    'de': widget.translation,
                    'deletedBy': widget.user.uid,
                    'timeStamp': DateTime.now()
                  }
                }, SetOptions(merge: true));
                widget.remove();
              },
            ),
          ],
        );
      },
    );
  }

  updateState(state) async {
    setState(() {
      widget.stateCard['state'] = state;
    });
  } 
  
  updateDatabase(state) async {
    String oldState = widget.stateCard['state'];
    await updateState(state);
    await users.doc(widget.user.uid).get().then(
        (snapshot) => {
        percent = snapshot['class'][widget.title]['percent'],
        active = snapshot['active']
        });
    print("stateCard: " + oldState.toString());
    print("stateReceived: " + state.toString());
    print("percent: " + percent.toString());
    if (state == "wtf" &&
        percent != 0 &&
        oldState == "Iknow") {
        percent -= 1;
        active -= 1;
    }
    else if (state == "notSave" &&
        oldState == "Iknow" &&
        percent != 0) {
        percent -= 1;
        active -= 1;
    } else if (state == "Iknow" && oldState != "Iknow") {
      percent += 1;
      active += 1;
    } else {
      // do nothing
    }
   
    setState(() {
      print("state bevor: " + oldState.toString());
      print("setting percent: " + percent.toString());
      users.doc(widget.user.uid).update({
        'active':active,
        'class.' + widget.title + "." + widget.name: state,
        'class.' + widget.title + "." + "percent": percent
      });
      print("NickName" + widget.nickName.toString());
      if(widget.nickName != null){
        if(widget.nickName != ''){

         ranking.doc(widget.nickName).set({
         'active':active
      });
        }
      }
    });
    
  }

  void play(vocToSpeak) async {
    try {
      print("word:   ----" +  vocToSpeak.toString());
      url = await FirebaseStorage()
          .ref()
          .child('vocabulary_audio/' + vocToSpeak.toString() + '.mp3')
          .getDownloadURL();

      await assetsAudioPlayer.open(Audio.network(url),
          autoStart: true, showNotification: false);
    } catch (e) {
      setState((){
        audioNotFound = true;
      }); 
      
      print(e);
    }
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
    print("user: " + widget.user.toString());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
              width: SizeConfig.blockSizeHorizontal * 88,
              height: SizeConfig.blockSizeVertical * 77,
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
                                      fontWeight: FontWeight.w500)),
                              Text(widget.translation,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                    onPressed: () {
                                      play(widget.word);
                                    },
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  widget.adminState
                                      ? FlatButton(
                                          onPressed: () {
                                            deleteCard();
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        )
                                      : SizedBox(),
                                  widget.adminState
                                      ? FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              ruController.text = widget.word;
                                              deController.text =
                                                  widget.translation;
                                              descrController.text =
                                                  widget.description;
                                            });
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) => Container(
                                                    margin: EdgeInsets.only(
                                                        left: SizeConfig
                                                                .blockSizeHorizontal *
                                                            5,
                                                        right: SizeConfig
                                                                .blockSizeHorizontal *
                                                            5,
                                                        bottom: SizeConfig
                                                                .blockSizeVertical *
                                                            8.3),
                                                    padding: EdgeInsets.fromLTRB(
                                                        SizeConfig.blockSizeHorizontal *
                                                            5,
                                                        SizeConfig.blockSizeHorizontal *
                                                            5,
                                                        SizeConfig.blockSizeHorizontal *
                                                            5,
                                                        0),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            new BorderRadius.circular(
                                                                30)),
                                                    width: SizeConfig.blockSizeHorizontal * 90,
                                                    height: SizeConfig.blockSizeVertical * 80,
                                                    child: Center(
                                                        child: Container(
                                                            decoration: BoxDecoration(boxShadow: [BoxShadow(blurRadius: 30, offset: Offset(-11, -11), color: Color(0x9900000))]),
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
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                SizeConfig.blockSizeHorizontal * 5),
                                                                        child:
                                                                            Text(
                                                                          'Vokabel bearbeiten',
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 14),
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
                                                                            EdgeInsets.all(SizeConfig.blockSizeHorizontal *
                                                                                10),
                                                                        child:
                                                                            FloatingActionButton(
                                                                          onPressed:
                                                                              () {
                                                                            saveNewContent();
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Icon(Icons.save),
                                                                        ),
                                                                      )),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ))))));
                                          },
                                          child: Icon(Icons.edit,
                                              color: Colors.white),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              audioNotFound
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xffffffff),
                                          borderRadius:
                                              BorderRadius.circular(11)),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            SizeConfig.blockSizeHorizontal * 2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                '⛔️ Tut uns leid, die Audio ist nicht verfügbar',
                                                textAlign: TextAlign.center)
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                
                                height: SizeConfig.blockSizeVertical * 40,
                                
                                 child:   SingleChildScrollView(
                                      
                                      scrollDirection: Axis.vertical,
                                 
                                      child: Column(
                                        children: <Widget>[
                                            Text(widget.description,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ))
                                        ],
                                      ),
                                  )
                                  
                                
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.only(
                                right: SizeConfig.blockSizeHorizontal * 14,
                                bottom: SizeConfig.blockSizeVertical * 16,
                                left: SizeConfig.blockSizeHorizontal * 12),
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
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.blockSizeVertical * 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    child: Stack(children: [
                                  FlatButton(
                                    color: Colors.white,
                                    height: SizeConfig.blockSizeVertical * 9.5,
                                    minWidth:
                                        SizeConfig.blockSizeVertical * 9.5,
                                    onPressed: () async {
                                      updateDatabase("Iknow");
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
                                    height: SizeConfig.blockSizeVertical * 9.5,
                                    minWidth:
                                        SizeConfig.blockSizeVertical * 9.5,
                                    onPressed: () async {
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
                                  height: SizeConfig.blockSizeVertical * 9.5,
                                  minWidth: SizeConfig.blockSizeVertical * 9.5,
                                  onPressed: () async {
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
              width: SizeConfig.blockSizeHorizontal * 88,
              height: SizeConfig.blockSizeVertical * 77,
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.word,
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                      // FlatButton(
                      //   onPressed: () {
                      //     play();
                      //   },
                      //   child: Icon(
                      //     Icons.play_arrow_rounded,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      // audioNotFound
                      //     ? Container(
                      //         margin: EdgeInsets.only(
                      //             left: SizeConfig.blockSizeHorizontal * 5,
                      //             right: SizeConfig.blockSizeHorizontal * 5),
                      //         decoration: BoxDecoration(
                      //             color: Color(0xffffffff),
                      //             borderRadius: BorderRadius.circular(11)),
                      //         child: Padding(
                      //           padding: EdgeInsets.all(
                      //               SizeConfig.blockSizeHorizontal * 2),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Text(
                      //                   '⛔️ Wir haben das Audio nicht gefunden 🙁',
                      //                   textAlign: TextAlign.center)
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //     : Container()
                    ],
                  ),
                ),
              ),
            ));
  }
}
