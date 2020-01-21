import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

import 'solar_clock.dart';

void main() => runApp(ClockCustomizer((ClockModel model) => SolarClock(model)));
