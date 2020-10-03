import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vocablii/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:Vocablii/login.dart';
import 'auth/auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  Map <String,String> meta = {};

  getTopics() {
    topics.get().then((QuerySnapshot querySnapshot) => {

          querySnapshot.docs.forEach((doc) {
            setState(() {
              meta[doc.id] = doc.data()['meta']['descr']; 
              topicData[doc.id] = doc.data()['vocabulary'];
            });

          }),
        });
  }

  @override
  void initState() {
    getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            onTap: () {},
                            child: Padding(
                              // Padding around Card component
                              padding: const EdgeInsets.fromLTRB(21, 9, 21, 9),
                              child: Slidable(
                                actionPane: SlidableBehindActionPane(),
                                actionExtentRatio: 0.25,
                                actions: <Widget>[
                                  InkWell(
                                    child: Container(
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
                                        child: Text('delete'),
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
                                        child: Text('load'),
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
                                          EdgeInsets.fromLTRB(21, 15, 21, 12),
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
                                                      allTopics[index],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      'Vodka, Vodka, Vodka',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xff000000),
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  ],
                                                ),

                                                // TODO: Add progress ring
                                                Row(children: [
                                                  
                                                  Text(
                                                    '15%',
                                                    style: TextStyle(
                                                      color: Color(0xff000000),
                                                    ),
                                                  )
                                                ])
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
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 59),
          child: FloatingActionButton.extended(
              backgroundColor: Color(0xff263238),
              onPressed: null,
              label: Text("Vokabeln hinzufügen",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
        ));
  }
}
