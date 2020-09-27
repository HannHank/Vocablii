import 'package:flutter/material.dart';
import 'package:Vocablii/home.dart';

class Login extends StatelessWidget {
  static const String route = "login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(hintText: "Username"),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(hintText: "Password"),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, Home.route,arguments:{'User':'Franz Biedenmaier'});
                           },
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}