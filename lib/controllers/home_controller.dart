import 'package:emart_app/consts/firebase_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeController extends GetxController {


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserName();
  }
  var currentIndex = 0.obs;
  var userName = '';

  var searchController = TextEditingController();

  getUserName() async {
    var name = await fireStore.collection(usersCollection).where('id',isEqualTo: currentUser!.uid).get().then((value){
      if(value.docs.isNotEmpty){
        return value.docs.single['name'];
      }
    });
    userName = name ;
    print(userName.toString());
  }


}