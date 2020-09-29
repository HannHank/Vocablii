import 'package:flutter/material.dart';
import 'package:Vocablii/home.dart';
import 'package:Vocablii/components/InputField.dart';
class Login extends StatelessWidget {
  static const String route = "login";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 100),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: Text(
                                "Login",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textScaleFactor: 2,
                                // has impact
                              ),
                            ),
                            SizedBox(height: 30),
                            basicForm("Name", "Name is missing!"),
                            SizedBox(height: 30),
                            basicForm("Email", "Email is invalid or missing!")
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      Navigator.pushNamed(context, Home.route,arguments:{'User':'Franz Biedenmaier'});
                    },
                    label: Text("далше"),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
