import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:emart_app/controllers/cart_controller.dart';
import 'package:emart_app/services/firse_store_services.dart';
import 'package:emart_app/views/Cart/shipping_screen.dart';
import 'package:emart_app/widgets_common/CustomButtom.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cartController = Get.put(CartController());
    return Scaffold(
      body:StreamBuilder<QuerySnapshot>(
        stream: FireStoreServices.getCart(currentUser!.uid),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CupertinoActivityIndicator(),);
          }else if (snapshot.hasData){
            var data = snapshot.data!.docs;
            cartController.calculate(data);
            cartController.productSnapshot = data;
            return  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: ListView.builder(
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
                        title: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                height:70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(image: NetworkImage(data[index]['image']),fit: BoxFit.cover),
                                ),
                              ),
                              CustomSized(),
                              normalText(title: data[index]['title'],color: darkFontGrey,),
                            ],
                          ),
                        ),
                        trailing: IconButton(onPressed: (){
                          FireStoreServices.deleteCartDocument(data[index].id);
                        }, icon: Icon(Icons.delete,color: redColor,)),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              normalText(title: 'Price : ${data[index]['totalPrice']}',color: darkFontGrey,),
                              normalText(title: 'Quantity : ${data[index]['quantity']}',color: darkFontGrey,),
                              Row(
                                children: [
                                  smallText(
                                    title: 'color :  ',
                                    color: darkFontGrey
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(int.parse(data[index]['color'])),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                    }
                )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  height: 40,
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: golden,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      smallText(title: 'Total '),
                      Obx(()=> smallText(title: '\$ ${cartController.total.value} ')),
                    ],
                  ),
                ),
                CustomButton(onTap: (){
                  Get.to(()=>ShippingDetails(),transition: Transition.cupertino);
                }, title: "Proceed to shipping"),
              ],
            );
          }else if (snapshot.data!.docs.isEmpty){
            return Center(
              child: largeText(title: 'Cart is empty'),
            );
          }else{
            return Center(
              child: largeText(title: 'Please check your internet'),
            );
          }

        },
      )
    );
  }
}

//