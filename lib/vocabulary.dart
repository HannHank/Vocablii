import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Vocablii/login.dart';
import 'auth/auth.dart';

class Card extends StatefulWidget {
  static const String route = "Home";
  final Map<String, String> args;

  Card(this.args);
  @override
  State<StatefulWidget> createState() {
    return _Card();
  }
}

class _Card extends State<Card> {
  final auth = AuthenticationService(FirebaseAuth.instance);
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');
  List allTopics = [];
  getTopics() {
    topics.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            print(doc.id);
            setState(() {
              allTopics.add(doc.id);
            });
          }),
        });
  }

  @override
  void initState() {
    print("Hello Word");
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
                      itemCount: allTopics.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new InkWell(
                            onTap: () {
                              
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
                                          Text(
                                            allTopics[index],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ))));
                      })),
              // Expanded(
              //     child: Center(child: Text("Hello " + widget.args['User']))),
              // Expanded(
              //   child: FlatButton(
              //       child: Text("Logout"),
              //       onPressed: () async {
              //         auth.signOut().then(
              //             (state) => {Navigator.pushNamed(context, Login.route)});
              //       }),
              // ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          margin: EdgeInsets.all(30),
          child: FloatingActionButton.extended(
              backgroundColor: Colors.black,
              onPressed: null,
              label: Text(
                "Vokabeln hinzufügen",
              )),
        ));
  }
}
