import 'package:Vocablii/components/doneButton.dart';
import 'package:Vocablii/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/components/InputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class AddVoc extends StatefulWidget {
  static const String route = "addVoc";
  final Map args;

  AddVoc(this.args);
  @override
  _AddVoc createState() => _AddVoc();
}

class _AddVoc extends State<AddVoc> {
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');
  CollectionReference deleted =
      FirebaseFirestore.instance.collection('deleted');

  final ruController = TextEditingController();
  final deController = TextEditingController();
  final descController = TextEditingController();
  final autoController = TextEditingController();
  bool addButton = false;
  List<String> suggestions = [];
  List<String> added = [];
  String currentText = "";
  bool selected = false;
  bool dropDownSelected = false;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  bool topicSelected = false;
  Map titles = {};
  String selectedTopic;
  Map<String, dynamic> vocs;

  deleteCard() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Karte löschen"),
          content: new Text(ruController.text.trim()),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("cancel"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("delete"),
              onPressed: () async {
                setState(() {
                  selected = false;
                  key.currentState.clear();
                });
                Navigator.of(context).pop();
                Map data;
                await topics
                    .doc(selectedTopic)
                    .get()
                    .then((snapshot) => {data = snapshot.data()});
                data['vocabulary'].removeWhere(
                    (key, value) => key == ruController.text.trim().toString());
                // remove card also in current add session
                setState(() {
                  vocs.removeWhere(
                    (key, value) => key == ruController.text.trim());
                    key.currentState.suggestions = vocs.keys.toList();       
                });
                await topics.doc(selectedTopic).update(data);
                await deleted.doc(selectedTopic).set({
                  ruController.text.trim().toString(): {
                    'ru': ruController.text.trim().toString(),
                    'desc': descController.text.toString(),
                    'de': deController.text.toString(),
                    'deletedBy': widget.args['uid'].toString(),
                    'timeStamp': DateTime.now()
                  }
                }, SetOptions(merge: true));
                ruController.text = "";
                deController.text = "";
                descController.text = "";
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    titles = widget.args['title'];
    print("widget data: " + widget.args.toString());
  }

  saveNewVoc() async {
    String path = ruController.text.trim().replaceAll("/", "|");

    await topics.doc(selectedTopic).update({
      "vocabulary." + path: {
        'ru': ruController.text.trim().toString(),
        'desc': descController.text.trim().toString(),
        'de': deController.text.trim().toString()
      }
    });
    setState(() {
      
    vocs.addAll({
          path: {
        'ru': ruController.text.trim().toString(),
        'desc': descController.text.trim().toString(),
        'de': deController.text.trim().toString()
      }
    }
    
    );
    key.currentState.suggestions = vocs.keys.toList();                     
    });
  }

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.4, 0.7, 0.9],
            colors: [
              Color(0xFF3594DD),
              Color(0xFF4563DB),
              Color(0xFF5036D5),
              Color(0xFF5B16D0),
            ],
          ),
        ),
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: SafeArea(
              top: true,
              bottom: true,
              child: Column(children: [
                Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 5,
                        left: SizeConfig.blockSizeHorizontal * 5),
                    width: double.infinity,
                    child: Text(
                      "Bearbeiten",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      textScaleFactor: 2,
                      // has impact
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 3,
                        bottom: SizeConfig.blockSizeVertical * 2),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton(
                          underline: SizedBox(),
                          dropdownColor: Colors.white,
                          hint: Text('Thema auswählen'),
                          value: selectedTopic,
                          items: new List<DropdownMenuItem>.generate(
                              widget.args['title'].keys.length, (i) {
                            return DropdownMenuItem(
                              value: widget.args['title'].keys.toList()[i],
                              child: Text(widget.args['title']
                                  [widget.args['title'].keys.toList()[i]]),
                            );
                          }),
                          onChanged: (newTopic) async {
                            await topics.doc(newTopic).get().then((snapshot) {
                              setState(() {
                                topicSelected = true;
                                addButton = true;
                                selected = false;
                                dropDownSelected = false;
                                addButton = true;
                                ruController.text = "";
                                deController.text = "";
                                descController.text = "";
                                autoController.text = "";
                                key.currentState.suggestions = [""];
                                key.currentState.updateDecoration(
                                    InputDecoration(
                                        fillColor: Color(0x55ffffff),
                                        focusColor: Color(0xffffffff),
                                        filled: true,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: "russisches Wort"),
                                    null,
                                    null,
                                    null,
                                    null,
                                    null);
                                selectedTopic = newTopic;
                                vocs = snapshot.data()['vocabulary'];
                                key.currentState.suggestions =
                                    vocs.keys.toList();
                              });
                            });
                          },
                        ))),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeVertical * 1,
                    right: SizeConfig.blockSizeVertical * 1,
                    bottom: SizeConfig.blockSizeHorizontal * 2,
                  ),
                  child: new SimpleAutoCompleteTextField(
                    key: key,
                    controller: autoController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0x55ffffff),
                      focusColor: Color(0xffffffff),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Thema auswählen!',
                      enabled: topicSelected,
                    ),
                    suggestions: suggestions,
                    textChanged: (text) => {
                      if (text == "")
                        {
                          setState(() {
                            selected = false;
                            dropDownSelected = false;
                            addButton = true;
                            ruController.text = "";
                            deController.text = "";
                            descController.text = "";
                          })
                        },
                      currentText = text
                    },
                    clearOnSubmit: true,
                    textSubmitted: (text) => setState(() {
                      print("subbmitted");
                      if (text != "") {
                        added.add(text);
                        dropDownSelected = true;
                        addButton = false;
                        if (vocs.containsKey(text)) {
                          ruController.text = vocs[text]['ru'];
                          deController.text = vocs[text]['de'];
                          descController.text = vocs[text]['desc'].toString();
                        } else {
                          ruController.text = text;
                          deController.text = "";
                          descController.text = "";
                        }
                        selected = true;
                      }
                    }),
                  ),
                ),
                addButton ? FlatButton(onPressed: (){          
                      String text = autoController.text;
                      setState(() {
                      print("subbmitted");
                      if (text != "") {
                        addButton = false;
                        added.add(text);
                        dropDownSelected = true;
                        if (vocs.containsKey(text)) {
                          ruController.text = vocs[text]['ru'];
                          deController.text = vocs[text]['de'];
                          descController.text = vocs[text]['desc'].toString();
                        } else {
                          ruController.text = text;
                          deController.text = "";
                          descController.text = "";
                        }
                        selected = true;
                      }
                      });
                }, child:Text("add",style: TextStyle(color: Colors.white)), color:Colors.black) :SizedBox(),

                selected
                    ? Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeVertical * 1),
                        child: basicForm("Russisches Wort", 15,
                            "muss ausgefüllt sein", false, 1, ruController),
                      )
                    : SizedBox(),
                selected
                    ? Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeVertical * 1),
                        child: basicForm("Deutsche Übersetzung", 15,
                            "muss ausgefüllt sein", false, 1, deController),
                      )
                    : SizedBox(),
                selected
                    ? Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeVertical * 1),
                        child: basicForm("Beschreibung auf Russisch", 15,
                            "ist optional", false, null, descController,
                            height: SizeConfig.blockSizeVertical * 30),
                      )
                    : SizedBox(),
                // selected
                //     ? Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //             FloatingActionButton(
                //                 heroTag: "SaveButton",
                //                 onPressed: () async {
                //                   if (ruController.text.trim() != "" &&
                //                       deController.text.trim() != "" &&
                //                       selectedTopic != null) {
                //                     await saveNewVoc();
                //                   }
                //                   setState(() {
                //                     selected = false;
                //                     key.currentState.clear();
                //                   });
                //                 },
                //                 child: Icon(
                //                   Icons.save,
                //                   color: Colors.white,
                //                 )),
                //             FloatingActionButton(
                //                 heroTag: "DeleteButton",
                //                 onPressed: () async {
                //                   if (ruController.text.trim() != "" &&
                //                       deController.text.trim() != "" &&
                //                       selectedTopic != null) {
                //                     await deleteCard();
                //                   }
                //                 },
                //                 child: Icon(
                //                   Icons.delete,
                //                   color: Colors.white,
                //                 ))
                //           ])
                //     : SizedBox()
              ]),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeConfig.blockSizeVertical * 1),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      )),
                  selected ? Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeConfig.blockSizeVertical * 1),
                      child: FloatingActionButton(
                          heroTag: "SaveButton",
                          onPressed: () async {
                            if (ruController.text.trim() != "" &&
                                deController.text.trim() != "" &&
                                selectedTopic != null) {
                              await saveNewVoc();
                            }
                            setState(() {
                              selected = false;
                              key.currentState.clear();
                            });
                          },
                          child: Icon(
                            Icons.save,
                            color: Colors.white,
                          ))):SizedBox(),
                 selected ?  Padding(
                      padding: EdgeInsets.only(
                          right:SizeConfig.blockSizeHorizontal * 8, bottom: SizeConfig.blockSizeVertical * 1.5),
                      child: FloatingActionButton(
                          heroTag: "DeleteButton",
                          onPressed: () async {
                            if (ruController.text.trim() != "" &&
                                deController.text.trim() != "" &&
                                selectedTopic != null) {
                              await deleteCard();
                            }
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ))):SizedBox()
                ])));
  }
}
