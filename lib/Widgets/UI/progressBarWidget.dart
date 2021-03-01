import 'package:flutter/cupertino.dart';

class Progress extends CustomPainter {
  double current;
  Color colors;
  final double allSize;
  final double width;
  final double height;
  final double radius;

  Progress({
    this.current,
    this.colors,
    this.allSize,
    this.width,
    this.height,
    this.radius
  });

  /// Progress Bar
  /// Draw indicator where :
  /// [current] is a offset position of ScrollController
  /// [colors] is a Custom Color
  /// [allSize] is a Max scroling height of your scroll area
  /// [width] is a width of you area where Progress Bar will build
  /// [height] is a height of you Progress Bar


  @override
  void paint(Canvas canvas, Size size) {
    if (this.current == null)
      this.current = 0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTRB(
              0.0,
              0.0,
              ((this.width)/ this.allSize) * (this.current + 1),
              this.height
          ),
          Radius.circular(this.radius)
      ),
      Paint()
        ..color = this.colors,
    );
  }

  @override
  bool shouldRepaint(Progress oldDelegate) {
    return true;
  }
  
}