import 'package:flutter/material.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/components/InputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Ranking extends StatefulWidget {
  static const String route = "Ranking";
  final Map args;

  Ranking(this.args);
  @override
  _Ranking createState() => _Ranking(this.args);
}

class _Ranking extends State<Ranking> {
  CollectionReference collectionRanking = FirebaseFirestore.instance.collection('ranking');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final nicknameController = TextEditingController();
  Map args;
  bool showRanking = false;
  List ranking = [];
  List rankingListSort = [];
  _Ranking(this.args);
  saveNickName()async{
       String name = nicknameController.text.trim();
       if(name != ''){
      await users.doc(args['uid']).update({
         'nickName': name
      });
      args['nickName'] = name;
      setState(() {
        showRanking = true;
      });
       }
  }
  getRanking()async {
  await collectionRanking.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            setState(() {
              ranking.add({'nickName':doc.id, 'active': doc.data()['active']});
              // skipp if not public and no admin
              // ranking[doc.id]  = doc.data()['active'].toString();
              // rankingListSort.add(doc.data()['active']);

              });
          }),
        });
        setState(() {
          print(ranking);
          ranking.sort((a, b) => b['active'].compareTo(a['active']));
          showRanking = true;
        });
        
  }
  @override
  void initState() {
    super.initState();
    getRanking();
    print("ags: " + args.toString());
    print("widget data: " + this.args.toString());
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
   return Scaffold( 
     backgroundColor: Colors.white,
      appBar: AppBar( 
        title:Text("Ranking") 
      ), 
      body: args['nickName'] != 'null' ? ListView.builder( 
        itemCount: ranking.length, 
        itemBuilder: (BuildContext context,int index){ 
          return new Container (
            decoration: new BoxDecoration (
                color: ranking[index]['nickName'] == args['nickName'] ? Colors.grey: Colors.white,
            ),
            child:ListTile( 
            
            leading:Text((index + 1).toString()), 
            trailing: Text("Score: "+ ranking[index]['active'].toString(), 
                           style: TextStyle( 
                             color: Colors.black,fontSize: 15),), 
            title:Text(ranking[index]['nickName']) 
            )); 
        } 
        ):Container(
          child:Column(children:<Widget> [
            
            Text("choose a Name"),
            basicForm("NickName", 14.0,"not a valid Nickname!",false,1,nicknameController),
            FloatingActionButton(onPressed: saveNickName,child:Icon(Icons.save))
          ]
          )
        )
    ); 
  } 
}
