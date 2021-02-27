import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomSnackBar {
 showSnackBar({String title, GlobalKey<ScaffoldState> state}) {
     SnackBar _customSnackBar = SnackBar(
      content: Text(title,
      style: TextStyle(
        fontFamily: "AmaticSC",
        fontSize: 24.0,
        color: Colors.white,
      ),),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
     state.currentState.showSnackBar(_customSnackBar);
  }
}
