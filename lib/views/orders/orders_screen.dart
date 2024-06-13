import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:emart_app/services/firse_store_services.dart';
import 'package:emart_app/views/orders/order_details_screen.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets_common/CustomSized.dart';


class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: normalText(title: 'My Orders',color: darkFontGrey),
      ),
      body: StreamBuilder(
        stream: FireStoreServices.getAllOrder(currentUser!.uid),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: lightGrey,
                      contentPadding: EdgeInsets.all(5),
                      leading: smallText(title: index + 1,color: darkFontGrey),
                      title: normalText(title: 'Order code :  ${data[index]['order_code']}',color:darkFontGrey ),
                      trailing: IconButton(onPressed: (
                          ){
                       Get.to(()=> OrdersDetailsScreen(data: data[index],));
                      }, icon:const  Icon(Icons.arrow_forward_ios,color: redColor,)),
                      subtitle: smallText(title: '\$ ${data[index]['total_amount']}',color: redColor),
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
