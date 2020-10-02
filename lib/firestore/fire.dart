import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Fire{
  CollectionReference users = FirebaseFirestore.instance.collection('topic');
  

}