import 'dart:math';

import 'package:flutter/material.dart';

final Color customRed = Color.fromRGBO(160, 74, 67, 1);
final Color customRedDarker = Color.fromRGBO(160, 74, 67, 1);
final Color customGreen = Color.fromARGB(255, 161, 195, 105);
final Color customGreenDarker = Color.fromARGB(255, 153, 175, 124);
final Color appColor = Color.fromARGB(255, 152, 196, 93);

Set<Color> usedColors = {}; // Para evitar repetidos
Color getUniqueColor() {
  Color newColor;
  do {
    newColor = Color.fromRGBO(
      Random().nextInt(181),
      Random().nextInt(181),
      Random().nextInt(181),
      1.0,
    );
  } while (usedColors.contains(newColor)); // Evita colores repetidos
  usedColors.add(newColor);
  return newColor;
}
