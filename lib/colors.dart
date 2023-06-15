import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFE2E8EA),
  100: Color(0xFFB7C5CA),
  200: Color(0xFF879EA6),
  300: Color(0xFF577782),
  400: Color(0xFF335968),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF0D3646),
  700: Color(0xFF0B2E3D),
  800: Color(0xFF082734),
  900: Color(0xFF041A25),
});
const int _primaryPrimaryValue = 0xFF0F3C4D;

const MaterialColor mprimaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFF60C1FF),
  200: Color(_primaryAccentValue),
  400: Color(0xFF0098F9),
  700: Color(0xFF0088E0),
});

const List<Color> gradient = [
  Color.fromRGBO(24, 26, 32, 1),
  Color.fromRGBO(24, 26, 32, 0.9),
  Color.fromRGBO(24, 26, 32, 0.8),
  Color.fromRGBO(24, 26, 32, 0.7),
  Color.fromRGBO(24, 26, 32, 0.6),
  Color.fromRGBO(24, 26, 32, 0.5),
  Color.fromRGBO(24, 26, 32, 0.4),
  Color.fromRGBO(24, 26, 32, 0.0),
];
const int _primaryAccentValue = 0xFF2DADFF;