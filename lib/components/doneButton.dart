import 'package:flutter/material.dart';

Widget doneButton(context) {

    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: FlatButton(
            padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child:Icon(Icons.arrow_downward,color: Colors.white,),
          ),
        ),
      ),
    );
  }

var overlayEntry;
showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: doneButton(context));
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      
      overlayEntry = null;
    }
  }