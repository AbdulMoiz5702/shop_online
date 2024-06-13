import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/cart_controller.dart';
import 'package:emart_app/views/Cart/payment_method.dart';
import 'package:emart_app/widgets_common/CustomButtom.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/custom_text_feild.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    var key = GlobalKey<FormState>();
    return Scaffold(
      bottomNavigationBar: CustomButton(onTap: (){
        if(key.currentState!.validate()){
          Get.to(()=>PaymentMethod(),transition: Transition.cupertino);

        }else{
          VxToast.show(context, msg: "All fields are required");
        }
      }, title: "Continue"),
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: normalText(title: 'Shipping Info',color: darkFontGrey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              children: [
                CustomSized(),
                CustomTextField(title: 'Address', hintText: 'Address', controller: controller.addressController),
                CustomSized(),
                CustomTextField(title: 'City', hintText: "City", controller: controller.cityController),
                CustomSized(),
                CustomTextField(title: 'State', hintText: "State", controller: controller.stateController),
                CustomSized(),
                CustomTextField(title: 'Postal Code', hintText: 'Postal Code', controller: controller.postalCodeController),
                CustomSized(),
                CustomTextField(title: 'Phone No', hintText: "Phone No", controller: controller.phoneNumberController),
                CustomSized(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
