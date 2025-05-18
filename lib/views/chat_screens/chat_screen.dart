import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/colors.dart';
import '../../consts/firebase_const.dart';
import 'messages.dart';



class ChatScreen extends StatelessWidget {
  final String userId;
  const ChatScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    String toTitleCase(String text) {
      if (text.isEmpty) return text;
      return text
          .split(' ')
          .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }
    return Scaffold(
      appBar: AppBar(
        leading: AppBar(
          automaticallyImplyLeading: true,
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).width * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomSized(height: 0.005),
                    largeText(
                      title: 'Chats',
                      color: redColor,
                    ),
                    CustomSized(height: 0.005),
                    smallText(
                      title: 'My all chats.',
                      color: redColor,
                    ),
                    CustomSized(height: 0.005),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: StreamBuilder<QuerySnapshot>(
          stream: fireStore
              .collection(chatsCollection)
              .where('user', arrayContains: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: normalText(title: 'No Chats yet',color: redColor,),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  String otherUserId = (data['sender_id'] == userId)
                      ? data['receiver_id']
                      : data['sender_id'];
                  return FutureBuilder<DocumentSnapshot>(
                    future: fireStore.collection(vendorsCollection).doc(otherUserId).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          leading: Icon(Icons.person),
                        );
                      } else if (userSnapshot.hasData) {
                        var userData = userSnapshot.data!;
                        String receiverName = userData['shop_name']; // Assuming 'name' exists
                        String receiverId = userData['id']; // Assuming 'name' exists
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            trailing: Icon(Icons.arrow_forward_ios,color: redColor.withOpacity(0.5),size: 15,),
                            leading: const  Icon(Icons.person,color: redColor,),
                            title: normalText(title: toTitleCase(receiverName),color: redColor),
                            onTap: () {
                              Get.to(()=> MessageScreen(receiverId: receiverId, receiverName: receiverName,userId: userId));
                            },
                          ),
                        );
                      } else {
                        return const ListTile(
                          title: Text('Error loading user'),
                        );
                      }
                    },
                  );
                },
              );
            } else {
              return Center(
                child: normalText(title: 'Please check internet',color: redColor),
              );
            }
          },
        ),
      ),
    );
  }
}

