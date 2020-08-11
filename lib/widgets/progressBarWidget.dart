import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Progress extends CustomPainter {
  var  current;
  var colors;
  var  allSize;
  var  width;
  var  height;

  Progress({this.current, this.colors, this.allSize, this.width, this.height});


  @override
  void paint(Canvas canvas, Size size) {
    if (this.current == null)
      this.current = 0;
    print(this.current);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTRB(
          0.0, 0.0, ((this.width??1.0 )/ this.allSize) * (this.current + 1), 4),
          const Radius.circular(7)),
      Paint()
        ..color = this.colors,
    );
  }

  @override
  bool shouldRepaint(Progress oldDelegate) {
    return true;
  }
  
}