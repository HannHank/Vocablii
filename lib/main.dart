import 'package:Vocablii/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Vocablii/pages/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:Vocablii/pages/onboarding_screen.dart';
import 'package:flutter/services.dart';
import 'package:Vocablii/pages/addVoc.dart';
import 'package:Vocablii/pages/Ranking.dart';
import 'package:Vocablii/pages/OverView.dart';
import 'package:Vocablii/pages/topicInformation.dart';
import 'auth/auth.dart';
import 'home.dart';
import 'pages/login.dart';
// import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(new MyApp());
  }
  );
}

class MyApp extends StatelessWidget {
  final auth = AuthenticationService(FirebaseAuth.instance);
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return MaterialApp(
      title: 'Vocablii',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Color(0xffFFFFFF),
        accentColor: Color(0xff263238),
        canvasColor: Colors.transparent,

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
              return MaterialPageRoute(builder: (_) => OnboardingScreen({'namedRoute':'loginOnboarding'}));
            }
            break;
          case "loginOnboarding":
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
              return MaterialPageRoute(builder: (_) =>Login());
            }
            break;
          case OnboardingScreen.route:
            if (auth.currentUser() != null) {
              return MaterialPageRoute(
                  builder: (_) => OnboardingScreen(settings.arguments));
            } else {
              return MaterialPageRoute(builder: (_) =>  OnboardingScreen({'namedRoute':'loginOnboarding'}));
            }
            break;
          case Ranking.route:
            if (auth.currentUser() != null) {
              return MaterialPageRoute(
                  builder: (_) => Ranking(settings.arguments));
            } else {
              return MaterialPageRoute(builder: (_) =>  Login());
            }
            break;
          case InfoTopic.route:
            if (auth.currentUser() != null) {
              return MaterialPageRoute(
                  builder: (_) => InfoTopic(settings.arguments));
            } else {
              return MaterialPageRoute(builder: (_) =>  Login());
            }
            break;
          case OverView.route:
            if (auth.currentUser() != null) {
              return MaterialPageRoute(
                  builder: (_) => OverView(settings.arguments));
            } else {
              return MaterialPageRoute(builder: (_) =>  Login());
            }
            break;
          case AddVoc.route:
            if (auth.currentUser() != null) {
              return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => AddVoc(settings.arguments),
             transitionsBuilder: (
        BuildContext context, 
        Animation<double> animation, 
        Animation<double> secondaryAnimation, 
        Widget child) {
      return Align(
        child: SizeTransition(
          sizeFactor: animation,
          child: child,
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 500),
              );
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
