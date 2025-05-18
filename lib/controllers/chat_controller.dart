import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../consts/firebase_const.dart';
import '../widgets_common/toast_class.dart';



class ChatController extends GetxController {

  var docId = ''.obs;
  var isRecording = false.obs;
  var durationInSeconds = 0.obs;
  final ImagePicker picker = ImagePicker();
  var durationDuringRecording = 0.obs;
  var isLoading = false.obs;
  var selectedChatDocId = ''.obs;
  var selectedCMessageDocId = ''.obs;
  var isMessageSelected = false.obs;
  var messageType = 'text'.obs;
  var currentIndex = (-1).obs;
  var hasMessage = false.obs;

  changeIndex(index) {
    currentIndex.value = index;
  }

  resetIndex() {
    currentIndex.value = -1;
  }


  var isEdit = false.obs;
  var editMessageText = ''.obs;
  late TextEditingController message;

  @override
  void dispose() {
    super.dispose();
    message.dispose();
  }


  @override
  void onInit() {
    super.onInit();
    message = TextEditingController();
    isEdit.listen((isEditing) {
      if (isEditing) {
        message.text = editMessageText.value;
      }
    });
  }

  void changeEditTextValue() {
    if (isEdit.value) {
      message.text = editMessageText.value;
    }
  }

  sendMessage({
    required String receiverId,
    required String senderId,
    required String docId,
    required BuildContext context,
    required String receiverToken,
  }) async {
    try {
      if (message.text.isEmpty) {
        ToastClass.showToastClass(context: context, message: 'Message must not be empty');
      } else {
        var messageData = fireStore.collection(chatsCollection).doc(docId).collection(messagesCollections).doc();
        await messageData.set({
          'message': message.text,
          'receiver_id': receiverId,
          'sender_id': senderId,
          'receiver_token':receiverToken,
          'time': FieldValue.serverTimestamp(),
          'message_type': 'text',
          'status':false,
          'isEdit':false,
          'isSent':false,
          "isDelivered": false
        }).then((value) async {
          message.clear();
          var data = fireStore.collection(chatsCollection).doc(docId);
          await data.update({
            'last_message': message.text,
            'time': FieldValue.serverTimestamp(),
          });
        }).then((value) async{
          await messageData.set({
            'isSent': true,
          }, SetOptions(merge: true));
        });
      }
    } catch (e) {
      print(e);
    }
  }





  sendFirstMessage({required String receiverId,required String senderId,required BuildContext context,required String receiverToken}) async {
    try{
      if(message.text.isEmpty){
        ToastClass.showToastClass(context: context, message: 'Message must not be empty');
      }else{
        var data = fireStore.collection(chatsCollection).doc();
        await data.set({
          'combine_id':'${senderId}_$receiverId',
          'last_message':message.text,
          'receiver_id':receiverId,
          'sender_id':senderId,
          'receiver_token':receiverToken,
          'user':FieldValue.arrayUnion([receiverId, senderId,]),
          'time':FieldValue.serverTimestamp(),
        }).then((value) async {
          docId.value = data.id;
          var messageData = fireStore.collection(chatsCollection).doc(data.id).collection(messagesCollections).doc();
          await messageData.set({
            'message':message.text,
            'receiver_id':receiverId,
            'sender_id':senderId,
            'receiver_token':receiverToken,
            'time':FieldValue.serverTimestamp(),
            'message_type': 'text',
            'status':false,
            'isEdit':false,
            'isSent':false,
            "isDelivered": false
          });
          message.clear();
        });
      }
    }catch(e){
      print(e);
    }
  }

  void markMessageAsRead(String docId, String messageId) async {
    try {
      await fireStore.collection(chatsCollection).doc(docId).collection(messagesCollections).doc(messageId).update({'status': true});
    } catch (e) {
      print("Error updating message status: $e");
    }
  }

  void markMessageAsDelivered(String docId,userId) async {
    var messages = await fireStore.collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollections)
        .where('isDelivered', isEqualTo: false)
        .where('receiver_id', isEqualTo: userId)
        .get();
    for (var message in messages.docs) {
      await fireStore.collection(chatsCollection)
          .doc(docId)
          .collection(messagesCollections)
          .doc(message.id)
          .update({'isDelivered': true});
    }
  }

}









