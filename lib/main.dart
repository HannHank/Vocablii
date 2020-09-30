
import 'package:Vocablii/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
   
     return MaterialApp(
         title: 'Vocablii',
      debugShowCheckedModeBanner: false,
      
      initialRoute: Login.route,
      onGenerateRoute: (settings) {
        
        switch (settings.name){
          case Login.route:
          if(auth.currentUser() != null){
            return MaterialPageRoute(builder: (_) =>
                Home(
                    {"User":auth.currentUser().toString()}
                ));
          }else{
            return MaterialPageRoute(builder: (_) => Login());
          }
            break;
          case Home.route:
          
            if(auth.currentUser() != null){
            return MaterialPageRoute(builder: (_) =>
                Home(
                    settings.arguments
                ));
            }else{
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

