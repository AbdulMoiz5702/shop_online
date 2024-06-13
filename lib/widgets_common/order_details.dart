import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';




class OrderDetails extends StatelessWidget {
  final String title ;
  final IconData icon ;
  final IconData ? lastIcon ;
  final Color color ;
  const OrderDetails({required this.title,required this.color,required this.icon,required this.lastIcon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,color: color,),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          smallText(title: title,color: redColor,),
          CustomSized(),
          Icon(lastIcon,color: color,),
        ],
      ),
    );
  }
}
