import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'drawn_star.dart';

class SolarClock extends StatefulWidget {
  const SolarClock(this.model);

  final ClockModel model;

  @override
  _SolarClockState createState() => _SolarClockState();
}

class _SolarClockState extends State<SolarClock> {
  var _now = DateTime.now();
  var _condition = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(SolarClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _condition = widget.model.weatherString;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update time once per second.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hms().format(DateTime.now());

    final backgroundColor = Color(0xFFFFFFFF);
    final sunColor = Color(0xFFD2E3FC);
    final earthColor = Color(0xFF1113FC);
    final moonColor = Color(0xF201030C);
    
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Solar clock with time $time',
        value: time,
      ),
      child: Container(
        color: backgroundColor,
        child: Stack(
          children: <Widget>[
            Text('$time $_condition'),
            DrawnStar(
              color: sunColor,
              radius: 50,
              radian: _now.hour * radians(360 / 12) + _now.minute * radians(360 / 12 / 60) + _now.second * radians(360 / 12 / 60 / 60),
            ),
            DrawnStar(
              color: earthColor,
              radius: 25,
              radian: _now.minute * radians(360 / 60) + _now.second * radians(360 / 60 / 60),
            ),
            DrawnStar(
              color: moonColor,
              radius: 10,
              radian: _now.second * radians(360 / 60),
            ),
          ],
        ),
      ),
    );
  }
}