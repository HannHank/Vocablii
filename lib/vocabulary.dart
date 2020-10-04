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
  // TCardController _controller = TCardController();

  int currentIndex;
  bool state = true;

  // VocCard voc1;
  // VocCard voc2;
  // VocCard voc3;

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
// Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: InkWell(
//                 onTap: () {
//                   if (state) {
//                     setState(() {
//                       state = false;
//                     });
//                   } else {
//                     setState(() {
//                       state = true;
//                     });
//                   }
//                 },
//                 child: ListView.builder(
//                   itemCount: 3,
//                   itemBuilder: (BuildContext ctxt, int index) {
//                     return state
//                         ? Container(
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: random_color(
//                                   colors,
//                                   voc_shuffeled[voc_shuffeled.keys
//                                           .toList()[index]]['ru']
//                                       .toString()),
//                               borderRadius: new BorderRadius.circular(20.0),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 voc_shuffeled[voc_shuffeled.keys
//                                         .toList()[index]]['ru']
//                                     .toString(),
//                                 style: TextStyle(
//                                     fontSize: 50.0, color: Colors.white),
//                               ),
//                             ))
//                         : Container(
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: random_color(
//                                   colors,
//                                   voc_shuffeled[voc_shuffeled.keys
//                                           .toList()[index]]['ru']
//                                       .toString()),
//                               borderRadius: new BorderRadius.circular(20.0),
//                             ),
//                             child: Center(
//                                 child: Column(children: [
//                               Text(
//                                 voc_shuffeled[voc_shuffeled.keys
//                                         .toList()[index]]['de']
//                                     .toString(),
//                                 style: TextStyle(
//                                     fontSize: 50.0, color: Colors.white),
//                               ),
//                               Text(
//                                   voc[voc.keys.toList()[index]]['desc']
//                                       .toString(),
//                                   style: TextStyle(
//                                       fontSize: 50.0, color: Colors.white)),
//                             ])));
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 40,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
      print(expanded);
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
                child: Column(
                  children: [
                    Text('translation',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                    Text('description',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  color: color, borderRadius: new BorderRadius.circular(11)),
              width: 300,
              height: 500,
              child: Center(
                child: Column(
                  children: [
                    Text('word',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                  ],
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

  List<Color> colors = [
    Color(0xff2B969D),
    Color(0xff2B529D),
    Color(0xff862B9D),
    Color(0xff953232),
    Color(0xff3B7626),
    Color(0xff328D93),
  ];

  CollectionReference topics = FirebaseFirestore.instance.collection('topics');

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

    // TODO: Add right properties to anim
    _translationAnim = Tween(begin: Offset(0.0, 0.0), end: Offset(-1000.0, 0.0))
        .animate(controller)
          ..addListener(() {
            setState(() {});
          });

    // TODO: Add right properties to anim
    _scaleAnim = Tween(begin: 0.965, end: 1.0).animate(curvedAnimation);
    _moveAnim = Tween(begin: Offset(0.0, 0.05), end: Offset(0.0, 0.0))
        .animate(curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        children: cards.reversed.map((card) {
          if (cards.indexOf(card) <= 2) {
            return GestureDetector(
              onHorizontalDragEnd: _horizontalDragEnd,
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

  void _horizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity < 0) {
      // Swiped Right to Left
      controller.forward().whenComplete(() {
        setState(() {
          controller.reset();
          VocCard removedCard = cards.removeAt(0);
          cards.add(removedCard);
          currentIndex = cards[0].index;
          // if (widget.onCardChanged != null)
          //   widget.onCardChanged(cards[0].imageUrl);
        });
      });
    }
  }
}
