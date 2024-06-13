

import 'package:emart_app/consts/firebase_const.dart';

class FireStoreServices {

  static getUser(userId){
    return fireStore.collection(usersCollection).doc(userId).snapshots();
  }

  static getProducts(categories){
    return fireStore.collection(productsCollections).where('p_category',isEqualTo: categories).snapshots();
  }

  static getCart(userId){
    return fireStore.collection(cartCollections).where('added_by',isEqualTo: userId).snapshots();
  }

  static deleteCartDocument(docId){
    return fireStore.collection(cartCollections).doc(docId).delete();
  }

  static getAllChatsMessages(docId){
    return fireStore.collection(chatsCollection).doc(docId).collection(messagesCollections).orderBy('created_on',).snapshots();
  }

  static getAllOrder(userId){
    return fireStore.collection(ordersCollection).where('order_by',isEqualTo: userId).snapshots();
  }

  static getWishList(userId){
    return fireStore.collection(productsCollections).where('p_wishList',arrayContains: userId).snapshots();
  }

  static getAllMessages(){
    return fireStore.collection(chatsCollection).where('fromId',isEqualTo: currentUser!.uid).snapshots();
  }

  static getCounts() async {
    var res = await Future.wait([
      fireStore.collection(cartCollections).where('added_by',isEqualTo: currentUser!.uid).get().then((value){
        return value.docs.length;
      }),
      fireStore.collection(productsCollections).where('p_wishList',arrayContains: currentUser!.uid).get().then((value){
        return value.docs.length;
      }),
      fireStore.collection(ordersCollection).where('order_by',isEqualTo: currentUser!.uid).get().then((value){
        return value.docs.length;
      })
    ]);
    return res ;
  }

  static getAppProducts(){
    return fireStore.collection(productsCollections).snapshots();
  }

  static getFeaturedProducts(){
    return fireStore.collection(productsCollections).where('is_featured',isEqualTo: 'true').snapshots();
  }

  static getSearchProducts(name){
    return fireStore.collection(productsCollections).where('p_name',isGreaterThanOrEqualTo: name).get();
  }

}