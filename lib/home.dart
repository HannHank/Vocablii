import 'package:firebase_auth/firebase_auth.dart';
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
  @override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Column(
          children: <Widget>[
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
