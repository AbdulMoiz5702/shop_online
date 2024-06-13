import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';



class CustomTextField extends StatelessWidget {
  final String title;
  final String hintText ;
  final TextEditingController controller ;
   CustomTextField({required this.title,required this.hintText,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        smallText(title: title,color: redColor,textSize: 16.0),
        CustomSized(height: 0.01,),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: lightGrey,
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: semibold,
              color:textfieldGrey,
            ),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: redColor),
            )
          ),
        ),
      ],
    );
  }
}
