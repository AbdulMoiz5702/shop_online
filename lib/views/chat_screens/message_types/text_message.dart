



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/chat_controller.dart';
import '../../../widgets_common/text_widgets.dart';


class TextMessageWidget extends StatelessWidget {
  const TextMessageWidget({required this.controller,required this.isCurrentUser,required this.index,required this.messageData,required this.docId});
  final ChatController controller ;
  final bool isCurrentUser ;
  final int  index ;
  final dynamic messageData ;
  final String docId ;

  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=>  GestureDetector(
        onLongPress: (){
          if(isCurrentUser){
            controller.changeIndex(index);
            controller.isMessageSelected.value = true;
            controller.selectedCMessageDocId.value = messageData.id;
            controller.selectedChatDocId.value = docId;
            controller.messageType.value = 'text';
            controller.editMessageText.value = messageData['message'];
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            boxShadow:  controller.currentIndex.value == index ? controller.isMessageSelected.value ==  true ? [
              BoxShadow(color: darkFontGrey,blurRadius: 5,spreadRadius: 7),
            ]: [] :  [],
            color: isCurrentUser
                ? redColor
                : golden,
            borderRadius: BorderRadius.only(
              topRight: isCurrentUser
                  ? Radius.circular(0)
                  : Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              topLeft: isCurrentUser
                  ? Radius.circular(10)
                  : Radius.circular(0),
            ),
          ),
          margin: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              smallText(
                textSize: 13.0,
                color: whiteColor,
                title: messageData['message'],
              ),
              CustomSized(height: 0.002,width: 0,),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  messageData['isEdit'] == true ? smallText(
                    color: fontGrey,
                    textSize: 8.0,
                    title:'edited'
                  ): CustomSized(height: 0,width:0),
                  messageData['isEdit'] == true ?CustomSized(width: 0.02,height: 0,) : CustomSized(height: 0,width:0),
                  smallText(
                    color: fontGrey,
                    textSize: 8.0,
                    title:
                    _formatTimestamp(messageData['time']),
                  ),
                  CustomSized(width: 0.02,),
                isCurrentUser == true ?  buildMessageIndicator(messageData) : CustomSized(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    var date = timestamp.toDate();
    var formatter = DateFormat('h:mm a'); // 'h' for 12-hour format and 'a' for AM/PM
    return formatter.format(date);
  }
}

Widget buildMessageIndicator(dynamic messageData) {
  if (messageData['isSent'] == true && messageData['isDelivered'] == false) {
    return Icon(Icons.check, size: 12, color: redColor);
  } else if ( messageData['isDelivered'] == true && messageData['status'] == true) {
    return Icon(Icons.done_all_outlined, size: 12, color: redColor);
  } else if (messageData['isDelivered'] == true) {
    return Icon(Icons.done_all_outlined, size: 12, color:redColor );
  }else {
    return Icon(Icons.access_time, size: 8, color: Colors.grey); // Message is pending
  }
}

