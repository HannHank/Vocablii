import 'package:Vocablii/helper/helper_functions.dart';
import 'package:Vocablii/pages/OverView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'helper/initialiseTopicsForUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vocablii/pages/vocabulary.dart';
import 'auth/auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/pages/addVoc.dart';
import 'components/nav.dart';
import 'package:Vocablii/pages/Ranking.dart';
import 'package:Vocablii/pages/OverView.dart';
import 'package:Vocablii/components/doneButton.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
// import 'package:internet_speed_test/internet_speed_test.dart';

class Home extends StatefulWidget {
  static const String route = "Home";
  final Map<String, String> args;

  Home(this.args);
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {
  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  final auth = AuthenticationService(FirebaseAuth.instance);
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  List allTopics = [];
  Map<String, Map> topicData = {};
  Map<String, String> meta = {};
  Map<String, String> title = {};
  Map userStateVoc = {};
  bool show = false;
  bool admin = false;
  int keyboardId;
  String nickName;
  int chunkSize = 0;
  // Error banner for slow internet or trying to learn vocabulary that are empty (https://github.com/HannHank/Vocablii/issues/30)
  Map<String, dynamic> error = {
    'hasError': false,
    'errorIcn': '',
    'errorMsg': 'Deine Internetgeschwindigkeit lässt zu wünschen übrig...',
    'color': Color(0xffED6B6B)
  };

  final SlidableController slidableController = SlidableController(
      // onSlideAnimationChanged: handleSlideAnimationChanged,
      // onSlideIsOpenChanged: handleSlideIsOpenChanged,
      );

  getTopics(userStateVoc) {
    topics.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            setState(() {
              // skipp if not public and no admin
              if (doc.data()['meta']['public'] == true ||
                  userStateVoc['admin'] == true) {
                title[doc.id] = doc.data()['meta']['name'];
                meta[doc.id] = doc.data()['meta']['descr'];
                topicData[doc.id] = doc.data()['vocabulary'];

              }
            });
          }),
        });
  }

  getStateVoc() async {
    await initialiseUserLernState(auth.currentUser()).then((data) => {
          setState(() {
            userStateVoc = data;
            chunkSize = userStateVoc['chunkSize'];
            print("chunkSize: " + chunkSize.toString());
            show = true;
            admin = userStateVoc['admin'];
            // nickName = userStateVoc['nickName'];
          }),
          print("data: " + data.toString()),
          getTopics(userStateVoc)
        });
  }

  getPercent(int all, int known) {
    print("all: " + all.toString() + "known: " + known.toString());
    if (known == null) {
      known = 0;
    }
    if (all == null || all == 0) {
      return 0;
    }
    int percent = (known / all * 100).toInt();
    return percent;
  }

  @override
  void initState() {
    super.initState();
    getStateVoc();
    keyboardId = _keyboardVisibility.addNewListener(
    onShow: () {
      print("open");
      showOverlay(context);
    },
    onHide: (){
      removeOverlay();
    }
  );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: true,
          top: true,
          child: Center(
            child: new Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 5,
                    left: SizeConfig.blockSizeHorizontal * 5,
                    bottom: SizeConfig.blockSizeHorizontal * 5,
                  ),
                  width: double.infinity,
                  child: Row(children: [
                    Text(
                      "Deine Themen",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      textScaleFactor: 2,
                      // has impact
                    )
                  ]),
                ),
                // Error message
                error['hasError']
                    ? GestureDetector(
                        onVerticalDragEnd: (details) => {
                          setState(() {
                            error = {
                              'hasError': false,
                              'errorIcn': '',
                              'errorMsg': '',
                              'color': Color(0xffED6B6B)
                            };
                          }),
                          print(error)
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 5,
                              right: SizeConfig.blockSizeHorizontal * 5),
                          decoration: BoxDecoration(
                              color: error['color'],
                              borderRadius: new BorderRadius.circular(11.0),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 30,
                                  offset: Offset(10, 10),
                                  color: Colors.black.withOpacity(.20),
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: Center(
                              child: Text(
                                error['errorMsg'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffffffff)),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                    child: RefreshIndicator(
                        key: refreshKey,
                        onRefresh: () async {
                          getStateVoc();
                          error = {
                            'hasError': false,
                            'errorIcn': '',
                            'errorMsg': ''
                          };
                        },
                        child: ListView.builder(
                            itemCount: topicData.keys.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return new Column(children: [
                                index == 0
                                    ? SizedBox(
                                        height: SizeConfig.blockSizeVertical)
                                    : SizedBox(),
                                InkWell(
                                  onLongPress: (){
                                    print("long press");
                                      Navigator.pushNamed(
                                          context, OverView.route,
                                          arguments: {
                                            title[topicData.keys
                                                    .toList()[index]]:
                                                topicData[topicData.keys
                                                    .toList()[index]],
                                            'userStateVoc': show
                                                ? userStateVoc
                                                : {
                                                    'admin': false,
                                                    'nickName':'',
                                                    'class': {
                                                      title[topicData.keys
                                                          .toList()[index]]: {}
                                                    }
                                                  },
                                            'user': {
                                              'user': auth.currentUser()
                                            },
                                            'chunkSize': {
                                              'chunkSize': chunkSize
                                            },
                                            'databaseTitle': {
                                              'databaseTitle':
                                                  topicData.keys.toList()[index]
                                            },
                                            'key': {'refresh': refreshKey}
                                          });
                                  },
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, Trainer.route,
                                          arguments: {
                                            title[topicData.keys
                                                    .toList()[index]]:
                                                topicData[topicData.keys
                                                    .toList()[index]],
                                            'userStateVoc': show
                                                ? userStateVoc
                                                : {
                                                    'admin': false,
                                                    'nickName':'',
                                                    'class': {
                                                      title[topicData.keys
                                                          .toList()[index]]: {}
                                                    }
                                                  },
                                            'user': {
                                              'user': auth.currentUser()
                                            },
                                            'chunkSize': {
                                              'chunkSize': chunkSize
                                            },
                                            'databaseTitle': {
                                              'databaseTitle':
                                                  topicData.keys.toList()[index]
                                            },
                                            'key': {'refresh': refreshKey}
                                          });
                                    },
                                    child: Padding(
                                      // Padding around Card component
                                      padding: const EdgeInsets.fromLTRB(
                                          21, 22, 21, 0),
                                      child: Slidable(
                                        controller: slidableController,
                                        actionPane: SlidableBehindActionPane(),
                                        actionExtentRatio: 0.25,
                                        actions: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              Map vocWtf = topicData[topicData
                                                  .keys
                                                  .toList()[index]];

                                              vocWtf.removeWhere((key, value) =>
                                                  [
                                                    'Iknow'
                                                  ].contains(userStateVoc[
                                                              'class'][
                                                          title[topicData.keys
                                                              .toList()[index]]]
                                                      [key]));
                                              if (vocWtf.length == 0) {
                                                slidableController.activeState
                                                    .close();
                                                refreshKey.currentState
                                                    .show()
                                                    .then((value) => {
                                                          setState(() {
                                                            error = {
                                                              'hasError': true,
                                                              'errorIcn': '',
                                                              'errorMsg':
                                                                  'Du kannst alle Vokabeln von diesem Thema🎉👍🏼',
                                                              'color':
                                                                  Colors.green
                                                            };
                                                          }),
                                                        });
                                              } else {
                                                Navigator.pushNamed(
                                                    context, Trainer.route,
                                                    arguments: {
                                                      title[topicData.keys
                                                              .toList()[index]]:
                                                          vocWtf,
                                                      'userStateVoc': show
                                                          ? userStateVoc
                                                          : {
                                                              'admin': false,
                                                              'nickName':'',
                                                              'class': {
                                                                title[topicData
                                                                        .keys
                                                                        .toList()[
                                                                    index]]: {}
                                                              }
                                                            },
                                                      'user': {
                                                        'user':
                                                            auth.currentUser()
                                                      },
                                                      'chunkSize': {
                                                        'chunkSize': chunkSize
                                                      },
                                                      'databaseTitle': {
                                                        'databaseTitle':
                                                            topicData.keys
                                                                .toList()[index]
                                                      },
                                                      'key': {
                                                        'refresh': refreshKey
                                                      }
                                                    });
                                              }
                                            },
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  OverflowBox(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      maxWidth: 130,
                                                      child: SizedBox(
                                                        width: 130,
                                                        height: 70,
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    0xffED6B6B),
                                                                borderRadius:
                                                                    new BorderRadius
                                                                            .circular(
                                                                        11.0),
                                                                boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 30,
                                                                offset: Offset(
                                                                    10, 10),
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .20),
                                                              ),
                                                            ])),
                                                      )),
                                                  Center(
                                                    child: Text('🤫',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                        secondaryActions: <Widget>[
                                          InkWell(
                                              onTap: () {
                                                Map vocIKnow = topicData[
                                                    topicData.keys
                                                        .toList()[index]];

                                                vocIKnow.removeWhere((key,
                                                        value) =>
                                                    [
                                                      'wtf',
                                                      'notSave',
                                                      null
                                                    ].contains(userStateVoc[
                                                        'class'][title[topicData
                                                            .keys
                                                            .toList()[
                                                        index]]][key]));
                                                print(
                                                    "vocIknow: --------------" +
                                                        vocIKnow.toString() +
                                                        " " +
                                                        vocIKnow.length
                                                            .toString());
                                                if (vocIKnow.length == 0) {
                                                  slidableController.activeState
                                                      .close();
                                                  refreshKey.currentState
                                                      .show()
                                                      .then((value) => {
                                                            setState(() {
                                                              error = {
                                                                'hasError':
                                                                    true,
                                                                'errorIcn': '',
                                                                'errorMsg':
                                                                    'Du musst erst lernen!',
                                                                'color': Color(
                                                                    0xffED6B6B)
                                                              };
                                                            }),
                                                          });
                                                } else {
                                                  Navigator.pushNamed(
                                                      context, Trainer.route,
                                                      arguments: {
                                                        title[topicData.keys
                                                                .toList()[
                                                            index]]: vocIKnow,
                                                        'userStateVoc': show
                                                            ? userStateVoc
                                                            : {
                                                                'admin': false,
                                                                'nickName':'',
                                                                'class': {
                                                                  title[topicData
                                                                          .keys
                                                                          .toList()[
                                                                      index]]: {}
                                                                }
                                                              },
                                                        'user': {
                                                          'user':
                                                              auth.currentUser()
                                                        },
                                                        'chunkSize': {
                                                          'chunkSize': chunkSize
                                                        },
                                                        'databaseTitle': {
                                                          'databaseTitle':
                                                              topicData.keys
                                                                      .toList()[
                                                                  index]
                                                        },
                                                        'key': {
                                                          'refresh': refreshKey
                                                        }
                                                      });
                                                }
                                              },
                                              child: Container(
                                                child: Container(
                                                  child: Stack(
                                                    children: [
                                                      OverflowBox(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          maxWidth: 130,
                                                          child: SizedBox(
                                                            width: 130,
                                                            height: 70,
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xff7E92C8),
                                                                    borderRadius:
                                                                        new BorderRadius.circular(
                                                                            11.0),
                                                                    boxShadow: [
                                                                  BoxShadow(
                                                                    blurRadius:
                                                                        30,
                                                                    offset:
                                                                        Offset(
                                                                            10,
                                                                            10),
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .20),
                                                                  ),
                                                                ])),
                                                          )),
                                                      Center(
                                                        child: Text('🤓',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 25)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ))
                                        ],
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        11.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 30,
                                                    offset: Offset(10, 10),
                                                    color: Colors.black
                                                        .withOpacity(.20),
                                                  ),
                                                ]),
                                            child: Padding(
                                              padding:
                                                  // Padding inside Card component
                                                  EdgeInsets.fromLTRB(
                                                      21, 15, 21, 15),
                                              child: Container(
                                                child: new Stack(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: SizeConfig
                                                                  .blockSizeHorizontal *
                                                              65,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                title[topicData
                                                                        .keys
                                                                        .toList()[
                                                                    index]],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              Text(
                                                                meta[topicData
                                                                        .keys
                                                                        .toList()[
                                                                    index]],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Color(
                                                                        0xff000000),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: SizeConfig
                                                                  .blockSizeVertical *
                                                              4.6,
                                                          width: SizeConfig
                                                                  .blockSizeVertical *
                                                              4.6,
                                                          child: Stack(
                                                            children: <Widget>[
                                                              Center(
                                                                child:
                                                                    Container(
                                                                  width: SizeConfig
                                                                          .blockSizeVertical *
                                                                      4.6,
                                                                  height: SizeConfig
                                                                          .blockSizeVertical *
                                                                      4.6,
                                                                  child:
                                                                      new CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        5.0,
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xff000000),
                                                                    valueColor: new AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Color(
                                                                            0xff40FF53)),
                                                                    value: show
                                                                        ? getPercent(topicData[topicData.keys.toList()[index]].keys.toList().length, userStateVoc['class'][title[topicData.keys.toList()[index]]]['percent']).toDouble() /
                                                                            100
                                                                        : 0.0,
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  show
                                                                      ? getPercent(topicData[topicData.keys.toList()[index]].keys.toList().length, userStateVoc['class'][title[topicData.keys.toList()[index]]]['percent'])
                                                                              .toString() +
                                                                          '%'
                                                                      : "0%",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff000000),
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                              ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ),
                                    )),
                                index + 1 == topicData.keys.length
                                    ? SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 20)
                                    : SizedBox()
                              ]);
                            }))),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          admin
              ? Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 5,
                      bottom: SizeConfig.blockSizeVertical),
                  child: FloatingActionButton(
                    heroTag: "add",
                    onPressed: () {
                      Navigator.pushNamed(context, AddVoc.route,
                          arguments: {'title':title,'uid':auth.currentUser().uid});
                    },
                    child: Icon(Icons.add),
                  ),
                )
              : Padding(
                  padding:
                      EdgeInsets.only(bottom: SizeConfig.blockSizeVertical,
                      left: SizeConfig.blockSizeHorizontal * 5,),
                  child: FloatingActionButton(
                    heroTag: 'rankingCentered',
                      onPressed: () {
                      Navigator.pushNamed(context, Ranking.route,
                          arguments: {'nickName':userStateVoc['nickName'].toString(),'uid': auth.currentUser().uid.toString()});
                    },
                      child: Icon(Icons.military_tech_outlined))),

            
              admin ? Padding(
                  padding:
                      EdgeInsets.only(bottom: SizeConfig.blockSizeVertical),
                  child: FloatingActionButton(
                      heroTag: 'ranking',
                  onPressed: () {
                      Navigator.pushNamed(context, Ranking.route,
                          arguments: {'nickName':userStateVoc['nickName'] == null ? '':userStateVoc['nickName'].toString(),'uid': auth.currentUser().uid.toString()});
                    },
                      child: Icon(Icons.military_tech_outlined)),
                )
              : SizedBox(),

          Padding(
            padding: EdgeInsets.only(
                right: SizeConfig.blockSizeHorizontal * 5,
                bottom: SizeConfig.blockSizeVertical),
            child: Nav(auth, refreshKey),
          )
        ]));
  }
}
