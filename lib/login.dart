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
                            SizedBox(height: 30),
                            basicForm("Email", emailErr,nameController),
                            SizedBox(height: 30),
                            basicForm("Password", pwdErr,emailController),
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
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.black,
                    onPressed: () async{
                      final state =  await auth.signIn(
                      email:nameController.text.trim(),
                      password: emailController.text.trim(),
                        );
                      if(state == "Signed in"){
                        Navigator.pushNamed(context, Home.route,arguments:{'User': nameController.text + ' ' + emailController.text});
                      }else{
                          setState(() {
                            errMsg = state;
                          });
                      }
                      
                    },
                    label: Text("Login"),
                  )),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.black,
                    onPressed: () async{
                      final state =  await auth.signUp(
                      email:nameController.text.trim(),
                      password: emailController.text.trim(),
                        );
                      if(state == "Signed up"){
                        Navigator.pushNamed(context, Home.route,arguments:{'User': nameController.text + ' ' + emailController.text});
                      }else{
                          setState(() {
                            errMsg = state;
                          });
                      }
                      
                    },
                    label: Text("Sign Up"),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
