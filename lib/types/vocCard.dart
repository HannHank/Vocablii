import 'dart:ffi';

import 'package:flutter/material.dart';
// class VocCard extends StatefulWidget{
//    final int index;
//   final String word;
//   final String translation;
//   final String description;
//   final Color color;
//   VocCard(
//       {this.index, this.word, this.translation, this.description, this.color});

//   @override
//   State<StatefulWidget> createState() {
//     return _VocCard();
//   }
// }

// class _VocCard extends State<VocCard> {



//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: widget.color, borderRadius: new BorderRadius.circular(11)),
//       width: 300,
//       height: 500,
//       child: Center(
//         child: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(widget.word,
//                   style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w800)),
//               Text(widget.translation,
//                   style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w800)),
//               Text(widget.description,
//                   style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w800)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class VocCard extends StatefulWidget {
  final int index;
  final String word;
  final String translation;
  final String description;
  final Color color;
  bool expanded;

  VocCard(
      {this.index, this.word, this.translation, this.description, this.color,this.expanded});

  @override
  _VocCardState createState() => _VocCardState(
      color: color, word: word, translation: translation, descr: description);
}

class _VocCardState extends State<VocCard> {
  Color color;
  String word;
  String translation;
  String descr;


  _VocCardState({this.color, this.word, this.translation, this.descr});

  void change() {
    setState(() {
      widget.expanded = true;
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
    return widget.expanded ?
     Container(
      decoration: BoxDecoration(
          color: widget.color, borderRadius: new BorderRadius.circular(11)),
      width: 300,
      height: 500,
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.word,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800)),
              Text(widget.translation,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800)),
              Text(widget.description,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    ):


    Container(
      decoration: BoxDecoration(
          color: widget.color, borderRadius: new BorderRadius.circular(11)),
      width: 300,
      height: 500,
      child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(word,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800)),
              FlatButton(color: Colors.black,  child: Text("Show",style: TextStyle(color: Colors.white),),onPressed: (){change();},)
            ],
          ),
        ),
      ),
    );
          // : Container(
          //     decoration: BoxDecoration(
          //         color: color, borderRadius: new BorderRadius.circular(11)),
          //     width: 300,
          //     height: 500,
          //     child: Center(
          //       child: Container(
          //         child: Column(
          //           children: [
          //             Text(word,
          //                 style: TextStyle(
          //                     fontSize: 20,
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.w800)),
          //           ],
          //         ),
          //       ),
              // ),
            
   
  }
}
