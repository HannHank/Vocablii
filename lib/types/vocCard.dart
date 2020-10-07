import 'package:flutter/material.dart';
class VocCard extends StatelessWidget {

  final int index;
  final String word;
  final String translation;
  final String description;
  final Color color;

  VocCard(
      {this.index, this.word, this.translation, this.description, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: new BorderRadius.circular(11)),
      width: 300,
      height: 500,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 30, offset: Offset(-11, -11), color: Color(0x9900000))
            ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(word,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800)),
              Text(translation,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w800)),
              Text(description,
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

// class VocCard extends StatefulWidget {
//   final int index;
//   final String word;
//   final String translation;
//   final String description;
//   final Color color;

//   VocCard(
//       {this.index, this.word, this.translation, this.description, this.color});

//   @override
//   _VocCardState createState() => _VocCardState(
//       color: color, word: word, translation: translation, descr: description);
// }

// class _VocCardState extends State<VocCard> {
//   Color color;
//   String word;
//   String translation;
//   String descr;

//   bool expanded = false;

//   _VocCardState({this.color, this.word, this.translation, this.descr});

//   void change() {
//     setState(() {
//       expanded = true;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       color = color;
//       word = word;
//       translation = translation;
//       descr = descr;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => {change()},
//       child: expanded
//           ? Container(
//               decoration: BoxDecoration(
//                   color: color, borderRadius: new BorderRadius.circular(11)),
//               width: 300,
//               height: 500,
//               child: Center(
//                 child: Container(
//                   child: Column(
//                     children: [
//                       Text(translation,
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w800)),
//                       Text(descr,
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w800)),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           : Container(
//               decoration: BoxDecoration(
//                   color: color, borderRadius: new BorderRadius.circular(11)),
//               width: 300,
//               height: 500,
//               child: Center(
//                 child: Container(
//                   child: Column(
//                     children: [
//                       Text(word,
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w800)),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
