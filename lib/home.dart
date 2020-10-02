import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            Expanded(
                child: ListView.builder(
                    itemCount: allTopics.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Card(
                        child: InkWell(child: Text(allTopics[index])));
                    })),
            Expanded(child: Center(child: Text("Hello "+ widget.args['User']))),
            Expanded(
              child: FlatButton(
                child: Text("Logout"),
                onPressed:()async{
                 auth.signOut().then((state) => {
                 Navigator.pushNamed(context, Login.route)

                 });
                }
            ),
            ),
          ],
        ),
      ),
    );
  }
}
