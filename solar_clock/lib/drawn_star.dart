import 'dart:math';

import 'package:flutter/material.dart';

import 'star.dart';

class DrawnStar extends Star {
  const DrawnStar({
    @required Color color,
    @required double radius,
    @required double radian,
  })  : assert(color != null),
        assert(radius != null),
        assert(radian != null),
        super(
          color: color,
          radius: radius,
          radian: radian,
        );

  final distance = 10;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _StarPainter(
            color: color,
            radius: radius,
            radian: radian,
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  _StarPainter({
    @required this.color,
    @required this.radius,
    @required this.radian,
  })  : assert(color != null),
        assert(radius != null),
        assert(radian != null);

  Color color;
  double radius;
  double radian;

  @override
  void paint(Canvas canvas, Size size) {
    final canvasCenter = (Offset.zero & size).center;
    final relativeCenter = canvasCenter;
    final distance = 100.0;
    final circleCenter = relativeCenter + Offset.fromDirection(radian - pi / 2.0, distance);
    final paint = Paint()
      ..color = color;
    canvas.drawCircle(circleCenter, radius, paint);
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
