import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/components/InputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vocablii/home.dart';
import 'package:quiver/iterables.dart';
import 'package:Vocablii/pages/vocabulary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OverView extends StatefulWidget {
  static const String route = "OverView";
  final Map args;

  OverView(this.args);
  @override
  _OverView createState() => _OverView(this.args);
}

class _OverView extends State<OverView> {
  GlobalKey<ScaffoldState> key;

  Map args;
  _OverView(this.args);

  Map test = {'test': 1, 'test2': 2};
  Map<String, dynamic> checkBoxes = {};
  List chunks = [];
  Widget iconBox(bool i) {
    if (i == true) {
      return Icon(Icons.check_box_outlined);
    } else {
      return Icon(Icons.check_box_outline_blank);
    }
  }

  sortVocs() {
    var len = 10;
    Map sorted = {};
    int pointer = 1;
    // widget.args[widget.args.keys.toList()[0]].keys.forEach(( value)=>{
    //   print("value: " + value.toString()),
    //   sorted.putIfAbsent(pointer, (value) => {value:widget.args[widget.args.keys.toList()[0]][value]})
    // });
    // for(int i = 0; i <= len; i++){

    // }
    print("sorted: " + sorted.toString());
    setState(() {
      if (widget.args['chunkSize']['chunkSize'] == 0) {
        chunks = [
          [widget.args[widget.args.keys.toList()[0]].keys]
        ];
      } else {
        chunks = partition(widget.args[widget.args.keys.toList()[0]].keys,
                widget.args['chunkSize']['chunkSize'])
            .toList();
      }

      print("chunks: " + chunks.toString());
    });
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String databaseTitle =
        widget.args['databaseTitle']['databaseTitle'].toString();
    print(prefs.getString(databaseTitle));
    try {
      print(jsonEncode(checkBoxes));
      String data = prefs.getString(databaseTitle);
      if (data == null) {
        print("topic not available");
      } else {
        checkBoxes = json.decode(data);
      }
    } on Exception catch (_) {
      print('never reached');
    }
    sortVocs();
  }

  savePrefs(number, state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String databaseTitle =
        widget.args['databaseTitle']['databaseTitle'].toString();
    setState(() {
      checkBoxes[number.toString()] = state;
    });

    prefs.setString(databaseTitle, jsonEncode(checkBoxes));
    //  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    //    try {

    //   String str = encoder.convert(checkBoxes);
    //   print(str);
    //   } catch(e) {
    //     print(e);
    //   }
    print(checkBoxes);
    print(jsonEncode(checkBoxes));
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
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
                    child: Text(" < OverView 🕵🏿‍♀️",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                  ))),
          Expanded(
              child: ListView.builder(
                  itemCount: chunks.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(11),
                              // border: ranking[index]['nickName'] ==
                              //         args['nickName']
                              //     ? Border.all(color: Colors.green[300],width: 3): Border.all(color: Colors.white),

                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[350],
                                    blurRadius: 10,
                                    offset: Offset(4, 4)),
                              ],
                            ),
                            child: ListTile(
                                onTap: () {
                                  Map data = widget.args;
                                  Map vocs =
                                      widget.args[widget.args.keys.toList()[0]];

                                  vocs.removeWhere((key, value) =>
                                      !chunks[index].contains(key));
                                  data[widget.args.keys.toList()[0]] = vocs;
                                  Navigator.pushNamed(context, Trainer.route,
                                      arguments: data);
                                },
                                leading: Text((index + 1).toString(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    )),
                                trailing: FlatButton(
                                    onPressed: () {
                                      print("pressed");
                                      if (checkBoxes[index.toString()] ==
                                          null) {
                                        savePrefs(index, true);
                                      } else {
                                        savePrefs(index,
                                            !checkBoxes[index.toString()]);
                                      }
                                    },
                                    child: checkBoxes[index.toString()] != null
                                        ? iconBox(checkBoxes[index.toString()])
                                        : iconBox(false)))));
                  }))
        ]));
  }
}
