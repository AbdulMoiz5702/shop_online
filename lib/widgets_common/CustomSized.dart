import 'package:flutter/material.dart';



class CustomSized extends StatelessWidget {
  final double height;
  final double width ;
  const CustomSized({this.height = 0.02 ,this.width = 0.02});

  @override
  Widget build(BuildContext context) {
    double height1 = MediaQuery.sizeOf(context).height * height;
    double width1 = MediaQuery.sizeOf(context).width * width;
    return SizedBox(
      height: height1,
      width: width1,
    );
  }
}
