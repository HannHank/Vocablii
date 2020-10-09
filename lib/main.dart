import 'package:Vocablii/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Vocablii/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'auth/auth.dart';
import 'home.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final auth = AuthenticationService(FirebaseAuth.instance);
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return MaterialApp(
      title: 'Vocablii',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.black,
        accentColor: Color(0xffffff),

        // Define the default font family.
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
          bodyText2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
        ),
      ),
      initialRoute: Login.route,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Login.route:
            if (auth.currentUser() != null) {
              return MaterialPageRoute(
                  builder: (_) =>
                      Home({"User": auth.currentUser().toString()}));
            } else {
              return MaterialPageRoute(builder: (_) => Login());
            }
            break;
          case Home.route:
            if (auth.currentUser() != null) {
              return MaterialPageRoute(
                  builder: (_) => Home(settings.arguments));
            } else {
              return MaterialPageRoute(builder: (_) => Login());
            }
            break;
          case Trainer.route:
            if (auth.currentUser() != null) {
              return MaterialPageRoute(
                  builder: (_) => Trainer(settings.arguments));
            } else {
              return MaterialPageRoute(builder: (_) => Login());
            }
            break;

          default:
            return MaterialPageRoute(builder: (_) => Login());
        }
      },
    );
  }
}
