import 'package:flutter/material.dart';

import 'star.dart';

class DrawnStar extends Star {
  const DrawnStar({
    @required this.color,
    @required double radius,
    @required Offset center,
  })  : assert(color != null),
        assert(radius != null),
        assert(center != null),
        super(
          radius: radius,
          center: center,
        );

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _StarPainter(
            color: color,
            radius: radius,
            center: center,
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
    @required this.center,
  })  : assert(color != null),
        assert(radius != null),
        assert(center != null);

  Color color;
  double radius;
  Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
