import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/components/InputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vocablii/home.dart';

class Ranking extends StatefulWidget {
  static const String route = "Ranking";
  final Map args;

  Ranking(this.args);
  @override
  _Ranking createState() => _Ranking(this.args);
}

class _Ranking extends State<Ranking> {
  GlobalKey<ScaffoldState> key;
  CollectionReference collectionRanking =
      FirebaseFirestore.instance.collection('ranking');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final nicknameController = TextEditingController();
  Map args;
  bool showRanking = false;
  List ranking = [];
  List rankingListSort = [];
  _Ranking(this.args);
  saveNickName() async {
    String name = nicknameController.text.trim();
    if (name != '') {
      await users.doc(args['uid']).update({'nickName': name});
      args['nickName'] = name;
      setState(() {
        showRanking = true;
      });
      return true;
    } else {
      return false;
    }
  }

  getRanking() async {
    await collectionRanking.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            setState(() {
              ranking.add({'nickName': doc.id, 'active': doc.data()['active']});
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
    print(args['nickName'].toString());
    print(args['nickName'].toString().trim() == '');
    print("ags: " + args.toString());
    print("widget data: " + this.args.toString());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title:Text("Ranking")
        // ),
        body: Column(children: [
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.pushNamed(context, Home.route);
                print("tabed");
              },
              child: Container(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(" < Ranking 🏅🏆",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                  ))),
        args['nickName'].toString().trim()!= ''
              ? Expanded(
                  child: Column(children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: ranking.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                    decoration: new BoxDecoration(
                                      color:  Colors.white,
                                      borderRadius: BorderRadius.circular(11),
                                      border: ranking[index]['nickName'] ==
                                              args['nickName']
                                          ? Border.all(color: Colors.green[300],width: 3): Border.all(color: Colors.white),

                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[350],
                                            blurRadius: 10,
                                            offset: Offset(4, 4)),
                                      ],
                                    ),
                                    child: ListTile(
                                      leading: index == 0
                                              ? Text(
                                                  (index + 1).toString() + ".",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 22,
                                                      color:
                                                          Colors.yellow[700]),
                                                )
                                              : index == 1 ? Text(
                                                  (index + 1).toString() + ".",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 22,
                                                      color:
                                                          Colors.grey[400]),
                                                ): index == 2 ?Text(
                                                  (index + 1).toString() + ".",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 22,
                                                      color:
                                                          Colors.brown[300]),
                                                ):Text((index + 1).toString() + ".",style:TextStyle(fontSize: 22,  fontWeight:
                                                          FontWeight.bold,)),
                                              title: Text(ranking[index]['nickName'],style:TextStyle(fontSize: 18,fontWeight:
                                                          FontWeight.bold)),
                                              trailing: Text(
                                      
                                                ranking[index]['active']
                                                    .toString(),style:TextStyle(fontSize: 18,fontWeight:
                                                          FontWeight.bold)
                                           
                                          )
                                    )));
                          }))
                ]))
              : SafeArea(
                  top: true,
                  bottom: true,
                  child: Builder(
                      builder: (context) => Container(
                              child: Column(children: <Widget>[
                           
                            Text("You need to choose a Nickname!"),
                            Padding(
                                padding: EdgeInsets.all(
                                    SizeConfig.blockSizeHorizontal * 2),
                                child: basicForm(
                                    "NickName",
                                    14.0,
                                    "not a valid Nickname!",
                                    false,
                                    1,
                                    nicknameController)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("to change name, contact us: "),
                                Text("info@navabase.com",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical * 4),
                            FloatingActionButton(
                                onPressed: () async {
                                  bool validName = await saveNickName();
                                  if (validName) {
                                  } else {
                                    setState(() {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Container(
                                          height:
                                              SizeConfig.blockSizeVertical * 3,
                                          child: Center(
                                              child: Text(
                                            "Enter Nickname!",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          )),
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ));
                                    });
                                  }
                                },
                                child: Icon(Icons.save))
                          ]))))
        ]));
  }
}
