import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  final double? value1;
  final double? animValue1;
  final double? animValue2;
  final double? animValue3;
  final double? width;

  CurvePainter(
      {this.value1,
      this.animValue1,
      this.animValue2,
      this.animValue3,
      this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.moveTo(-width!, -value1!);
    path.quadraticBezierTo(-width!, -value1! + 20, -animValue3!, -value1! + 20);
    path.lineTo(-animValue1!, -value1! + 20);
    path.quadraticBezierTo(
        -animValue2!, -value1! + 20, -animValue2!, value1! + 40);
    path.lineTo(-width!, -value1! + 40);

    path.moveTo(-width!, -value1! + 80);
    path.quadraticBezierTo(-width!, -value1! + 60, -animValue3!, -value1! + 60);
    path.lineTo(-animValue1!, -value1! + 60);
    path.quadraticBezierTo(
        -animValue2!, -value1! + 60, -animValue2!, -value1! + 40);
    path.lineTo(-width!, -value1! + 40);

    paint.color = Colors.white;
    paint.strokeWidth = width!;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
