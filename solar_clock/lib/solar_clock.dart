import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

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
    
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Solar clock with time $time',
        value: time,
      ),
      child: Container(
        color: Color(0x00000000),
        child: Stack(
          children: <Widget>[
            Text('$time $_condition'),
          ],
        ),
      ),
    );
  }
}