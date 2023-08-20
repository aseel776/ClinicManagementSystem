import 'package:clinic_management_system/core/app_colors.dart';
import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  /// Width of the dotted line.
  final double length;

  /// Color of the dotted line.
  final Color color;

  /// Radius of each dot in the dotted line.
  final double dotRadius;

  /// Spacing between the dots in the dotted line.
  final double spacing;

  final Axis axis;

  DottedLine({
    this.length = 50.0,
    this.color = Colors.grey,
    this.dotRadius = 2.0,
    this.spacing = 3.0,
    this.axis = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // If this is not applied, top half of the dot gets offscreen, hence, hidden.
      margin: EdgeInsets.only(top: dotRadius),
      width: axis == Axis.horizontal ? length : 0.0,
      height: axis == Axis.vertical ? length : 0.0,
      child: CustomPaint(
        painter: _DottedLinePainter(
          brush: Paint()..color = color,
          length: length,
          dotRadius: dotRadius,
          spacing: spacing,
          axis: axis,
        ),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final double length;
  final double dotRadius;
  final double spacing;
  final Paint? brush;
  final Axis axis;

  _DottedLinePainter({
    this.length = 100,
    this.brush,
    this.dotRadius = 2.0,
    this.spacing = 3.0,
    this.axis = Axis.horizontal,
  }) {
    assert(brush != null);
    assert(dotRadius > 0, 'dotRadius must be greater than 0');
  }

  @override
  void paint(Canvas canvas, Size size) {
    double start = -20.0;

    // Length of the line is calculated by dividing the supplied length [to] by dotRadius * space.
    int calculatedLength = (length + 200) ~/ (dotRadius * spacing);
    print("call" + calculatedLength.toString());

    for (int i = 1; i < calculatedLength; i++) {
      // New start becomes:
      start += dotRadius * spacing;
      // print(start);

      canvas.drawCircle(
        Offset(
          axis == Axis.horizontal ? start : 0.0,
          axis == Axis.horizontal ? 0.0 : start,
        ),
        dotRadius - 0.7,
        brush!,
      );
      if (i == (calculatedLength / 2.8).ceil()) {
        // print(i);
        canvas.drawCircle(
            Offset(
              axis == Axis.horizontal ? start : 0.0,
              axis == Axis.horizontal ? 0.0 : start,
            ),
            dotRadius * 3,
            Paint()..color = Colors.grey);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
