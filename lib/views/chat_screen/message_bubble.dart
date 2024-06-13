import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../consts/firebase_const.dart';

class MessageBubble extends StatelessWidget {
  final DocumentSnapshot data;
  const MessageBubble({required this.data});

  @override
  Widget build(BuildContext context) {
    var t = data['created_on'] == null
        ? DateTime.now()
        : data['created_on'].toDate();
    var time = intl.DateFormat("h:mma").format(t);
    return Directionality(
      textDirection: data['uid'] == currentUser!.uid ?TextDirection.rtl:TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(top: 10,left: 5,right: 5),
        height: 60,
        decoration: BoxDecoration(
          color: data['uid'] == currentUser!.uid ?  redColor  : darkFontGrey,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft:  data['uid'] == currentUser!.uid ?  Radius.circular(0) :Radius.circular(10),
            bottomRight: data['uid'] == currentUser!.uid ?  Radius.circular(10) :Radius.circular(0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            normalText(title: data['message'], color: whiteColor),
            CustomSized(
              height: 0.01,
            ),
            smallText(title: time, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
