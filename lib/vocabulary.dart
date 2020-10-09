import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/vocCard.dart';
import 'package:Vocablii/helper/helper_functions.dart';

class Trainer extends StatefulWidget {
  static const String route = "vocabulary";
  final Map<String, Map> args;

  Trainer(this.args);
  @override
  State<StatefulWidget> createState() {
    return _Trainer(args);
  }
}

class _Trainer extends State<Trainer> {
  final Map<String, Map> args;

  _Trainer(this.args);
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CardStack(args[args.keys.toList()[0]]));
  }
}

class CardStack extends StatefulWidget {
  // final Function onCardChanged;
  final Map voc;
 
  CardStack(this.voc);
  @override
  _CardStackState createState() => _CardStackState(voc);
}

class _CardStackState extends State<CardStack>
  with SingleTickerProviderStateMixin {
    final Map voc;
    _CardStackState(this.voc);

  List cards;

  List<Color> colors = [
    Color(0xff2B969D),
    Color(0xff2B529D),
    Color(0xff862B9D),
    Color(0xff953232),
    Color(0xff3B7626),
    Color(0xff328D93),
  ];

  CollectionReference topics = FirebaseFirestore.instance.collection('topics');

  int currentIndex;
  AnimationController controller;
  CurvedAnimation curvedAnimation;
  Animation<Offset> _translationAnim;
  Animation<Offset> _moveAnim;
  Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    int amount = (voc.keys.toList().length - 1);
    print("voc: " + voc[voc.keys.toList()[200]].toString());
    
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
            setState(() {});
          });

    _scaleAnim = Tween(begin: 0.965, end: 1.0).animate(curvedAnimation);

    _moveAnim = Tween(begin: Offset(0.0, 0.05), end: Offset(0.0, 0.0))
        .animate(curvedAnimation);

    cards = new List<VocCard>.generate(199, (i) {
      return VocCard(
         move: () {
                     controller.forward().whenComplete(() {
              setState(() {
                controller.reset();

                VocCard removedCard = cards.removeAt(0);
                cards.add(removedCard);
                currentIndex = cards[0].index;

                print(currentIndex.toString() + cards[currentIndex].word);

                // if (widget.onCardChanged != null)
                //   widget.onCardChanged(cards[0].word, cards[0].translation,
                //       cards[0].description, cards[0].color);
              });
              
                     });
         },
                    
        index: i,
        word: voc[voc.keys.toList()[i]]['ru'].toString(),
        translation: voc[voc.keys.toList()[i]]['de'].toString(),
        description: voc[voc.keys.toList()[i]]['desc'].toString(),
        color:  random_color(colors, voc[voc.keys.toList()[i]]['de']),
        expanded: false,
    );

  });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        // overflow: Overflow.visible,
        children: cards.reversed.map((card) {
      if (cards.indexOf(card) <= 2) {
        return InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: () {
            controller.forward().whenComplete(() {
              setState(() {
                controller.reset();

                VocCard removedCard = cards.removeAt(0);
                cards.add(removedCard);
                currentIndex = cards[0].index;

                print(currentIndex.toString() + cards[currentIndex].word);

                // if (widget.onCardChanged != null)
                //   widget.onCardChanged(cards[0].word, cards[0].translation,
                //       cards[0].description, cards[0].color);
              });
            });
          },
          child: Transform.translate(
            offset: _getFlickTransformOffset(card),
            child: FractionalTranslation(
              translation: _getStackedCardOffset(card),
              child: Transform.scale(
                scale: _getStackedCardScale(card),
                // the actual card component
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

