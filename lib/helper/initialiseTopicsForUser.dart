import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

initialiseUserLernState(user) async{
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Map userState;
  Map<String, Map> usersLernStates = {
    'class': {}
  };
 await users.doc(user.uid.toString()).get().then((snapshot) => {
    usersLernStates['class'] = snapshot.data()['class'],
    userState = snapshot.data()
    // usersLernStates['class'] =  snapshot.data()['class'],
  }).catchError((err){
    //document not created
  });
      await topics.get().then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                print("not null: " + usersLernStates.toString());
                if(usersLernStates['class'].containsKey(doc.data()['meta']['name'])){
                  //nothing to do
                }else{
                  usersLernStates['class'][doc.data()['meta']['name']] = {
                    "percent":0
                  };
                }
              }),
              print("userLernState after update: " + usersLernStates.toString())
});

  await users
          .doc(user.uid.toString())
          .update({
            'class': usersLernStates['class'],
          });
    userState['class'] = usersLernStates['class'];
    return userState;

}