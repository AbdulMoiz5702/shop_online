


import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:emart_app/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {

  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalCodeController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var total = 0.obs;
  var selectedIndex = 0.obs;
  var isLoading = false.obs ;

   Random code = Random();


   late dynamic productSnapshot ;
   var products = [];
   var vendors = [];

   calculate(data){
     total.value = 0;
     for(var e= 0; e < data.length ; e++){
       total.value = total.value + int.parse(data[e]['totalPrice'].toString());
     }
   }

   selectShippingMethod(index){
     selectedIndex.value=index;
   }

   placeOrder(totalAmount,paymentStatus,paymentMethod) async {
     try{
       isLoading(true);
       await getProductDetails();
       await fireStore.collection(ordersCollection).doc().set({
         'order_by':currentUser!.uid,
         'order_by_name':Get.find<HomeController>().userName,
         'order_by_email':currentUser!.email,
         'order_by_address':addressController.text.toString(),
         'order_by_city':cityController.text.toString(),
         'order_by_state':stateController.text.toString(),
         'order_by_postalCode':postalCodeController.text.toString(),
         'order_by_phoneNumber':phoneNumberController.text.toString(),
         'shipping_method':'Home delivery',
         'paymentMethod':paymentMethod,
         'order_placed':'true',
         'order_payment_status':paymentStatus,
         'total_amount':totalAmount,
         'orders':FieldValue.arrayUnion(products),
         'order_confirm':'false',
         'order_delivered':'false',
         'order_on_delivery':'false',
         'order_code':code.nextInt(10000000),
         'order_date':FieldValue.serverTimestamp(),
         'vendors':FieldValue.arrayUnion(vendors),
       });
       isLoading(false);
     }catch(e){
       isLoading(false);
     }
   }

   getProductDetails(){
     products.clear();
     vendors.clear();
     for(var i = 0 ; i < productSnapshot.length ; i++){
       products.add({
         'color':productSnapshot[i]['color'],
         'image':productSnapshot[i]['image'],
         'vendor_id':productSnapshot[i]['vendor_id'],
         'totalPrice':productSnapshot[i]['totalPrice'],
         'quantity':productSnapshot[i]['quantity'],
         'title':productSnapshot[i]['title'],
       });
       vendors.add(productSnapshot[i]['vendor_id']);
       print(products);
     }
   }

   cartClear() async {
    try{
      isLoading(true);
      for(var i = 0 ; i < productSnapshot.length ; i++){
        await fireStore.collection(cartCollections).doc(productSnapshot[i].id).delete();
      }
      isLoading(false);
    }catch(e){
      isLoading(false);
    }
   }

  Future createPaymentIntent({
    required String amount}) async{
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
    String secretKey="sk_test_51MqVILCEgj2JoMLjvRjE4lzZZYX5ArdEdWMd2wdyOWkv9UxQpvYMCcStcTH0PAT9wNpkNnoPzVy13iry5DApPUj000dh1scO26";
    final body={
      'amount': amount,
      'currency': 'USD',
      'automatic_payment_methods[enabled]': 'true',
      'description': "Test Donation",
      'shipping[name]': Get.find<HomeController>().userName,
      'shipping[address][line1]': addressController.text.toString(),
      'shipping[address][postal_code]': postalCodeController.text.toString(),
      'shipping[address][city]': cityController.text.toString(),
      'shipping[address][state]': stateController.text.toString(),
    };

    final response= await http.post(url,
        headers: {
          "Authorization": "Bearer $secretKey",
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body
    );

    print(body);

    if(response.statusCode==200){
      var json=jsonDecode(response.body.toString());
      print('Stripe Response :${response.body.toString()}');
      print('Stripe Status Code : ${response.statusCode}');
      return json;
    }
    else{
      print("error in calling payment intent");
    }
  }

  Future<void> initPaymentSheet({required String amount,required BuildContext context}) async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
        // convert string to double
          amount: (int.parse(amount) * 100).toString(),);

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],

          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

}