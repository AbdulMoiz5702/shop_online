import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../consts/styles.dart';


Widget largeText(
    {title,
      Color color = Colors.white,
      textSize = 20.0,
      FontWeight weight = FontWeight.bold}) {
  return Text(
    title.toString(),
    textAlign: TextAlign.center,
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily:bold),
  );
}

Widget normalText(
    {title,
      Color color = Colors.white,
      textSize = 16.0,
      FontWeight weight = FontWeight.w700}) {
  return Text(
    title.toString(),
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: semibold),
  );
}


Widget smallText(
    {title,
      Color color = Colors.white,
      textSize = 12.0,
      FontWeight weight = FontWeight.w500}) {
  return Text(
    title.toString(),
    style: TextStyle(color: color, fontSize: textSize, fontWeight: weight, fontFamily: regular),
  );
}





