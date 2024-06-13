import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';


class ProfileContainer extends StatelessWidget {
  final String infoTitle ;
  final String title ;
  const ProfileContainer({required this.title,required this.infoTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: MediaQuery.sizeOf(context).width * 0.31,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          normalText(title: infoTitle,color: darkFontGrey),
          CustomSized(
            height: 0.01,
          ),
          smallText(title: title,color: darkFontGrey),
        ],
      ),
    );
  }
}
