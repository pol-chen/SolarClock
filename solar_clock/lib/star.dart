import 'package:flutter/material.dart';

abstract class Star extends StatelessWidget {
  const Star({
    @required this.radius,
    @required this.center,
  })  : assert(radius != null),
        assert(center != null);

  final double radius;
  final Offset center;
}
