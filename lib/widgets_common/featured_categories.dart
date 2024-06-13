import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';


class FeaturedCategories extends StatelessWidget {
  final String imagePath;
  final String title ;
  final VoidCallback onTap ;
  const FeaturedCategories({required this.imagePath,required this.title,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left:15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: whiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage(imagePath),height: 40,fit: BoxFit.cover,),
            CustomSized(),
            smallText(title: title,color: darkFontGrey),
            CustomSized(),
          ],
        ),
      ),
    );
  }
}
