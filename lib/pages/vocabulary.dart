import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/vocCard.dart';
import 'package:Vocablii/home.dart';
import 'package:Vocablii/helper/helper_functions.dart';
import 'package:Vocablii/helper/responsive.dart';

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
   GlobalKey<RefreshIndicatorState> refreshKey;
  @override
  void initState() {
    super.initState();
    setState(() {
      refreshKey = args['key']['refresh'];
    });
    print("args: " + args.toString());

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return 
    WillPopScope(
      onWillPop:  () async{
       Navigator.pushNamed(context, Home.route);
       // refreshKey.currentState.show();
       return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                      Navigator.pushNamed(context, Home.route);
                      print("tabed");
              },
           child: Container(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                child: Align(
                  alignment: Alignment.topCenter,
                  child:Text( " < " + args.keys.toList()[0].toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                ))),
                
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 4),
              child:CardStack(
                args[args.keys.toList()[0]],
                args['userStateVoc'],
                args['user']['user'],
                args.keys.toList()[0].toString(),
                args['databaseTitle']['databaseTitle'],args['chunkSize']['chunkSize'])),
           ]),
        )
        ));
  }
}

class CardStack extends StatefulWidget {
  // final Function onCardChanged;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final Map voc;
  final Map userStateVoc;
  final User user;
  final String title;
  final String databaseTitle;
  final int chunkSize;
  CardStack(
      this.voc, this.userStateVoc, this.user, this.title, this.databaseTitle, this.chunkSize);
  @override
  _CardStackState createState() => _CardStackState(voc);
}

class _CardStackState extends State<CardStack>
    with SingleTickerProviderStateMixin {
  final Map voc;

  _CardStackState(this.voc);

  List cards;

  int currentIndex;
  AnimationController controller;
  CurvedAnimation curvedAnimation;
  Animation<Offset> _translationAnim;
  Animation<Offset> _moveAnim;
  Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    // print("saved: " + widget.userStateVoc.toString());
    int amount = (voc.keys.toList().length) ;
    // print("voc: " + voc[voc.keys.toList()[200]].toString());
    List vocKeys = voc.keys.toList();
    // print("bevor: " + vocKeys.toString());
    vocKeys.shuffle();
    // print("after: " + vocKeys.toString());
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

    cards = new List<VocCard>.generate(widget.chunkSize != 0 && widget.chunkSize < amount ? widget.chunkSize:amount, (i) {
      return VocCard(
        remove:(){
          controller.forward().whenComplete(() {
              setState(() {
                controller.reset();
                VocCard removedCard = cards.removeAt(0);
                currentIndex = cards[0].index;
                print(currentIndex.toString() + cards[currentIndex].word);
              });
            });
        },
          move: () {
            controller.forward().whenComplete(() {
              setState(() {
                controller.reset();
                cards[0].stateCard = get_color(cards[0].name, {cards[0].name: cards[0].stateCard['state']});
                print("setting color" + cards[0].stateCard.toString());
                print("state: " + cards[0].stateCard.toString());
                VocCard removedCard = cards.removeAt(0);
                cards.add(removedCard);
                currentIndex = cards[0].index;
                print(cards.length.toString() + "card" + cards[0].index.toString());
                print(currentIndex.toString() + cards[currentIndex - 1].word);
                // if (widget.onCardChanged != null)
                //   widget.onCardChanged(cards[0].word, cards[0].translation,
                //       cards[0].description, cards[0].color);
              });
            });
          },
          index: i,
          word: voc[vocKeys[i]]['ru'].toString(),
          translation: voc[vocKeys[i]]['de'].toString(),
          description: voc[vocKeys[i]]['desc'].toString(),
          stateCard: get_color(vocKeys[i].toString(), widget.userStateVoc['class'][widget.title]),
          expanded: false,
          user: widget.user,
          name: vocKeys[i],
          title: widget.title,
          databaseTitle: widget.databaseTitle,
          adminState: widget.userStateVoc['admin']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        // overflow: Overflow.visible,
        children: cards.reversed.map((card) {
      if (cards.indexOf(card) <= 2) {
        return GestureDetector(
            child: InkWell(
              borderRadius: BorderRadius.circular(11),
              onDoubleTap: () {
                setState(() {
                  VocCard removedCard = cards.removeAt(cards.length - 1);
                  cards.insert(0, removedCard);
                  currentIndex = cards[0].index;
                });
              },
              onTap: () {
                controller.forward().whenComplete(() {
                  setState(() {
                    controller.reset();
                    VocCard removedCard = cards.removeAt(0);
                    cards.add(removedCard);
                    currentIndex = cards[0].index;
                    print(currentIndex);
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
            ));
      } else {
        return Container();
      }
    }).toList());
  }

  Offset _getStackedCardOffset(VocCard card) {
    int diff;
    if(currentIndex > card.index){
      diff = (cards.length - currentIndex) + card.index;
    }else{
      diff = card.index - currentIndex;
    }
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
    if(currentIndex > card.index){
      diff = (cards.length - currentIndex) + card.index;
    }
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
