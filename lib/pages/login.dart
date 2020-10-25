import 'package:flutter/material.dart';
import 'package:Vocablii/home.dart';
import 'package:Vocablii/components/InputField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth.dart';
import 'package:Vocablii/helper/responsive.dart';

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
  bool showProgressIndikatorSingUp = false;
  bool showProgressIndikatorSingIn = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                child: Column(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 10),
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
                            basicForm("Email", 14.0, emailErr, false, 1,
                                nameController),
                            SizedBox(height: 30),
                            basicForm("Password", 14.0, pwdErr, true, 1,
                                emailController),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 3),
                                child: Text(
                                  errMsg,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 18),
                                )),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 8),
              child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child:
                      showProgressIndikatorSingUp || showProgressIndikatorSingIn
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.cyan,
                              strokeWidth: 5,
                            )
                          : FlatButton(
                              height: SizeConfig.blockSizeVertical * 6,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(
                                      SizeConfig.blockSizeVertical * 7)),
                              color: Colors.black,
                              onPressed: () async {
                                // display ProcessIndikator
                                setState(() {
                                  showProgressIndikatorSingIn = true;
                                });
                                final state = await auth.signIn(
                                  email: nameController.text.trim(),
                                  password: emailController.text.trim(),
                                );
                                if (state == "Signed in") {
                                  Navigator.pushNamed(context, Home.route,
                                      arguments: {
                                        'User': nameController.text +
                                            ' ' +
                                            emailController.text
                                      });
                                } else {
                                  setState(() {
                                    errMsg = state;
                                     showProgressIndikatorSingIn = false;
                                  });
                                }
                              },
                              child: Text("Login",
                                  style: TextStyle(color: Colors.white)),
                            )),
            ),
            Container(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 4),
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: showProgressIndikatorSingUp ||
                          showProgressIndikatorSingIn
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.cyan,
                          strokeWidth: 5,
                        )
                      : FlatButton(
                          height: 50,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  SizeConfig.blockSizeVertical * 6)),
                          color: Colors.black,
                          onPressed: () async {
                            setState(() {
                              showProgressIndikatorSingUp = true;
                            });
                            final state = await auth.signUp(
                              email: nameController.text.trim(),
                              password: emailController.text.trim(),
                            );
                            if (state == "Signed up") {
                              Future.delayed(const Duration(milliseconds: 2000),
                                  () {
                                Navigator.pushNamed(context, Home.route,
                                    arguments: {
                                      'User': nameController.text +
                                          ' ' +
                                          emailController.text
                                    });
                              });
                            } else {
                              setState(() {
                                errMsg = state;
                                showProgressIndikatorSingUp = false;
                              });
                            }
                          },
                          child: Text("Sign Up",
                              style: TextStyle(color: Colors.white)),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
