import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';


class FeaturedProducts extends StatelessWidget {
  final String imagePath ;
  final String title ;
  final String price;
  final double  height;
  final double  width;
  const FeaturedProducts({required this.imagePath,required this.title,required this.price,this.height =0.21,this.width = 0.4 });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 8),
      color: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.sizeOf(context).height * height,
        width: MediaQuery.sizeOf(context).width * width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSized(),
            Container(
                height:MediaQuery.sizeOf(context).height * 0.13,width:MediaQuery.sizeOf(context).width * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: NetworkImage(imagePath),fit: BoxFit.cover,isAntiAlias: true),
              ),),
            CustomSized(height: 0.01,),
            normalText(title: title,color: darkFontGrey),
            smallText(title: price,color: darkFontGrey)
          ],
        ),
      ),
    );
  }
}


