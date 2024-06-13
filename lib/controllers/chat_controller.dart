


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:emart_app/controllers/home_controller.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getChatId();
  }

  var chats = fireStore.collection(chatsCollection);

  var friendName = Get.arguments[0];
  var friendId= Get.arguments[1];

  var senderName = Get.find<HomeController>().userName;
  var currentId = currentUser!.uid;

  var messageController = TextEditingController();
  dynamic chatDocId;

  getChatId() async {

    await chats.where('users',isEqualTo: {friendId :null,currentId:null}).limit(1).get().then((QuerySnapshot snapshot){
      if(snapshot.docs.isNotEmpty){
        chatDocId = snapshot.docs.single.id;
      }else{
        chats.add({
          'created_on':null,
          'last_message':'',
          'users':{
            friendId:null,
            currentId:null,
          },
          'toId':'',
          'fromId':'',
          'friend_name':friendName,
          'sender_name':senderName,
        }).then((value){
          chatDocId = value.id;
        });
      }
    });

  }

  sendMessage() async {
    if(messageController.text.trim().isNotEmpty){
      chats.doc(chatDocId).update({
        'created_on':FieldValue.serverTimestamp(),
        'last_message':messageController.text.toString(),
        'toId':friendId,
        'fromId':currentId,
      });
      chats.doc(chatDocId).collection(messagesCollections).doc().set({
        'created_on':FieldValue.serverTimestamp(),
        'message':messageController.text.toString(),
        'uid':currentId,

      });
    }
  }

}