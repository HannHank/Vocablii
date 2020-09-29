import 'package:flutter/material.dart';
import 'package:Vocablii/home.dart';

class Login extends StatelessWidget {
  static const String route = "login";
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
                            Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 8,
                                          offset: Offset(0, 15),
                                          color: Colors.grey.withOpacity(.6),
                                          spreadRadius: -9),
                                    ]),
                                child: TextField(
                                  decoration: InputDecoration(
                                      isDense: true,
                                      counterText: "",
                                      contentPadding: EdgeInsets.all(10.0),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: "Name"),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  maxLength: 20,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      height: 1.6,
                                      color: Colors.black),
                                  // controller: _locationNameTextController,
                                )),
                            SizedBox(height: 30),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 8,
                                          offset: Offset(0, 15),
                                          color: Colors.grey.withOpacity(.6),
                                          spreadRadius: -9),
                                    ]),
                                child: TextField(
                                  decoration: InputDecoration(
                                      isDense: true,
                                      counterText: "",
                                      contentPadding: EdgeInsets.all(10.0),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none),
                                      hintText: "Email"),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  maxLength: 20,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      height: 1.6,
                                      color: Colors.black),

                                  // controller: _locationNameTextController,
                                )),
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
                    onPressed: () {},
                    label: Text("далше"),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
