import 'package:flutter/material.dart';

abstract class Star extends StatelessWidget {
  const Star({
    @required this.color,
    @required this.radius,
    @required this.center,
  })  : assert(color != null),
        assert(radius != null),
        assert(center != null);

  final Color color;
  final double radius;
  final Offset center;
}
