import 'package:flutter/material.dart';

ThemeData lightMode =  ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background:Colors.white,
    primary: Colors.grey.shade800,
    secondary: Colors.blue,
    tertiary: Colors.white,
    onSurface: Colors.white
  ),
);

ThemeData darkMode =  ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background:Color.fromARGB(255, 43, 42, 42),
    primary: Colors.white,
    secondary: Color.fromARGB(255, 109, 184, 246),
    tertiary: Color.fromARGB(255, 55, 54, 54),
    onSurface: Color.fromARGB(255, 43, 42, 42)
  ),
  
);

class AppStyle {
  static List<Color> CardsColorsLight = [ 
    Colors.white,
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.yellow.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.brown.shade100,
    Colors.indigo.shade100,
    Colors.pink.shade100,
    Colors.cyan.shade100,
    Colors.teal.shade100,
  ];

  static List<Color> CardsColorsDark = [ 
    Colors.grey.shade800,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.blue.shade200,
    Colors.yellow.shade200,
    Colors.purple.shade200,
    Colors.orange.shade200,
    Colors.brown.shade200,
    Colors.indigo.shade200,
    Colors.pink.shade200,
    Colors.cyan.shade200,
    Colors.teal.shade200,
  ];
}