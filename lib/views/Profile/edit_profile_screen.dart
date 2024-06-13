import 'dart:io';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/profile_controller.dart';
import 'package:emart_app/widgets_common/CustomButtom.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/bg_widgets.dart';
import 'package:emart_app/widgets_common/custom_text_feild.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/images.dart';



class EditProfileScreen extends StatelessWidget {
  final String password;
  final String email;
  final String imageUrl ;
  const EditProfileScreen({required this.email,required this.password,required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    var editProfileController = Get.put(ProfileController());
    editProfileController.emailController.text = email;
    editProfileController.oldpasswordController.text ;
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            margin: EdgeInsets.only(left: 5,right: 5,top: 100),
            color: whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Obx(
                  ()=> Column(
                    children: [
                     imageUrl != 'none' ? Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: NetworkImage(imageUrl),fit: BoxFit.cover),
                        ),
                      ): editProfileController.profileImagePath.value != ''? Container(
                        clipBehavior: Clip.antiAlias,
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image(image: FileImage(File(editProfileController.profileImagePath.value)),fit: BoxFit.cover,))  :Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage(imgProfile),fit: BoxFit.cover),
                          ),
                        ),
                      CustomButton(onTap: ()async{
                        await editProfileController.changeImage(context);
                      }, title: 'Pick Image'),
                      CustomSized(),
                      CustomTextField(title: 'Email', hintText: 'exapmle@gmail.com', controller: editProfileController.emailController),
                      CustomSized(),
                      CustomTextField(title: 'Old Password', hintText:'Old Password', controller: editProfileController.oldpasswordController),
                      CustomSized(),
                      CustomTextField(title: 'New Password', hintText:'New Password', controller: editProfileController.newPasswordController),
                      CustomSized(),
                      Obx(
                          ()=> editProfileController.isLoading.value == true ? const  CupertinoActivityIndicator():CustomButton(onTap: () async {
                            editProfileController.isLoading.value == true;
                         await editProfileController.uploadProfileImage();
                         if(password == editProfileController.oldpasswordController.text){
                           await editProfileController.changeAuthPassword(email: email, password: editProfileController.oldpasswordController.text, newPassword: editProfileController.newPasswordController.text.trim());
                           await editProfileController.updateProfile(
                               imageUrl: editProfileController.profileImageLink.value == '' ? imageUrl : editProfileController.profileImageLink.value,
                               email: email,
                               password: password == editProfileController.oldpasswordController.text ? editProfileController.newPasswordController.text:password,
                               context: context
                           );
                           VxToast.show(context, msg: "Updated");
                         }else{
                           editProfileController.isLoading.value == false;
                           VxToast.show(context, msg: "Error");
                         }
                        }, title: 'Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
