import 'package:flutter/material.dart';
import 'package:Vocablii/helper/responsive.dart';
import 'package:Vocablii/components/InputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVoc extends StatefulWidget {
  static const String route = "addVoc";
  final Map<String, String> args;

  AddVoc(this.args);
  @override
  _AddVoc createState() => _AddVoc();
}

class _AddVoc extends State<AddVoc> {
  CollectionReference topics = FirebaseFirestore.instance.collection('test');

  final ruController = TextEditingController();
  final deController = TextEditingController();
  final descController = TextEditingController();

  String selectedTopic;
  Map<String, dynamic> vocs;

  @override
  void initState() {
    super.initState();
    print("widget data: " + widget.args.toString());
  }

  saveNewVoc() async {
    // print("value: " + selectedTopic.toString());
    // await topics.doc(selectedTopic).get().then((snapshot) => {
    //       setState(() {
    //         vocs = snapshot.data()['vocabulary'];
    //       }),
    //     });
    // List<String> newList = [];
    //  vocs.keys.toList().forEach((element) {
    //       newList.add(element.substring(4));
    //  });
    //  newList.sort();
 
    //  int id = int.parse(newList.last) + 1;
    //  int diff = 4 - id.toString().length;

    //  String newId = "voc_" + "0" * diff + id.toString();
    //  print("newId: " +  newId);
     await topics.doc(selectedTopic).update({  "vocabulary." + ruController.text.trim():{'ru':ruController.text.trim(),'desc':descController.text.trim(),'de':deController.text.trim()}});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.purple,
        body: Column(children: [
          Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 10,
                  left: SizeConfig.blockSizeVertical * 1,
                  right: SizeConfig.blockSizeVertical * 1,
                  bottom: SizeConfig.blockSizeVertical * 5),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        child: Text(widget.args[widget.args.keys.toList()[i]]),
                      );
                    }),
                    onChanged: (newTopic) {
                      setState(() {
                        selectedTopic = newTopic;
                      });
                    },
                  ))),
          Padding(
            padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 1),
            child: basicForm("Russisches Wort", 15, "muss ausgefüllt sein",
                false, 1, ruController),
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 1),
            child: basicForm("Deutsche Übersetzung", 15, "muss ausgefüllt sein",
                false, 1, deController),
          ),
          Padding(
            padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 1),
            child: basicForm("Beschreibung auf Russisch", 15, "ist optional",
                false, null, descController),
          ),
          FloatingActionButton(
              heroTag: "SaveButton",
              onPressed: () async {
                if (ruController.text.trim() != "" &&
                    deController.text.trim() != "" &&
                    selectedTopic != null) {
                  await saveNewVoc();
                }
              },
              child: Icon(
                Icons.save,
                color: Colors.white,
              ))
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
            )));
  }
}
