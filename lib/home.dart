import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'helper/initialiseTopicsForUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vocablii/vocabulary.dart';
import 'auth/auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  List allTopics = [];
  Map<String, Map> topicData = {};
  Map<String, String> meta = {};
  Map<String, String> title = {};
  dynamic userStateVoc = {};
  getTopics() {
    topics.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            setState(() {
              title[doc.id] = doc.data()['meta']['name'];
              meta[doc.id] = doc.data()['meta']['descr'];
              topicData[doc.id] = doc.data()['vocabulary'];
            });
          }),
        });
  }

  getStateVoc() async {
    initialiseUserLernState(auth.currentUser()).then((data) => {
          setState(() {
            userStateVoc = data;
          })
        });
  }

  getPercent(int all, int known) {
    print("all: " + all.toString() + "known: " + known.toString());
    int percent = (known / all * 100).toInt();
    return percent;
  }

  @override
  void initState() {
    super.initState();
    getTopics();
    getStateVoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: new Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 77, left: 21),
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
                  child: ListView.builder(
                      itemCount: topicData.keys.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new InkWell(
                            onTap: () {
                              // print('Data: ' +
                              //     topicData[topicData.keys.toList()[index]]
                              //         .toString());
                              print(userStateVoc.keys.toString());
                              print("hallo" +
                                  topicData[topicData.keys.toList()[index]]
                                      .keys
                                      .toList()
                                      .length
                                      .toString());
                              Navigator.pushNamed(context, Trainer.route,
                                  arguments: {
                                    title[topicData.keys.toList()[index]]:
                                        topicData[
                                            topicData.keys.toList()[index]],
                                    'userStateVoc': userStateVoc,
                                    'user': {'uuid': auth.currentUser().uid},
                                  });
                            },
                            child: Padding(
                              // Padding around Card component
                              padding: const EdgeInsets.fromLTRB(21, 9, 21, 9),
                              child: Slidable(
                                actionPane: SlidableBehindActionPane(),
                                actionExtentRatio: 0.25,
                                actions: <Widget>[
                                  InkWell(
                                    child: Container(
                                      width: 800,
                                      decoration: BoxDecoration(
                                          color: Color(0xffED6B6B),
                                          borderRadius:
                                              new BorderRadius.circular(11.0),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 30,
                                              offset: Offset(10, 10),
                                              color:
                                                  Colors.black.withOpacity(.20),
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff7E92C8),
                                          borderRadius:
                                              new BorderRadius.circular(11.0),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 30,
                                              offset: Offset(10, 10),
                                              color:
                                                  Colors.black.withOpacity(.20),
                                            ),
                                          ]),
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
                                            color:
                                                Colors.black.withOpacity(.20),
                                          ),
                                        ]),
                                    child: Padding(
                                      padding:
                                          // Padding inside Card component
                                          EdgeInsets.fromLTRB(21, 15, 21, 15),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      title[topicData.keys
                                                          .toList()[index]],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      meta[topicData.keys
                                                          .toList()[index]],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xff000000),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        getPercent(
                                                                    topicData[topicData.keys.toList()[
                                                                            index]]
                                                                        .keys
                                                                        .toList()
                                                                        .length,
                                                                    userStateVoc[title[topicData
                                                                            .keys
                                                                            .toList()[index]]]['Iknow']
                                                                        .keys
                                                                        .toList()
                                                                        .length)
                                                                .toString() +
                                                            '%',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      )
                                                    ]),
                                                CircularProgressIndicator(
                                                  strokeWidth: 6.0,
                                                  backgroundColor:
                                                      Color(0xff40FF53),
                                                  value: getPercent(
                                                          topicData[topicData.keys
                                                                      .toList()[
                                                                  index]]
                                                              .keys
                                                              .toList()
                                                              .length,
                                                          userStateVoc[title[topicData
                                                                      .keys
                                                                      .toList()[
                                                                  index]]]['Iknow']
                                                              .keys
                                                              .toList()
                                                              .length)
                                                      .toDouble(),
                                                ),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            // TODO: Navigate to Add Vocabulary screen
            child: FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Nav(auth),
          ),
        ]));
  }
}
