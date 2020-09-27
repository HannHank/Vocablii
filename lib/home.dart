import 'package:flutter/material.dart';
import 'package:Vocablii/login.dart';

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
                child: Text("Login"),
                onPressed:(){
                 Navigator.pushNamed(context, Login.route);
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
