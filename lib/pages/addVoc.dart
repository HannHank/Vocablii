import 'package:flutter/material.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/components/InputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class AddVoc extends StatefulWidget {
  static const String route = "addVoc";
  final Map<String, String> args;

  AddVoc(this.args);
  @override
  _AddVoc createState() => _AddVoc();
}

class _AddVoc extends State<AddVoc> {
  CollectionReference topics = FirebaseFirestore.instance.collection('topics');

  final ruController = TextEditingController();
  final deController = TextEditingController();
  final descController = TextEditingController();

  List<String> suggestions = [];
  List<String> added = [];
  String currentText = "";
  bool selected = false;
  bool dropDownSelected = false;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  bool topicSelected = false;

  String selectedTopic;
  Map<String, dynamic> vocs;

  @override
  void initState() {
    super.initState();
    print("widget data: " + widget.args.toString());
  }

  saveNewVoc() async {
    await topics.doc(selectedTopic).update({
      "vocabulary." + ruController.text.trim(): {
        'ru': ruController.text.trim(),
        'desc': descController.text.trim(),
        'de': deController.text.trim()
      }
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
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
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
                              widget.args.keys.length, (i) {
                            return DropdownMenuItem(
                              value: widget.args.keys.toList()[i],
                              child: Text(
                                  widget.args[widget.args.keys.toList()[i]]),
                            );
                          }),
                          onChanged: (newTopic) async {
                            await topics.doc(newTopic).get().then((snapshot) {
                              setState(() {
                                topicSelected = true;
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          topicSelected ? Color(0xffffffff) : Color(0x55ffffff),
                      hintText: 'russisches Wort',
                      enabled: topicSelected,
                    ),
                    suggestions: suggestions,
                    textChanged: (text) => {
                      if (text == "")
                        {
                          setState(() {
                            selected = false;
                            dropDownSelected = false;
                            key.currentState.suggestions = [""];
                            ruController.text = "";
                            deController.text = "";
                            descController.text = "";
                          })
                        },
                      currentText = text
                    },
                    clearOnSubmit: false,
                    textSubmitted: (text) => setState(() {
                      print("subbmitted");
                      if (text != "") {
                        added.add(text);
                        dropDownSelected = true;
                        if (vocs.containsKey(text)) {
                          ruController.text = vocs[text]['ru'];
                          deController.text = vocs[text]['de'];
                          descController.text = vocs[text]['desc'].toString();
                        }
                        selected = true;
                      }
                    }),
                  ),
                ),
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
                            "ist optional", false, null, descController),
                      )
                    : SizedBox(),
                selected
                    ? FloatingActionButton(
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
                        ))
                    : SizedBox()
              ]),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: Padding(
                padding:
                    EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back),
                ))));
  }
}
