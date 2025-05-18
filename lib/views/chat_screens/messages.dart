import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/colors.dart';
import '../../consts/firebase_const.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/home_controller.dart';
import '../../widgets_common/text_widgets.dart';
import 'message_inputs.dart';
import 'message_types/text_message.dart';


class MessageScreen extends StatefulWidget {
  const MessageScreen(
      {required this.receiverId,
      required this.receiverName,
        required this.userId
      });
  final String receiverId;
  final String receiverName;
  final String userId ;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with WidgetsBindingObserver {

  var controller = Get.put(ChatController());
  var homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    String combinedId1 = '${widget.userId}_${widget.receiverId}';
    String combinedId2 = '${widget.receiverId}_${widget.userId}';
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Container(
          color: fontGrey,
          child: StreamBuilder<QuerySnapshot>(
            stream: fireStore.collection(chatsCollection)
                .where('combine_id', whereIn: [combinedId1,combinedId2])
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data!.docs.isEmpty) {
                return _buildInitialMessageInput(controller: controller, context: context, receiverId: widget.receiverId, userId: widget.userId, userName: homeController.userName);
              } else {
                var doc = snapshot.data!.docs.first;
                var docId = doc.id;
                return StreamBuilder<QuerySnapshot>(
                  stream: fireStore
                      .collection(chatsCollection)
                      .doc(docId)
                      .collection(messagesCollections)
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, messageSnapshot) {
                    if (messageSnapshot.hasData) {
                      var messages = messageSnapshot.data!.docs;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              cacheExtent: 0,
                              addRepaintBoundaries: true,
                              reverse: true,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                var messageData = messages[index];
                                bool isCurrentUser = messageData['sender_id'] == widget.userId;
                                // Call function to mark messages as delivered when the user views them
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  controller.markMessageAsDelivered(docId, widget.userId);
                                });
                                // Check if the message is from another user and the status is not yet marked as read
                                if (!isCurrentUser && messageData['status'] == false) {
                                  controller.markMessageAsRead(docId, messageData.id);
                                }
                                return Align(
                                    alignment: isCurrentUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: TextMessageWidget(controller: controller, isCurrentUser: isCurrentUser, index: index, messageData: messageData, docId: docId));
                              },
                            ),
                          ),
                          CustomSized(height: 0.010,),
                          buildMessageInput(controller: controller, context: context, docId: docId, receiverId: widget.receiverId, userId:widget.userId, userName: homeController.userName),
                        ],
                      );
                    } else {
                      return Center(child: largeText(title: ''));
                    }
                  },
                );
              }
            },
          ),
        )
    );
  }

  Widget _buildInitialMessageInput({
    required ChatController controller,
    required BuildContext context,
    required String receiverId,
    required String userId,
    required String userName}) {
    return SingleChildScrollView(
      physics:const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(child: largeText(title: 'Start a conversation')),
          CustomSized(
            height: 0.4,
          ),
          buildFirstMessageMessageInput(controller: controller, context: context,receiverId: receiverId, userId: userId, userName: userName)
        ],
      ),
    );
  }

}








