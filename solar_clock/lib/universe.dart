import 'dart:math';

import 'package:flutter/material.dart';

class Twinkle {
  const Twinkle({
    @required this.left,
    @required this.top,
    @required this.type
  });

  final double left;
  final double top;
  final int type;
}

class Universe extends StatefulWidget {
  Universe({ this.size });

  final Size size;

  @override
  _UniverseState createState() => _UniverseState();
}

class _UniverseState extends State<Universe> with TickerProviderStateMixin {
  Size _size;

  List<Twinkle> _twinkleList;
  final int _twinkleCount = 60;

  AnimationController _twinkleController;
  List<Animation> _fadeAnimations;
  Animation _sizeAnimation;

  AnimationController _backgroundController;
  Animation _colorAnimationStart, _colorAnimationEnd;

  @override
  void initState() {
    super.initState();

    _size = widget.size;

    // Init twinkles.
    _twinkleList = List();
    for (int i = 0; i < _twinkleCount; i++) {
      _twinkleList.add(Twinkle(
          left: Random().nextDouble() * _size.width,
          top: Random().nextDouble() * _size.height,
          type: Random().nextInt(4)
        )
      );
    }

    initTwinkleAnimation();
    initBackgroundAnimation();

    // Start animations.
    _twinkleController.forward();
    _backgroundController.forward();
  }

  void initTwinkleAnimation() {
    _twinkleController = AnimationController(vsync: this, duration: Duration(milliseconds: 6000));

    // Fade animations.
    List<double> tweens = [0.0, 1.0];
    List<Interval> intervals = [Interval(0.0, 0.5), Interval(0.5, 1.0)];
    int count = 4;
    _fadeAnimations = List();
    for (int i = 0; i < count; i++) {
      Animation fadeAnimation = Tween(begin: tweens[i ~/ 2], end: tweens[(count - i - 1) ~/ 2])
        .animate(CurvedAnimation(parent: _twinkleController, curve: intervals[i % 2]));
      fadeAnimation.addListener(() {
        setState(() {});
      });
      _fadeAnimations.add(fadeAnimation);
    }
    
    _sizeAnimation = Tween(begin: 0.0, end: 3.5)
        .animate(CurvedAnimation(parent: _twinkleController, curve: Interval(0.0, 0.5)));
    _sizeAnimation.addListener(() {
      setState(() {});
    });

    _twinkleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _twinkleController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _twinkleController.forward();
      }
    });
  }

  void initBackgroundAnimation() {
    _backgroundController = AnimationController(vsync: this, duration: Duration(milliseconds: 4000));
    _colorAnimationStart = ColorTween(begin: Color(0xFF33597A), end: Color(0xFF2B669B)).animate(_backgroundController);
    _colorAnimationEnd = ColorTween(begin: Color(0xFF152440), end: Color(0xFF081F4A)).animate(_backgroundController);
    _backgroundController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _backgroundController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _backgroundController.forward();
      }
    });
  }

  @override
  void dispose() {
    _twinkleController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size.width,
      height: _size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_colorAnimationStart.value, _colorAnimationEnd.value],
          begin: FractionalOffset(0.0, 0.5),
          end: FractionalOffset(0.5, 1.0),
        )
      ),
      child: twinkleStack()
    );
  }

  Widget twinkleWidget(double left, double top, int type) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        alignment: FractionalOffset.center,
        width: 10,
        height: 10,
        child: Opacity(
          opacity: _fadeAnimations[type].value,
          child: Icon(
            Icons.lens,
            color: Colors.white,
            size: _sizeAnimation.value,
          ),
        ),
      ),
    );
  }

  Widget twinkleStack() {
    List<Widget> widgets = List();
    for (int i = 0; i < _twinkleCount; i++) {
      widgets.add(twinkleWidget(_twinkleList[i].left, _twinkleList[i].top, _twinkleList[i].type));
    }
    return Stack(children: widgets);
  }
}
