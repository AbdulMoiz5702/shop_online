import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:emart_app/services/firse_store_services.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets_common/CustomSized.dart';
import '../chat_screen/chat_screen.dart';


class MyMessagesScreen extends StatelessWidget {
  const MyMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          title: normalText(title: 'My Messages',color: darkFontGrey),
        ),
        body: StreamBuilder(
            stream: FireStoreServices.getAllMessages(),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CupertinoActivityIndicator(),);
              }else if (snapshot.data!.docs.isEmpty){
                return Center(child: largeText(title: 'No Order ',color: darkFontGrey));
              } else if (snapshot.hasData){
                var data = snapshot.data!.docs ;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context,index){
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: ListTile(
                          leading: Icon(Icons.person,color: whiteColor,size: 30,),
                          onTap: (){
                            Get.to(()=> ChatScreen(name: data[index]['friend_name']),transition: Transition.cupertino,arguments: [data[index]['friend_name'],data[index]['toId']]);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          tileColor: lightGrey,
                          contentPadding: EdgeInsets.all(5),
                          title: smallText(title: data[index]['friend_name']),
                          subtitle: smallText(title: data[index]['last_message']),
                        ),
                      );
                    }
                );
              }
              else{
                return Center(child: largeText(title: 'Something went wrong',color: darkFontGrey));
              }
            }
        )
    );
  }
}
