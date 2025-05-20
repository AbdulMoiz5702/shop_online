import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets_common/order_details.dart';


class OrdersDetailsScreen extends StatelessWidget {
  final dynamic  data;
  const OrdersDetailsScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    // Parse the date string to a DateTime object

    DateTime date = data['order_date'].toDate();
    DateTime parsedDate = DateTime.parse(date.toString());
    // Format the date to the desired format
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return  Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CustomSized(
              height: 0.13,
            ),
            OrderDetails(icon: Icons.check_box,color: Colors.red,title:'Order Placed',lastIcon:data['order_placed'] == 'true' ? Icons.check :Icons.check_box_outline_blank ,),
            CustomSized(),
            OrderDetails(icon: Icons.thumb_up_outlined,color: Colors.blue,title:'Order Confirmed',lastIcon:data['order_confirm'] == 'true' ? Icons.check :null,),
            CustomSized(),
            OrderDetails(icon: Icons.local_shipping_outlined,color: Colors.yellow,title:'On Delivery',lastIcon:data['order_on_delivery'] == 'true' ? Icons.check :null,),
            CustomSized(),
            OrderDetails(icon: Icons.handshake_outlined,color: Colors.deepOrange,title:'Delivered',lastIcon:data['order_delivered'] == 'true' ? Icons.check :null,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      smallText(title: 'Order Code ',color: darkFontGrey),
                      smallText(title: data['order_code'],color: redColor),
                    ],
                  ),
                  Column(
                    children: [
                      smallText(title: 'Shipping Method ',color: darkFontGrey),
                      smallText(title: data['shipping_method'],color: redColor),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallText(title: 'Order Date ',color: darkFontGrey),
                      smallText(title: formattedDate,color: redColor),
                    ],
                  ),
                  Column(
                    children: [
                      smallText(title: 'Payment Method ',color: darkFontGrey),
                      smallText(title: data['paymentMethod'],color: redColor),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  smallText(title: 'Total Price ',color: darkFontGrey),
                  normalText(title: '\$ ${data['total_amount']}',color: redColor)
                ],
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    normalText(title: 'Shipping Address',color: darkFontGrey),
                    smallText(title: data['order_by_address'],color: darkFontGrey),
                    smallText(title: data['order_by_phoneNumber'],color: darkFontGrey),
                    smallText(title: data['order_by_city'],color: darkFontGrey),
                    smallText(title: data['order_by_address'],color: darkFontGrey),
                    smallText(title: data['order_by_state'],color: darkFontGrey),
                    smallText(title: data['order_by_email'],color: darkFontGrey),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data['orders'].length,
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
                                image: DecorationImage(image: NetworkImage(data['orders'][index]['image']),fit: BoxFit.cover),
                              ),
                            ),
                            CustomSized(),
                             normalText(title: data['orders'][index]['title'],color: darkFontGrey,),
                          ],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                           normalText(title: 'Quantity : ${data['orders'][index]['quantity']}',color: darkFontGrey,),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
