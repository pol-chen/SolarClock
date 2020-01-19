import 'package:flutter/material.dart';

abstract class Star extends StatelessWidget {
  const Star({
    @required this.color,
    @required this.radius,
    @required this.radian
  })  : assert(color != null),
        assert(radius != null),
        assert(radian != null);

  final Color color;
  final double radius;
  final double radian;
}
