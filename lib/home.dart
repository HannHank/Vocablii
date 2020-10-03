import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vocablii/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:Vocablii/login.dart';
import 'auth/auth.dart';

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
                margin: EdgeInsets.only(top: 100, left: 10),
                width: double.infinity,
                child: Text(
                  "Deine Themen",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                              // print("Name: " + topicData.keys.toList()[index]);
                              print("Data: " + topicData[topicData.keys.toList()[index]].toString());
                  
                              Navigator.pushNamed(
                                  context, Trainer.route, arguments: {
                                topicData.keys.toList()[index]:
                                    topicData[topicData.keys.toList()[index]]
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: 30, right: 30, top: 10),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            new BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 8,
                                              offset: Offset(0, 15),
                                              color:
                                                  Colors.grey.withOpacity(.6),
                                              spreadRadius: -9),
                                        ]),
                                    height: 70,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      child: new Stack(
                                        children: <Widget>[
                                          Positioned(
                                            
                                            child: Text(
                                              topicData.keys.toList()[index],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          Positioned(
                                            top: 30,
                                            child: Text(meta[topicData.keys.toList()[index]]),
                                          )
                                        ],
                                      ),
                                    ))));
                      })),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          margin: EdgeInsets.all(30),
          child: FloatingActionButton.extended(
              backgroundColor: Colors.black,
              onPressed: () {},
              label: Text(
                "Vokabeln hinzufügen",
              )),
        ));
  }
}
