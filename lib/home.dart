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
  int chunkSize = 0;
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
<<<<<<< HEAD

  getPercentagePadding(percent) {
    print("percent: " + percent.toString());
    if (percent <= 100 && percent >= 10) {
      print("2 digits ");
      return SizeConfig.blockSizeHorizontal * 2;
    } else if (percent <= 10) {
      print("1 digit ");
      return SizeConfig.blockSizeHorizontal * 2;
    } else {
      print("3 digits ");
      return SizeConfig.blockSizeHorizontal * 2;
    }
  }

=======
  getPercentagePadding(percent){
    print("percent: " + percent.toString());
      if(percent <= 100 && percent >= 10){
        print("2 digits ");
        return SizeConfig.blockSizeHorizontal * 2.5;
      } else if (percent <= 10){
         print("1 digits ");
          return SizeConfig.blockSizeHorizontal * 3;
      }else{
         print("3 digits ");
        return SizeConfig.blockSizeHorizontal * 1.6;
      }
      
  }
>>>>>>> eb2a9f85c0c8e6316af0cd91b08c8c76a7494563
  getStateVoc() async {
    await initialiseUserLernState(auth.currentUser()).then((data) => {
          setState(() {
            userStateVoc = data;
            chunkSize = userStateVoc['chunkSize'];
            print("chunkSize: " + chunkSize.toString());
            show = true;
            admin = userStateVoc['admin'];
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
    int percent = (known / all * 100).toInt();
    return percent;
  }

  @override
  void initState() {
    super.initState();
    getStateVoc();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
<<<<<<< HEAD
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
                      left: SizeConfig.blockSizeHorizontal * 5),
                  width: double.infinity,
                  child: Text(
                    "Deine Themen",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    textScaleFactor: 2,
                    // has impact
                  ),
                ),
                Expanded(
                    child: RefreshIndicator(
                        key: refreshKey,
                        onRefresh: () async {
                          getStateVoc();
                        },
                        child: ListView.builder(
                            itemCount: topicData.keys.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return new InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, Trainer.route,
                                        arguments: {
                                          title[topicData.keys.toList()[index]]:
                                              topicData[topicData.keys
                                                  .toList()[index]],
                                          'userStateVoc': show
                                              ? userStateVoc
                                              : {
                                                  'admin': false,
                                                  'class': {
                                                    title[topicData.keys
                                                        .toList()[index]]: {}
                                                  }
                                                },
                                          'user': {'user': auth.currentUser()},
                                          'chunkSize': {'chunkSize': chunkSize},
                                          'databaseTitle': {
                                            'databaseTitle':
                                                topicData.keys.toList()[index]
                                          },
                                          'key': {'refresh': refreshKey}
                                        });
                                  },
                                  child: Padding(
                                    // Padding around Card component
                                    padding:
                                        const EdgeInsets.fromLTRB(21, 9, 21, 9),
                                    child: Slidable(
                                      actionPane: SlidableBehindActionPane(),
                                      actionExtentRatio: 0.25,
                                      actions: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Map vocWtf = topicData[
                                                topicData.keys.toList()[index]];

                                            vocWtf.removeWhere((key, value) => [
                                                  'Iknow'
                                                ].contains(userStateVoc['class']
                                                        [title[topicData.keys
                                                            .toList()[index]]]
                                                    [key]));
=======
    return RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          getStateVoc();
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: new Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 5,
                        left: SizeConfig.blockSizeHorizontal * 5),
                    width: double.infinity,
                    child: Text(
                      "Deine Themen",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                      textScaleFactor: 2,
                      // has impact
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: topicData.keys.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return new InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, Trainer.route,
                                      arguments: {
                                        title[topicData.keys.toList()[index]]:
                                            topicData[
                                                topicData.keys.toList()[index]],
                                        'userStateVoc': show
                                            ? userStateVoc
                                            : {
                                                'admin': false,
                                                'class': {
                                                  title[topicData.keys
                                                      .toList()[index]]: {}
                                                }
                                              },
                                        'user': {'user': auth.currentUser()},
                                        'chunkSize':{'chunkSize':chunkSize},
                                        'databaseTitle': {
                                          'databaseTitle':
                                              topicData.keys.toList()[index]
                                        },
                                        'key': {'refresh': refreshKey}
                                      });
                                },
                                child: Padding(
                                  // Padding around Card component
                                  padding:
                                      const EdgeInsets.fromLTRB(21, 9, 21, 9),
                                  child: Slidable(
                                    actionPane: SlidableBehindActionPane(),
                                    actionExtentRatio: 0.25,
                                    actions: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Map vocWtf = topicData[
                                              topicData.keys.toList()[index]];

                                          vocWtf.removeWhere((key, value) => [
                                                'Iknow'
                                              ].contains(userStateVoc['class'][
                                                  title[topicData.keys
                                                      .toList()[index]]][key]));
                                          Navigator.pushNamed(
                                              context, Trainer.route,
                                              arguments: {
                                                title[topicData.keys
                                                    .toList()[index]]: vocWtf,
                                                'userStateVoc': show
                                                    ? userStateVoc
                                                    : {
                                                        'admin': false,
                                                        'class': {
                                                          title[topicData.keys
                                                                  .toList()[
                                                              index]]: {}
                                                        }
                                                      },
                                                'user': {
                                                  'user': auth.currentUser()
                                                },
                                                'chunkSize':{'chunkSize':chunkSize},
                                                'databaseTitle': {
                                                  'databaseTitle': topicData
                                                      .keys
                                                      .toList()[index]
                                                },
                                                'key': {'refresh': refreshKey}
                                              });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xffED6B6B),
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
                                          child: Center(
                                            // TODO: Replace with icon
                                            child: Text('🤫',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25)),
                                          ),
                                        ),
                                      )
                                    ],
                                    secondaryActions: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Map vocIKnow = topicData[
                                              topicData.keys.toList()[index]];

                                          vocIKnow.removeWhere((key, value) => [
                                                'wtf',
                                                'notSave',
                                                null
                                              ].contains(userStateVoc['class'][
                                                  title[topicData.keys
                                                      .toList()[index]]][key]));
                                          if (vocIKnow.length == 0) {
                                            // TODO: return AlertDialog
                                            refreshKey.currentState.show();
                                          } else {
>>>>>>> eb2a9f85c0c8e6316af0cd91b08c8c76a7494563
                                            Navigator.pushNamed(
                                                context, Trainer.route,
                                                arguments: {
                                                  title[topicData.keys
<<<<<<< HEAD
                                                      .toList()[index]]: vocWtf,
=======
                                                          .toList()[index]]:
                                                      vocIKnow,
>>>>>>> eb2a9f85c0c8e6316af0cd91b08c8c76a7494563
                                                  'userStateVoc': show
                                                      ? userStateVoc
                                                      : {
                                                          'admin': false,
                                                          'class': {
                                                            title[topicData.keys
                                                                    .toList()[
                                                                index]]: {}
                                                          }
                                                        },
                                                  'user': {
                                                    'user': auth.currentUser()
                                                  },
<<<<<<< HEAD
                                                  'chunkSize': {
                                                    'chunkSize': chunkSize
                                                  },
=======
                                                  'chunkSize':{'chunkSize':chunkSize},
>>>>>>> eb2a9f85c0c8e6316af0cd91b08c8c76a7494563
                                                  'databaseTitle': {
                                                    'databaseTitle': topicData
                                                        .keys
                                                        .toList()[index]
                                                  },
                                                  'key': {'refresh': refreshKey}
                                                });
<<<<<<< HEAD
                                          },
                                          child: Container(
                                            child: Stack(
                                              children: [
                                                OverflowBox(
                                                  alignment: Alignment.centerLeft,
                                                  maxWidth: 130,
                                                  child: SizedBox(
                                                  width: 130,
                                                  height: 70,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffED6B6B),
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  11.0),
                                                          boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 30,
                                                          offset:
                                                              Offset(10, 10),
                                                          color: Colors.black
                                                              .withOpacity(.20),
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
                                                topicData.keys.toList()[index]];

                                            vocIKnow.removeWhere((key, value) =>
                                                [
                                                  'wtf',
                                                  'notSave',
                                                  null
                                                ].contains(userStateVoc['class']
                                                        [title[topicData.keys
                                                            .toList()[index]]]
                                                    [key]));
                                            if (vocIKnow.length == 0) {
                                              // TODO: return AlertDialog
                                              refreshKey.currentState.show();
                                            } else {
                                              Navigator.pushNamed(
                                                  context, Trainer.route,
                                                  arguments: {
                                                    title[topicData.keys
                                                            .toList()[index]]:
                                                        vocIKnow,
                                                    'userStateVoc': show
                                                        ? userStateVoc
                                                        : {
                                                            'admin': false,
                                                            'class': {
                                                              title[topicData
                                                                      .keys
                                                                      .toList()[
                                                                  index]]: {}
                                                            }
                                                          },
                                                    'user': {
                                                      'user': auth.currentUser()
                                                    },
                                                    'chunkSize': {
                                                      'chunkSize': chunkSize
                                                    },
                                                    'databaseTitle': {
                                                      'databaseTitle': topicData
                                                          .keys
                                                          .toList()[index]
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
                                                  alignment: Alignment.centerRight,
                                                  maxWidth: 130,
                                                  child: SizedBox(
                                                  width: 130,
                                                  height: 70,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff7E92C8),
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  11.0),
                                                          boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 30,
                                                          offset:
                                                              Offset(10, 10),
                                                          color: Colors.black
                                                              .withOpacity(.20),
                                                        ),
                                                      ])),
                                                )),
                                                Center(
                                                  child: Text('🤓',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
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
=======
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xff7E92C8),
>>>>>>> eb2a9f85c0c8e6316af0cd91b08c8c76a7494563
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
<<<<<<< HEAD
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
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            title[topicData.keys
                                                                    .toList()[
                                                                index]],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14),
                                                          ),
                                                          Text(
                                                            meta[topicData.keys
                                                                    .toList()[
                                                                index]],
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xff000000),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: SizeConfig
                                                                .blockSizeVertical *
                                                            4.6,
                                                        width:  SizeConfig
                                                                .blockSizeVertical *
                                                            4.6,
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Center(
                                                              child: Container(
                                                                width: SizeConfig
                                                                        .blockSizeVertical *
                                                                    4.6,
                                                                height: SizeConfig
                                                                        .blockSizeVertical *
                                                                    4.6,
                                                                child:
                                                                    new CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      6.0,
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xffCECECE),
                                                                  valueColor: new AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Color(
                                                                          0xff40FF53)),
                                                                  value: show
                                                                      ? getPercent(topicData[topicData.keys.toList()[index]].keys.toList().length, userStateVoc['class'][title[topicData.keys.toList()[index]]]['percent'])
                                                                              .toDouble() /
                                                                          100
                                                                      : 0.0,
                                                                ),
                                                              ),
                                                            ),
                                                            Center(
                                                              // widthFactor: 1.7,
                                                              // child: Pading(
                                                              //   padding: EdgeInsets.only(
                                                              //       left: getPercentagePadding(getPercent(
                                                              //           topicData[topicData.keys.toList()[index]]
                                                              //               .keys
                                                              //               .toList()
                                                              //               .length,
                                                              //           userStateVoc['class'][title[topicData
                                                              //               .keys
                                                              //               .toList()[index]]]['percent']))),
                                                                child: Text(
                                                                  show
                                                                      ? getPercent(topicData[topicData.keys.toList()[index]].keys.toList().length, userStateVoc['class'][title[topicData.keys.toList()[index]]]['percent'])
                                                                              .toString() +
                                                                          '%'
                                                                      : "0%",
                                                                    textAlign: TextAlign.center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xff000000),
                                                                    fontSize: 10
                                                                  ),
                                                                ),
                                                              ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                      //  Row(children: [

                                                      //   new Padding(
                                                      //     padding:EdgeInsets.only(right: 4),
                                                      //     child: Text(
                                                      //       show
                                                      //           ? getPercent(
                                                      //                       topicData[topicData.keys.toList()[index]]
                                                      //                           .keys
                                                      //                           .toList()
                                                      //                           .length,
                                                      //                       userStateVoc['class'][title[topicData
                                                      //                           .keys
                                                      //                           .toList()[index]]]['percent'])
                                                      //                   .toString() +
                                                      //               '%'
                                                      //           : "0%",
                                                      //       style: TextStyle(
                                                      //         color:
                                                      //             Color(0xff000000),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      //   CircularProgressIndicator(
                                                      //     strokeWidth: 6.0,
                                                      //     backgroundColor:
                                                      //         Color(0xffCECECE),
                                                      //     valueColor:
                                                      //         new AlwaysStoppedAnimation<
                                                      //                 Color>(
                                                      //             Color(
                                                      //                 0xff40FF53)),
                                                      //     value: show
                                                      //         ? getPercent(
                                                      //                     topicData[topicData.keys.toList()[
                                                      //                             index]]
                                                      //                         .keys
                                                      //                         .toList()
                                                      //                         .length,
                                                      //                     userStateVoc[
                                                      //                         'class'][title[topicData
                                                      //                             .keys
                                                      //                             .toList()[
                                                      //                         index]]]['percent'])
                                                      //                 .toDouble() /
                                                      //             100
                                                      //         : 0.0,
                                                      //   ),
                                                      //   ],)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ),
                                  ));
                            }))),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
            mainAxisAlignment: admin
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              admin
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 5,
                          bottom: SizeConfig.blockSizeVertical),
                      child: FloatingActionButton(
                        heroTag: "add",
                        onPressed: () {
                          Navigator.pushNamed(context, AddVoc.route,
                              arguments: title);
                        },
                        child: Icon(Icons.add),
                      ),
                    )
                  : SizedBox(),
              Padding(
                padding: EdgeInsets.only(
                    right: SizeConfig.blockSizeHorizontal * 5,
                    bottom: SizeConfig.blockSizeVertical),
                child: Nav(auth, refreshKey),
              ),
            ]));
=======
                                          child: Center(
                                            // TODO: Replace with icon
                                            child: Text(
                                              '🤓',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                new BorderRadius.circular(11.0),
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
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          title[topicData.keys
                                                              .toList()[index]],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          meta[topicData.keys
                                                              .toList()[index]],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      ],
                                                    ),
                                                     SizedBox(
                                                          height: SizeConfig.blockSizeVertical * 4.6,
                                                          child: Stack(
                                                            children: <Widget>[
                                                              Center(
                                                                child: Container(
                                                                  width: SizeConfig.blockSizeVertical * 4.6,
                                                                  height: SizeConfig.blockSizeVertical * 4.6,
                                                                  child: new CircularProgressIndicator(
                                                                    strokeWidth: 6.0,
                                                                     backgroundColor:
                                                          Color(0xffCECECE),
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Color(
                                                                  0xff40FF53)),
                                                      value: show
                                                          ? getPercent(
                                                                      topicData[topicData.keys.toList()[
                                                                              index]]
                                                                          .keys
                                                                          .toList()
                                                                          .length,
                                                                      userStateVoc[
                                                                          'class'][title[topicData
                                                                              .keys
                                                                              .toList()[
                                                                          index]]]['percent'])
                                                                  .toDouble() /
                                                              100
                                                          : 0.0,
                                                    ),
                                                                ),
                                                              ),
                                                              Center(child: Padding(padding: EdgeInsets.only(left: getPercentagePadding(getPercent(
                                                                        topicData[topicData.keys.toList()[index]]
                                                                            .keys
                                                                            .toList()
                                                                            .length,
                                                                        userStateVoc['class'][title[topicData
                                                                            .keys
                                                                            .toList()[index]]]['percent']))),child:Text(
                                                        show
                                                            ? getPercent(
                                                                        topicData[topicData.keys.toList()[index]]
                                                                            .keys
                                                                            .toList()
                                                                            .length,
                                                                        userStateVoc['class'][title[topicData
                                                                            .keys
                                                                            .toList()[index]]]['percent'])
                                                                    .toString() +
                                                                '%'
                                                            : "0%",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),),),
                                                            ],
                                                          ),
                                                        ),
                                                  //  Row(children: [
                                                   
                                                  //   new Padding(
                                                  //     padding:EdgeInsets.only(right: 4), 
                                                  //     child: Text(
                                                  //       show
                                                  //           ? getPercent(
                                                  //                       topicData[topicData.keys.toList()[index]]
                                                  //                           .keys
                                                  //                           .toList()
                                                  //                           .length,
                                                  //                       userStateVoc['class'][title[topicData
                                                  //                           .keys
                                                  //                           .toList()[index]]]['percent'])
                                                  //                   .toString() +
                                                  //               '%'
                                                  //           : "0%",
                                                  //       style: TextStyle(
                                                  //         color:
                                                  //             Color(0xff000000),
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  //   CircularProgressIndicator(
                                                  //     strokeWidth: 6.0,
                                                  //     backgroundColor:
                                                  //         Color(0xffCECECE),
                                                  //     valueColor:
                                                  //         new AlwaysStoppedAnimation<
                                                  //                 Color>(
                                                  //             Color(
                                                  //                 0xff40FF53)),
                                                  //     value: show
                                                  //         ? getPercent(
                                                  //                     topicData[topicData.keys.toList()[
                                                  //                             index]]
                                                  //                         .keys
                                                  //                         .toList()
                                                  //                         .length,
                                                  //                     userStateVoc[
                                                  //                         'class'][title[topicData
                                                  //                             .keys
                                                  //                             .toList()[
                                                  //                         index]]]['percent'])
                                                  //                 .toDouble() /
                                                  //             100
                                                  //         : 0.0,
                                                  //   ),
                                                  //   ],)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                ));
                          })),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Row(
                mainAxisAlignment: admin
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  admin
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 5,
                              bottom: SizeConfig.blockSizeVertical),
                          child: FloatingActionButton(
                            heroTag: "add",
                            onPressed: () {
                              Navigator.pushNamed(context, AddVoc.route,
                                  arguments: title);
                            },
                            child: Icon(Icons.add),
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(
                        right: SizeConfig.blockSizeHorizontal * 5,
                        bottom: SizeConfig.blockSizeVertical),
                    child: Nav(auth,refreshKey),
                  ),
                ])));
>>>>>>> eb2a9f85c0c8e6316af0cd91b08c8c76a7494563
  }
}
