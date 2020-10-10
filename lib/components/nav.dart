import 'package:flutter/material.dart';
import 'settingsButton.dart';
import 'package:Vocablii/auth/auth.dart';
import 'InputField.dart';

class Nav extends StatelessWidget {
  final AuthenticationService auth;
  Nav(this.auth);

  Map settings = {
    'show_answerd': true,
    'audio': true,
    'audio_over_wifi': false
  };

  String emoji(String key) {
    if(settings[key] == true) {
      return '✅';
    } else {
      return '⛔';
    }
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
           Container(
             margin: EdgeInsets.only(left:20,right: 20, bottom: 10),
             padding: EdgeInsets.all(50),
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
                child:Column(
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
                          settingButton(emoji('show_answerd'), 'Beantwortete Anzeigen', (){
                            settings['show_answerd'] = !settings['show_answerd'];
                          }),
                          settingButton(emoji('audio'), 'Audio Vokabeln', (){
                            settings['audio'] = !settings['audio'];
                          }),
                          settingButton(emoji('audio_over_wifi'), 'Audio nur über WLAN', (){
                            settings['audio_over_wifi'] = !settings['audio_over_wifi'];
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
                          basicForm("Nutzername",10.0,30, "wrong", null),
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
                          basicForm("Password",10.0,30, "wrong", null),
                          basicForm("Password wiederholen",10.0,30, "wrong", null),
                      
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
                          settingButton('❌', 'Alles zurücksetzen?', (){}),
                          // Logout
                          Center(
                            child: 
                            Padding(
                              padding: EdgeInsets.all(25),
                              child:FloatingActionButton(
                              onPressed: (){
                                auth.signOut();
                              },
                              child: Icon(Icons.logout),
                            ),
                          )),
                        ],
                      ),
                    )
                  ],
                )
                )))));
      },
    );
  }
}
