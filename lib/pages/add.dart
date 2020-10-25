import 'package:flutter/material.dart';
import 'package:Vocablii/components/InputField.dart';
import 'package:http/http.dart' as http;

class AddVoc extends StatelessWidget {
  final String type; // voc, exc, aud
  AddVoc({this.type});

  dynamic translation;
  String target;

  dynamic fetchTranslation(String word, String origin) async {
    if(origin == 'ru') {
      target = 'de';
    } else {
      target = 'ru';
    }

    return await http.post(
      'https://translation.googleapis.com/language/translate/v2',
      headers: {
        'Authorization': '',
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: {
        "q": word,
        "source": origin,
        "target": target,
        "format": "text"
      });

    // {
    //   "data": {
    //     "translations": [{
    //       "translatedText": ""
    //     }]
    //   }
    // }
  }

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
          basicForm('Russische Vokabel', 12.0, 'Something is wrong', false,1, null),
          // TODO: Add automatic translate -> fetchTranslation(input, lang)
          basicForm('Deutsche Übersetzung', 12.0, 'Something is wrong', false,1, null),
          basicForm('Beschreibung', 12.0, 'Something is wrong', false, null ,null),
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
