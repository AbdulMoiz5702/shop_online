import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';



class HomeButton extends StatelessWidget {
  final double height ;
  final double width ;
  final String imagePath ;
  final String title;
  const HomeButton({this.width = 0.4,this.height = 0.15,required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.sizeOf(context).height * height,
        width: MediaQuery.sizeOf(context).width * width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: whiteColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage(imagePath),height:50,width: 50,),
              CustomSized(),
              smallText(title: title,color: darkFontGrey),
            ],
          ),
        ),
      ),
    );
  }
}
