import 'dart:io';

import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';



class ProfileController extends GetxController {

  var profileImagePath = ''.obs;
  var profileImageLink = ''.obs;
  var emailController = TextEditingController();
  var oldpasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var isLoading = false.obs ;

  changeImage(context) async {
    try{
      final image= await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image== null){
        return null;
      }else{
        profileImagePath.value = image.path.toString();
      }
    } on PlatformException catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async{
    try {
      isLoading(true);
      var imageFile = basename(profileImagePath.value.toString());
      var destination = 'images/${currentUser!.uid}/$imageFile';
      Reference ref =  FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(File(profileImagePath.value));
      profileImageLink.value = await ref.getDownloadURL().then((value){
        isLoading(false);
        return ref.getDownloadURL();
      });
    }catch(e){
      isLoading(false);
    }
  }


  updateProfile({required String imageUrl,required String email,required String password,required BuildContext context}) async{
   try{
     isLoading(true);
     var store = fireStore.collection(usersCollection).doc(currentUser!.uid);
     await store.update({
       'email':email,
       'password':password,
       'imageUrl': imageUrl,
     }).then((value){
       isLoading(false);
       Navigator.pop(context);
     });
   }catch(e){
     isLoading(false);
   }
  }

  changeAuthPassword({required String email,required String password,required String newPassword}) async {
    try{
      final cred = EmailAuthProvider.credential(email: email, password: password);
      await currentUser!.reauthenticateWithCredential(cred).then((value){
        currentUser!.updatePassword(newPassword);
      });
    }catch(e){
      final cred = EmailAuthProvider.credential(email: email, password: password);
      await currentUser!.reauthenticateWithCredential(cred).then((value){
        currentUser!.updatePassword(newPassword);
      });
    }
  }

}