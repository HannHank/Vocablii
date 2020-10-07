import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Vocablii/home.dart';
import 'package:Vocablii/components/InputField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/auth.dart';

class Login extends StatefulWidget {
  static const String route = "login";
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final auth = AuthenticationService(FirebaseAuth.instance);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String emailErr;
  String pwdErr;
  String errMsg = "";

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
                            // SELECTOR BETWEEN LOGIN & SIGNUP
                            // Padding(
                            //   padding: EdgeInsets.only(top: 38),
                            //   child: Container(
                            //     width: 220,
                            //     height: 50,
                            //     decoration: BoxDecoration(
                            //         color: Color(0xffF8F8F8),
                            //         borderRadius: BorderRadius.circular(30)),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         RaisedButton(
                            //           onPressed: () {},
                            //           child: Text('Login', style: TextStyle(color: Color(0xff000000)),),
                            //           elevation: 10,
                            //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            //           color: Color(0xffffffff),
                                      
                            //         ),
                            //         RaisedButton(
                            //           onPressed: () {},
                            //           child: Text('Regestrieren', style: TextStyle(color: Color(0xff000000)),),
                            //           elevation: 10,
                            //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            //           color: Color(0xffffffff)
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 30),
                            basicForm("Email", emailErr, nameController),
                            SizedBox(height: 30),
                            basicForm("Password", pwdErr, emailController),
                            Text(errMsg),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: FlatButton(
                    height: 50,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.black,
                    onPressed: () async {
                      final state = await auth.signIn(
                        email: nameController.text.trim(),
                        password: emailController.text.trim(),
                      );
                      if (state == "Signed in") {
                        Navigator.pushNamed(context, Home.route, arguments: {
                          'User':
                              nameController.text + ' ' + emailController.text
                        });
                      } else {
                        setState(() {
                          errMsg = state;
                        });
                      }
                    },
                    child: Text("Login", style: TextStyle(color: Colors.white)),
                  )),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: FlatButton(
                    height: 50,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.black,
                    onPressed: () async {
                      final state = await auth.signUp(
                        email: nameController.text.trim(),
                        password: emailController.text.trim(),
                      );
                      if (state == "Signed up") {
                        Navigator.pushNamed(context, Home.route, arguments: {
                          'User':
                              nameController.text + ' ' + emailController.text
                        });
                      } else {
                        setState(() {
                          errMsg = state;
                        });
                      }
                    },
                    child:
                        Text("Sign Up", style: TextStyle(color: Colors.white)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
