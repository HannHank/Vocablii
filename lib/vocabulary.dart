import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_stack_card/flutter_stack_card.dart';
import 'package:flutter/material.dart';
import 'card/card.dart';
import 'package:Vocablii/login.dart';
import 'auth/auth.dart';
import 'package:Vocablii/helper/helper_functions.dart';

class Trainer extends StatefulWidget {
  static const String route = "vocabulary";
  final Map<String, Map> args;

  Trainer(this.args);
  @override
  State<StatefulWidget> createState() {
    return _Trainer();
  }
}

class _Trainer extends State<Trainer> {

  // int currentIndex;
  // bool state = true;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CardStack());
  }
}

class VocCard extends StatefulWidget {
  int index;
  String word;
  String translation;
  String description;
  Color color;

  VocCard(
      {this.index, this.word, this.translation, this.description, this.color});

  @override
  _VocCardState createState() => _VocCardState(
      color: color, word: word, translation: translation, descr: description);
}

class _VocCardState extends State<VocCard> {
  Color color;
  String word;
  String translation;
  String descr;

  bool expanded = false;

  _VocCardState({this.color, this.word, this.translation, this.descr});

  void change() {
    setState(() {
      expanded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      color = color;
      word = word;
      translation = translation;
      descr = descr; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {change()},
      child: expanded
          ? Container(
              decoration: BoxDecoration(
                  color: color, borderRadius: new BorderRadius.circular(11)),
              width: 300,
              height: 500,
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      Text(translation,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                      Text(descr,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  color: color, borderRadius: new BorderRadius.circular(11)),
              width: 300,
              height: 500,
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      Text(word,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CardStack extends StatefulWidget {
  final Function onCardChanged;

  CardStack({this.onCardChanged});
  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack>
    with SingleTickerProviderStateMixin {
  List<Widget> vocs = [];

  // TODO: Maybe add to VocCard
  List<Color> colors = [
    Color(0xff2B969D),
    Color(0xff2B529D),
    Color(0xff862B9D),
    Color(0xff953232),
    Color(0xff3B7626),
    Color(0xff328D93),
  ];

  CollectionReference topics = FirebaseFirestore.instance.collection('topics');

  // TODO: Maybe add to VocCard
  Map voc = {};
  Map voc_shuffeled = {};

  int currentIndex;
  AnimationController controller;
  CurvedAnimation curvedAnimation;
  Animation<Offset> _translationAnim;
  Animation<Offset> _moveAnim;
  Animation<double> _scaleAnim;

  // TODO: Make dynamic
  var cards = [
    VocCard(index: 0, word: 'hi', translation: 'wort', description: 'hello world', color: Colors.blue),

    VocCard(index: 1, word: 'nice', translation: 'schön', description: 'hello world 2', color: Colors.red),

    VocCard(index: 2, word: 'nice', translation: 'schön', description: 'hello world 2', color: Colors.yellow),
  ];

  @override
  void initState() {
    super.initState();
    // voc = widget.args[widget.args.keys.toList()[0]];
    // voc_shuffeled = shuffle_map(voc);

    currentIndex = 0;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);

    _translationAnim = Tween(begin: Offset(0.0, 0.0), end: Offset(-1000.0, 0.0))
        .animate(controller)
          ..addListener(() {
            setState(() {
              cards[0].color = cards[1].color;
              cards[1].color = cards[2].color;
            });
          });

    _scaleAnim = Tween(begin: 0.965, end: 1.0).animate(curvedAnimation);

    _moveAnim = Tween(begin: Offset(0.0, 0.05), end: Offset(0.0, 0.0))
        .animate(curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: cards.reversed.map((card) {
          if (cards.indexOf(card) <= 2) {
            // TODO: Button click to trigger slide instead of gesture
            return InkWell(
              onLongPress: () {
                controller.forward().whenComplete(() {
                  setState(() {
                    controller.reset();
                    VocCard removedCard = cards.removeAt(0);
                    cards.add(removedCard);
                    currentIndex = cards[0].index;

                    print('Color change: ' + cards[0].index.toString());
                  });
                });
              },
              child: Transform.translate(
                offset: _getFlickTransformOffset(card),
                child: FractionalTranslation(
                  translation: _getStackedCardOffset(card),
                  child: Transform.scale(
                    scale: _getStackedCardScale(card),
                    child: Center(child: card),
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        }).toList());
  }

  Offset _getStackedCardOffset(VocCard card) {
    int diff = card.index - currentIndex;
    if (card.index == currentIndex + 1) {
      return _moveAnim.value;
    } else if (diff > 0 && diff <= 2) {
      return Offset(0.0, 0.05 * diff);
    } else {
      return Offset(0.0, 0.0);
    }
  }

  double _getStackedCardScale(VocCard card) {
    int diff = card.index - currentIndex;
    if (card.index == currentIndex) {
      return 1.0;
    } else if (card.index == currentIndex + 1) {
      return _scaleAnim.value;
    } else {
      return (1 - (0.035 * diff.abs()));
    }
  }

  Offset _getFlickTransformOffset(VocCard card) {
    if (card.index == currentIndex) {
      return _translationAnim.value;
    }
    return Offset(0.0, 0.0);
  }
}
