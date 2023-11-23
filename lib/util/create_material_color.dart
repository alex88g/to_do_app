import 'package:flutter/material.dart';

// Denna funktion genererar en MaterialColor från en given grundläggande färg genom att skapa nyanser av färgen.
MaterialColor createMaterialColor(Color color) {
  // Lista med styrkor för nyanser av färgen
  List<double> strengths = <double>[.05];
  // Karta för att lagra nyanser av färgen
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  // Skapa nyanser av färgen med olika styrkor
  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    // Skapa nyansen av färgen och lägg till den i karta
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((r - 255).abs() * ds).round(),
      g + ((g - 255).abs() * ds).round(),
      b + ((b - 255).abs() * ds).round(),
      1,
    );
  }
  // Returnera den genererade MaterialColor
  return MaterialColor(color.value, swatch);
}

//Denna funktion är en del av Flutter-tema- och designanpassning och används oftast för att definiera temafärger och färgpaletter,
//createMaterialColor som används för att skapa en anpassad primärfärg (MaterialColor) 

