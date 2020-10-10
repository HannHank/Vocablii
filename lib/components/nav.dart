import 'package:flutter/material.dart';
import 'settingsButton.dart';
import 'package:Vocablii/auth/auth.dart';

class Nav extends StatelessWidget {
  final AuthenticationService auth;
  Nav(this.auth);
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
                          settingButton('✅', 'Beantwortete Anzeigen', (){}),
                          settingButton('✅', 'Audio Vokabeln', (){}),
                          settingButton('⛔', 'Audio nur über WLAN', (){}),
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
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: InkWell(
                              onTap: () {
                                print('tap on settings');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(11),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[600],
                                          blurRadius: 10,
                                          offset: Offset(4, 4)),
                                    ]),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text('Username'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: InkWell(
                              onTap: () {
                                print('tap on settings');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(11),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[600],
                                          blurRadius: 10,
                                          offset: Offset(4, 4)),
                                    ]),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text('Password'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: InkWell(
                              onTap: () {
                                print('tap on settings');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(11),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[600],
                                          blurRadius: 10,
                                          offset: Offset(4, 4)),
                                    ]),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text('Password wiederholen'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
