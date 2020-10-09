import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

initialiseUserLernState(user) async{
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Map<String, Map> usersLernStates = {
    'class': null
  };
 await users.doc(user.uid.toString()).get().then((snapshot) => {
    usersLernStates['class'] = snapshot.data()['class'],
    // usersLernStates['class'] =  snapshot.data()['class'],
  }).catchError((err){
    //document not created
  });
      await topics.get().then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if(usersLernStates['class'].containsKey(doc.data()['meta']['name'])){
                  //nothing to do
                }else{
                  usersLernStates['class'][doc.data()['meta']['name']] = {};
                }
              }),
});
  await users
          .doc(user.uid.toString())
          .update({
            'class': usersLernStates['class'],
          });
    return usersLernStates['class'];

}