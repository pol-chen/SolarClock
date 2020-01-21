import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:solar_clock/flare_star.dart';
import 'package:solar_clock/universe.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class SolarClock extends StatefulWidget {
  const SolarClock(this.model);

  final ClockModel model;

  @override
  _SolarClockState createState() => _SolarClockState();
}

class _SolarClockState extends State<SolarClock> with AfterLayoutMixin<SolarClock> {
  var _now = DateTime.now();
  var _condition = '';
  Timer _timer;
  var _size;

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
    if (_size != null) {
      final time = DateFormat.Hms().format(DateTime.now());
  
      final anchorRadius = 48.0;
      final anchorCenter = _size.center(Offset.zero);

      final hourRadius = 18.0;
      final hourDistance = _size.height / 2.0 - hourRadius - 20.0;
      final hourRadian = _now.hour * radians(360 / 12) + _now.minute * radians(360 / 12 / 60) + _now.second * radians(360 / 12 / 60 / 60) - pi / 2.0;
      final hourCenter = anchorCenter + Offset.fromDirection(hourRadian, hourDistance);

      final minuteRadius = 8.0;
      final minuteDistance = hourRadius + 10.0 + minuteRadius;
      final minuteRadian = _now.minute * radians(360 / 60) + _now.second * radians(360 / 60 / 60) - pi / 2.0;
      final minuteCenter = hourCenter + Offset.fromDirection(minuteRadian, minuteDistance);

      final sun = FlareStar(
        asset: "assets/sun.flr",
        radius: anchorRadius,
        center: anchorCenter,
      );

      final earth = FlareStar(
        asset: "assets/earth.flr",
        radius: hourRadius,
        center: hourCenter,
      );

      final moon = FlareStar(
        asset: "assets/moon.flr",
        radius: minuteRadius,
        center: minuteCenter,
      );
      
      // Use Semantics to support accessibility, allowing screen reader to speak out the time.
      return Semantics.fromProperties(
        properties: SemanticsProperties(
          label: 'Solar Clock with time $time weather $_condition',
          value: time,
        ),
        child: Container(
          color: Color(0xFF152440),
          child: Stack(
            children: <Widget>[
              Universe(size: _size),
              sun,
              earth,
              moon,
            ],
          ),
        ),
      );
    }
    return Container();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      final RenderBox renderBox = context.findRenderObject();
      _size = renderBox.size;
    });
  }

  // TODO: Handle screen size to star radius
}
