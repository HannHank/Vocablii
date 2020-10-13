import 'package:flutter/material.dart';
import 'settingsButton.dart';
import 'package:Vocablii/auth/auth.dart';
import 'InputField.dart';
import 'package:Vocablii/home.dart';

class Nav extends StatefulWidget {
  final AuthenticationService auth;
  Nav(this.auth);

  @override
  _NavState createState() => _NavState(auth);
}

class _NavState extends State<Nav> {
  final AuthenticationService auth;
  _NavState(this.auth);

  Map settings;
  List emojis = [];

  String emoji(bool key) {
    if (key == true) {
      return '✅';
    } else {
      return '⛔';
    }
  }

  @override
  void initState() {
    super.initState();

    settings = {'show_answerd': true, 'audio': true, 'audio_over_wifi': false};

    settings.forEach((key, value) {
      emojis.add(emoji(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.settings),
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) =>
            
            StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal)=>
             Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(30)),
                width: 350,
                height: 700,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Settings
                                  Container(
                                    margin: EdgeInsets.only(top: 0, bottom: 7),
                                    child: Text(
                                      'Einstellungen',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                  ),
                                  settingButton(
                                      emojis[0], 'Beantwortete Anzeigen', () {
                                    setStateModal(() {
                                      settings['show_answerd'] =
                                          !settings['show_answerd'];
                                        emojis[0] = emoji(settings['show_answerd']);
                                      print(
                                          settings['show_answerd'].toString() +
                                              emojis[0]);
                                    });
                                  }),
                                  settingButton(emojis[1], 'Audio Vokabeln',
                                      () {
                                    setStateModal(() {
                                      settings['audio'] = !settings['audio'];
                                       emojis[1] = emoji(settings['audio']);
                                    });
                                  }),
                                  settingButton(
                                      emojis[2], 'Audio nur über WLAN', () {
                                    setStateModal(() {
                                      settings['audio_over_wifi'] =
                                          !settings['audio_over_wifi'];
                                          emojis[2] = emoji(settings['audio_over_wifi']);
                                    });
                                  }),
                                  // change user name
                                  Container(
                                    margin: EdgeInsets.only(top: 25, bottom: 7),
                                    child: Text(
                                      'Nutzernamen ändern',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                  ),
                                  basicForm("Nutzername", 12.0, "wrong",false,1,null),
                                  // change user name
                                  Container(
                                    margin: EdgeInsets.only(top: 25, bottom: 7),
                                    child: Text(
                                      'Password ändern',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                  ),
                                  basicForm("Password", 12.0, "wrong",false,1,null),
                                  basicForm("Password wiederholen", 12.0,
                                      "wrong", false, 1, null),

                                  // change user name
                                  Container(
                                    margin: EdgeInsets.only(top: 25, bottom: 7),
                                    child: Text(
                                      'Fortschritt zurücksetzen',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                  ),
                                  settingButton(
                                      '❌', 'Alles zurücksetzen?', () {}),
                                  // Logout
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(25),
                                    child: FloatingActionButton(
                                      onPressed: () {
                                        auth.signOut();
                                          Navigator.pushNamed(context, Home.route, arguments: {
                                              'User':""
                                                 
                                            });
                                      },
                                      child: Icon(Icons.logout),
                                    ),
                                  )),
                                ],
                              ),
                            )
                          ],
                        )))))));
      },
    );
  }
}
