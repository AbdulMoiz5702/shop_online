import 'package:emart_app/consts/consts.dart';
import 'package:flutter/material.dart';


class BgWidget extends StatelessWidget {
  final Widget ? child ;
  BgWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(imgBackground),fit: BoxFit.fill),
        ),
        child: child,
    );
  }
}
