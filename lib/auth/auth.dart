import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  Future<dynamic> _deepLinkBackground;

  firebaseHandler() {
    initialiseFirebaseOnlink(_deepLinkBackground);
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();
  User currentUser() {
    // print( _firebaseAuth.currentUser);
    return _firebaseAuth.currentUser;
  }

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String> signUp({String email, String password}) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await users.doc(user.user.uid.toString()).set({
        'name': email,
        'class': {},
      });
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  sendEmail(String email){
   _firebaseAuth.sendSignInLinkToEmail(
    email: email,
    actionCodeSettings: ActionCodeSettings(
        url: "https://vocablii.page.link/KPo2",
        androidPackageName: "com.navabase.Vocablii",
        iOSBundleId: "com.navabase.Vocablii",
        handleCodeInApp: true,
        androidMinimumVersion: "16",
        androidInstallApp: true),
   );
  }
  
  initialiseFirebaseOnlink(_deepLinkBackground) {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        _deepLinkBackground = Future(() {
          return deepLink;
        });
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }
}
