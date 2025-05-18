import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../consts/colors.dart';
import '../../controllers/chat_controller.dart';


Widget buildMessageInput(
    {
    required ChatController controller,
    required BuildContext context,
    required String docId,
    required String receiverId,
    required String userId,
    required String userName}) {
  return Container(
     color: redColor,
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: whiteColor)),
      margin: EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 5),
      child: Row(
        children: [
          Obx(
            () => controller.isRecording.value == true
                ? CustomSized()
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2,),
                      child: TextFormField(
                        style: TextStyle(color: darkFontGrey,fontSize: 12,fontWeight: FontWeight.w500),
                        cursorColor: whiteColor.withOpacity(0.8),
                        controller: controller.message,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '  Type a message...',
                          hintStyle: TextStyle(color: redColor.withOpacity(0.5),fontSize: 12,fontWeight: FontWeight.w500)
                        ),
                      ),
                    ),
                  ),
          ),
          Obx(
            () => controller.isRecording.value == true
                ? CustomSized()
                : InkWell(
                    onTap: () async {
                      controller.sendMessage(
                              receiverId: receiverId,
                              senderId: userId,
                              context: context,
                              receiverToken: '',
                              docId: docId.toString());
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child:Icon(Icons.send,color: whiteColor,),
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}


Widget buildFirstMessageMessageInput(
    {
      required ChatController controller,
      required BuildContext context,
      required String receiverId,
      required String userId,
      required String userName}) {
  return Container(
    color: golden,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: whiteColor)),
      margin: EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 5),
      child: Row(
        children: [
          Obx(
                ()=>  controller.isRecording.value == true ? CustomSized(): Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: TextFormField(
                  style: TextStyle(color: darkFontGrey,fontSize: 12,fontWeight: FontWeight.w500),
                  cursorColor: whiteColor.withOpacity(0.8),
                  controller: controller.message,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Type a message...', hintStyle: TextStyle(color: redColor.withOpacity(0.5),fontSize: 12,fontWeight: FontWeight.w500)
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {controller.sendFirstMessage(
                receiverId: receiverId,
                senderId: userId,
                context: context,
                receiverToken: '');
            },
            child: Container(
              height: 32,
              width: 32,
              margin: EdgeInsets.symmetric(horizontal:5),
              alignment: Alignment.center,
              child: Icon(Icons.send),
            ),
          )
        ],
      ),
    ),
  );
}
