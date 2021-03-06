import 'package:Vocablii/components/InputField.dart';
import 'package:flutter/material.dart';
import 'settingsButton.dart';
import 'package:Vocablii/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vocablii/home.dart';
import 'package:flutter/services.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/pages/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Nav extends StatefulWidget {
  final AuthenticationService auth;
  final GlobalKey<RefreshIndicatorState> refresh;
  Nav(this.auth, this.refresh);

  @override
  _NavState createState() => _NavState(auth);
}

class _NavState extends State<Nav> {
  final AuthenticationService auth;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final chunk = TextEditingController();
  _NavState(this.auth);
  List<bool> isSelected = [false, false];
  Map settings;
  List emojis = [];

  String emoji(bool key) {
    if (key == true) {
      return '✅';
    } else {
      return '⛔';
    }
  }

  getChunkSize() async {
    await users.doc(auth.currentUser().uid).get().then(
        (snapshot) => {chunk.text = snapshot.data()['chunkSize'].toString()});
  }

  onSubmitted(chunkSize) async {
    await users
        .doc(auth.currentUser().uid)
        .update({'chunkSize': int.parse(chunkSize.trim())});
    // delete when chunkSize changes, because then OverView chunks are changing too.
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    widget.refresh.currentState.show();
    Navigator.pop(context);
  }

  getLearnFlow() async {
    try{
      await users.doc(auth.currentUser().uid).get().then((snapshot) => {
          print("LOG:" + snapshot.data()['ruDe'].toString()),
          if (snapshot.data()['ruDe'])
            {isSelected[0] = true, isSelected[1] = false}
          else
            {isSelected[1] = true, isSelected[0] = false}
        });
    }catch(err){
      isSelected[0] = true;
      isSelected[1] = false;
    }
  }

  setLearnFlow(flow) async {
    await users.doc(auth.currentUser().uid).update({'ruDe': flow});
    widget.refresh.currentState.show();
    Navigator.pop(context);
    // delete when chunkSize changes, because then OverView chunks are changing too.
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.clear();
    // widget.refresh.currentState.show();
    // Navigator.pop(context);
  }

  deleteProgress() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Fortschritt löschen?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                  child: new Text("delete"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Map progress;
                    await users.doc(auth.currentUser().uid).get().then(
                        (snapshot) => {
                              print(snapshot.data()),
                              progress = snapshot.data()
                            });
                    progress['class'] = {};
                    await users
                        .doc(auth.currentUser().uid)
                        .update(progress)
                        .then((value) => widget.refresh.currentState.show());
                  }),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getChunkSize();
    getLearnFlow();
    settings = {'show_answerd': true, 'audio': true, 'audio_over_wifi': false};
    settings.forEach((key, value) {
      emojis.add(emoji(value));
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return FloatingActionButton(
      child: Icon(Icons.settings),
      onPressed: () {
        showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            context: context,
            builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateModal) =>
                    SingleChildScrollView(
                        child: Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(30)),
                            // width: SizeConfig.blockSizeHorizontal * 50,
                            // height: SizeConfig.blockSizeVertical * 60,
                            child: Center(
                                child: Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          blurRadius: 30,
                                          offset: Offset(-11, -11),
                                          color: Color(0x9900000))
                                    ]),
                                    child: Center(
                                        child: Column(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 6,
                                          decoration: BoxDecoration(
                                              color: Color(0x22000000),
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          margin: EdgeInsets.only(bottom: 20),
                                        ),
                                        Text(
                                          'Einstellungen',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Settings
                                              // Container(
                                              //   margin: EdgeInsets.only(top: 0, bottom: 7),
                                              //   child: Text(
                                              //     'Einstellungen',
                                              //     style: TextStyle(
                                              //         color: Colors.black,
                                              //         fontWeight: FontWeight.w700,
                                              //         fontSize: 14),
                                              //   ),
                                              // ),
                                              // settingButton(
                                              //     emojis[0], 'Beantwortete Anzeigen', () {
                                              //   setStateModal(() {
                                              //     settings['show_answerd'] =
                                              //         !settings['show_answerd'];
                                              //       emojis[0] = emoji(settings['show_answerd']);
                                              //     print(
                                              //         settings['show_answerd'].toString() +
                                              //             emojis[0]);
                                              //   });
                                              // }),
                                              // settingButton(emojis[1], 'Audio Vokabeln',
                                              //     () {
                                              //   setStateModal(() {
                                              //     settings['audio'] = !settings['audio'];
                                              //      emojis[1] = emoji(settings['audio']);
                                              //   });
                                              // }),
                                              // settingButton(
                                              //     emojis[2], 'Audio nur über WLAN', () {
                                              //   setStateModal(() {
                                              //     settings['audio_over_wifi'] =
                                              //         !settings['audio_over_wifi'];
                                              //         emojis[2] = emoji(settings['audio_over_wifi']);
                                              //   });
                                              // }),
                                              // // change user name
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 25, bottom: 7),
                                                child: Text(
                                                  'Chunk-size (0 für alle)',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              basicFormChunk("", 12.0, "wrong",
                                                  false, 1, chunk, onSubmitted),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 25, bottom: 7),
                                                child: Text(
                                                  'Übersetzung',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              Container(
                                                child: ToggleButtons(
                                                  children: <Widget>[
                                                    Text("ru-de"),
                                                    Text("de-ru"),
                                                  ],
                                                  onPressed: (int index) {
                                                    setState(() {
                                                      print("setting ");
                                                      // isSelected[index] = !isSelected[index];
                                                      //                                                   widget.refresh.currentState.show();
                                                      // Navigator.pop(context);
                                                      if (index == 0) {
                                                        isSelected[0] = true;
                                                        isSelected[1] = false;
                                                        setLearnFlow(true);
                                                      } else {
                                                        isSelected[0] = false;
                                                        isSelected[1] = true;
                                                        setLearnFlow(false);
                                                      }
                                                    });
                                                  },
                                                  isSelected: isSelected,
                                                ),
                                                // play audio
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 25, bottom: 7),
                                                child: Text(
                                                  'Anleitung',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),

                                              settingButton(
                                                  '🤔', 'Wie ging das nochmal?',
                                                  () {
                                                Navigator.pushNamed(context,
                                                    OnboardingScreen.route,
                                                    arguments: {
                                                      'namedRoute': Home.route
                                                    });
                                              }),

                                              // Container(
                                              //   margin: EdgeInsets.only(
                                              //       top: 25, bottom: 7),
                                              //   child: Text(
                                              //     'Audio Abspielen',
                                              //     style: TextStyle(
                                              //         color: Colors.black,
                                              //         fontWeight: FontWeight.w700,
                                              //         fontSize: 14),
                                              //   ),
                                              // ),

                                              // // change user name
                                              // Container(
                                              //   margin: EdgeInsets.only(top: 25, bottom: 7),
                                              //   child: Text(
                                              //     'Password ändern',
                                              //     style: TextStyle(
                                              //         color: Colors.black,
                                              //         fontWeight: FontWeight.w700,
                                              //         fontSize: 14),
                                              //   ),
                                              // ),
                                              // basicForm("Password", 12.0, "wrong",false,1,null),
                                              // basicForm("Password wiederholen", 12.0,
                                              //     "wrong", false, 1, null),

                                              // change user name
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 25, bottom: 7),
                                                child: Text(
                                                  'Fortschritt zurücksetzen',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14),
                                                ),
                                              ),

                                              settingButton(
                                                  '❌', 'Alles zurücksetzen?',
                                                  () {
                                                deleteProgress();
                                              }), // Logout
                                              Center(
                                                  child: Padding(
                                                padding: EdgeInsets.all(25),
                                                child: FloatingActionButton(
                                                  onPressed: () async {
                                                    await auth.signOut();
                                                    Navigator.pushNamed(
                                                        context, Home.route,
                                                        arguments: {
                                                          'User': ""
                                                        });
                                                  },
                                                  child: Icon(Icons.logout),
                                                ),
                                              )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ))))))));
      },
    );
  }
}

Widget basicFormChunk(
    String name,
    double fontSize,
    String errmsg,
    bool _obscureText,
    dynamic _maxLine,
    TextEditingController controller,
    Function onSubmitted) {
  return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[600], blurRadius: 10, offset: Offset(4, 4)),
          ]),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: TextField(
            controller: controller,
            onSubmitted: onSubmitted,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                isDense: true,
                counterText: "",
                contentPadding: EdgeInsets.all(10.0),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    onSubmitted(controller.text);
                  },
                  icon: Icon(Icons.save),
                  color: Colors.black,
                ),
                hintText: name),
            textAlign: TextAlign.start,
            maxLines: _maxLine,
            maxLength: null,
            style:
                TextStyle(fontSize: fontSize, height: 1.6, color: Colors.black),
            obscureText: _obscureText
            // controller: _locationNameTextController,
            ),
      ));
}
