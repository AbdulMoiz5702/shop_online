import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final String title ;
  final VoidCallback onTap;
  final double height ;
  final double width ;
  final Color color ;
  const CustomButton({required this.onTap,required this.title,required ,this.height = 0.05,this.width = 0.8,this.color = redColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.sizeOf(context).height * height,
          width: MediaQuery.sizeOf(context).width * width,
          child: normalText(title: title),
        ),
      ),
    );
  }
}
