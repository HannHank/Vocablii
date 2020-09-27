import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  firebaseAuth(){
    // connecting to firebase / and loading the key form the Phone storage

  }
   @override
  void initState() {
    // here we are goint to check for the user State ==> registered or not
    firebaseAuth();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: Login.route,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Login.route:
            return MaterialPageRoute(builder: (_) => Login());
            break;
          case Home.route:
            return MaterialPageRoute(builder: (_) =>
                Home(
                    settings.arguments
                ));
            break;
          default:
            return MaterialPageRoute(builder: (_) => Login());
        }
      },
    );
  }
}
