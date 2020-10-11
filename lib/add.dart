import 'package:flutter/material.dart';
import 'package:Vocablii/components/InputField.dart';

class AddVoc extends StatelessWidget {
  final String type; // voc, exc, aud
  AddVoc({this.type});

  @override
  Widget build(BuildContext context) {
    if (type == 'voc') {
      return Column(
        children: [
          Text(
            'Vokabel hinzufügen',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          basicForm('Russische Vokabel', 12.0, 'Something is wrong', null),
          // TODO: Add automatic translate
          basicForm('Deutsche Übersetzung', 12.0, 'Something is wrong', null),
          basicForm('Beschreibung', 12.0, 'Something is wrong', null),
          FloatingActionButton(
            onPressed: null,
            child: Text('hinzufügen'),
          )
        ],
      );
    } else if (type == 'exc') {
      return Column(
        children: [Text('Aufgabe hinzufügen')],
      );
    } else if (type == 'aud') {
      return Column(
        children: [Text('Audio hinzufügen')],
      );
    } else {
      return Container();
    }
  }
}
