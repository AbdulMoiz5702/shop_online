import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:emart_app/controllers/chat_controller.dart';
import 'package:emart_app/services/firse_store_services.dart';
import 'package:emart_app/views/chat_screen/message_bubble.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChatScreen extends StatelessWidget {
  final String name;
  const ChatScreen({required this.name});

  @override
  Widget build(BuildContext context) {
    var chatController = Get.put(ChatController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: normalText(title: name,color: darkFontGrey),
      ),
      body: Column(
        children: [
          Expanded(child: StreamBuilder(
            stream: FireStoreServices.getAllChatsMessages(chatController.chatDocId.toString()),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CupertinoActivityIndicator(),);
              }else if (snapshot.hasData ){
                return ListView(
                  reverse: false,
                  children: snapshot.data!.docs.mapIndexed((currentValue, index){
                    var data = snapshot.data!.docs[index];
                    return Align(
                      alignment: data['uid'] == currentUser!.uid ?  Alignment.centerRight : Alignment.centerLeft,
                        child: MessageBubble(data: data,));
                  }).toList(),
                );
              }else if (!snapshot.hasData ){
                return Center(child: largeText(title: 'No messages',color: darkFontGrey),) ;
              }else{
                return Center(child: largeText(title: 'Something went wrong ',color: darkFontGrey),) ;
              }

            },
          )),
          Container(
            padding: EdgeInsets.all(12),
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: TextFormField(
                  controller: chatController.messageController,
                  decoration: InputDecoration(
                    hintText: 'message...',
                    hintStyle: TextStyle(color: darkFontGrey)
                  ),
                )),
                IconButton(onPressed: (){
                  chatController.sendMessage();
                  chatController.messageController.clear();
                }, icon: Icon(Icons.send_rounded,color: redColor,))
              ],
            ),
          )
        ],
      ),
    );
  }
}
