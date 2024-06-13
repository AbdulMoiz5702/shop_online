import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/cart_controller.dart';
import 'package:emart_app/views/home_screen/home.dart';
import 'package:emart_app/widgets_common/CustomButtom.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';



class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: normalText(title: 'Payment Methods',color: darkFontGrey),
      ),
      body: Column(
        children: List.generate(paymentMethodList.length, (index){
          return Obx(
              ()=> InkWell(
              onTap: (){
                controller.selectShippingMethod(index);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.all(5),
                height: MediaQuery.sizeOf(context).height * 0.2,
                width: MediaQuery.sizeOf(context).width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: AssetImage(paymentMethodList[index]),fit: BoxFit.cover),
                ),
                child:controller.selectedIndex.value == index ? Icon(Icons.check_circle,color: whiteColor,size: 50,) : null,
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: Obx(
          ()=> controller.isLoading.value == true ? const CupertinoActivityIndicator() :CustomButton(onTap: () async {
            if(controller.selectedIndex.value == 1){
              controller.isLoading.value == true;
              // ignore: use_build_context_synchronously
              await  controller.initPaymentSheet(amount: controller.total.toString(),context: context);
              await Stripe.instance.presentPaymentSheet();
              await controller.placeOrder( controller.total.value.toString(),'Paid','Stripe');
              await  controller.cartClear();
              controller.isLoading.value == false;
              Get.offAll(()=> Home());

            }else{
              controller.isLoading.value == true;
              await controller.placeOrder( controller.total.value.toString(),'Un-Paid ( Pending )','Cash On Delivery');
              await controller.cartClear();
              Get.offAll(()=> Home());
              controller.isLoading.value == false;
            }
        }, title: 'Confirm'),
      ),
    );
  }
}
