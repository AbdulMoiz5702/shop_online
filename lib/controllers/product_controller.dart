


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:emart_app/models/category_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {

  var subCat = [];

  var quantity = 0.obs;

  var totalPrice = 0.obs;

  var colorIndex = 0.obs ;

  var isLoading = false.obs;

  var isFavorite = false.obs;


  getSubCategories({required String title }) async{
    subCat.clear();
    var data = await rootBundle.loadString('lib/services/category_model.json');
    var decode = categoryModelFromJson(data);
    var s = decode.categories.where((element) => element.name == title).toList();
    for(var e in s[0].subcategories){
      subCat.add(e);
    }
  }

  changeColorIndex(index){
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity){
    if(quantity.value < totalQuantity){
      quantity.value ++;
    }

  }

  decreaseQuantity(){
    if(quantity.value > 0){
      quantity.value -- ;
    }
  }

  totalPriceCalculate(price){
    totalPrice.value = price * quantity.value;
  }

  addToCart({
    required String title ,
    required String imageLink,
    required String sellerName,
    required String color,
    required String quantity,
    required String totalPrice,
    required BuildContext context,
    required String vendorId
}) async {
    try{
      isLoading(true);
      await fireStore.collection(cartCollections).doc().set({
        'title':title,
        'image':imageLink,
        'seller_name':sellerName,
        'color':color,
        'quantity':quantity,
        'totalPrice':totalPrice,
        'added_by':currentUser!.uid,
        'vendor_id':vendorId,
      });
      isLoading(false);
      resetvalue();
      VxToast.show(context, msg: 'Added to cart');
    }catch(e){
      isLoading(false);
      VxToast.show(context, msg: e.toString());
    }
}

  resetvalue(){
    totalPrice.value = 0;
    colorIndex.value =0 ;
    quantity.value = 0 ;
  }

  addToWishList(docId) async {
    await fireStore.collection(productsCollections).doc(docId).set({
      'p_wishList':FieldValue.arrayUnion([
        currentUser!.uid,
      ]),
    },SetOptions(merge: true));
    isFavorite(true);
  }

  removeToWishList(docId) async {
    await fireStore.collection(productsCollections).doc(docId).set({
      'p_wishList':FieldValue.arrayRemove([
        currentUser!.uid,
      ]),
    },SetOptions(merge: true));
    isFavorite(false);
  }

  checkIsFav(data)async {
    if(data['p_wishList'].contains(currentUser!.uid)){
      isFavorite(true);
    }else{
      isFavorite(false);
    }
  }

}