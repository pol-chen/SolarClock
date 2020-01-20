import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'star.dart';

class FlareStar extends Star {
  const FlareStar({
    @required this.asset,
    @required double radius,
    @required Offset center,
  })  : assert(asset != null),
        assert(radius != null),
        assert(center != null),
        super(
          radius: radius * 2,
          center: center,
        );

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Positioned(
        left: center.dx - radius,
        top: center.dy - radius,
        child: SizedBox.fromSize(
          size: Size.fromRadius(radius),
          child: FlareActor(
            asset,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "solar",
          ),
        ),
      ),
    );
  }
}
