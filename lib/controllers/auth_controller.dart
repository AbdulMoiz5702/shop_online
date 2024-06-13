


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../views/home_screen/home.dart';

class AuthController extends GetxController {

  var isLoading = false.obs;

  Future<UserCredential?> login({required String email ,required String password,required BuildContext context}) async{
    UserCredential ? userCredential ;
    try{
      isLoading(true);
      auth.signInWithEmailAndPassword(email: email, password: password).then((value){
        isLoading(false);
        VxToast.show(context, msg: 'Login successfully');
        Get.offAll(()=> Home(),transition: Transition.cupertino);
      });
    }on FirebaseAuthException catch(e){
      isLoading(false);
      VxToast.show(context, msg: e.toString());
    }
    return userCredential ;
  }

  Future<UserCredential?> signup({required String email ,required String password,required BuildContext context,required String name}) async{
    UserCredential ? userCredential ;
    try{
      isLoading(true);
      auth.createUserWithEmailAndPassword(email: email, password: password).then((value){
        storeUserdata(name, password, email,);
        VxToast.show(context, msg: 'Account Created successfully');
        isLoading(false);
        Get.offAll(()=>const Home());
      });
    }on FirebaseAuthException catch(e){
      isLoading(false);
      VxToast.show(context, msg: e.toString());
    }
    return userCredential ;
  }

  Future<UserCredential?> forgotPassword({required String email ,required BuildContext context}) async{
    UserCredential ? userCredential ;
    try{
      isLoading(true);
      auth.sendPasswordResetEmail(email: email,);
    }on FirebaseAuthException catch(e){
      isLoading(false);
      VxToast.show(context, msg: e.toString());
    }
    return userCredential ;
  }

   Future logout({required BuildContext context}) async{
    try{
      isLoading(true);
     await auth.signOut();
      isLoading= false.obs;
    }on FirebaseAuthException catch(e){
      isLoading(false);
      VxToast.show(context, msg: e.toString());
    }
  }

  // store user data

  storeUserdata(name,password,email) async {
    DocumentReference store =  fireStore.collection(usersCollection).doc(currentUser!.uid);
    await store.set({
      'name':name,
      'password':password,
      'email':email,
      'imageUrl':'none',
      'id':currentUser!.uid,
      'cart_count':'00',
      'wishList_count':'00',
      'order_count':'00',
    });
  }




}