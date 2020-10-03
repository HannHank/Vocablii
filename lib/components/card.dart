import 'package:flutter/material.dart';

// The basic card component to display vocabulray. Should have a expanded and closed state, show the vocabulary and play the audio. In opend state it has Additionally 3 buttons and shows a description or context for the vocabulary
// for audio different ui
// for excercises different ui

class Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
              Text('Word 1'),
              Text('I am an Icon')
          ],
        ),
    ));
  }
}
