// ignore_for_file: use_build_context_synchronously

import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/views/auth_screens/login_screen.dart';
import 'package:emart_app/views/home_screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../../consts/colors.dart';
import '../../consts/images.dart';
import '../../consts/strings.dart';
import '../../widgets_common/CustomButtom.dart';
import '../../widgets_common/CustomSized.dart';
import '../../widgets_common/bg_widgets.dart';
import '../../widgets_common/custom_text_feild.dart';
import '../../widgets_common/text_widgets.dart';


class SignupScreen extends StatefulWidget {
   SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isChecked= false ;

  var authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomSized(height: 0.1,),
              Container(
                padding: EdgeInsets.all(5),
                height: 80,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: whiteColor,
                ),
                child: Image.asset(icAppLogo,fit: BoxFit.cover,alignment: Alignment.center,),
              ),
              CustomSized(),
              normalText(title: 'Create account to join eMart'),
              CustomSized(height: 0.05,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(title: 'Name', hintText: 'Name',controller: nameController,),
                        CustomSized(),
                        CustomTextField(title: 'Email', hintText: 'example@gmail.com',controller: emailController,),
                        CustomSized(),
                        CustomTextField(title: 'Password', hintText: 'Password',controller: passwordController,),
                        CustomSized(),
                        CustomTextField(title: 'Confirm Password', hintText: 'Confirm Password',controller:confirmPasswordController ,),
                        CustomSized(),
                        CustomSized(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    activeColor: whiteColor,
                                    checkColor: redColor,
                                    value: isChecked, onChanged: (value){
                                  setState(() {
                                    isChecked = value! ;
                                  });
                                }),
                                smallText(title: 'i am agree to ',color: darkFontGrey),
                                smallText(title: 'Terms and Condictions ',color: redColor),
                              ],
                            ),
                            smallText(title: 'and Privacy and Policies',color: redColor),
                  ],
                  ),
                        CustomSized(),
                         Obx(
                             ()=> authController.isLoading.value == true ? Center(child: CupertinoActivityIndicator(color: redColor,)): CustomButton(onTap: ()async{
                             if(isChecked == true){
                               try{
                                await authController.signup(email: emailController.text.trim(), password: passwordController.text.trim(),name:nameController.text.trim(),context: context);
                               }catch(e){
                                 VxToast.show(context, msg: e.toString());
                               }
                             }else{
                               VxToast.show(context, msg: 'Yous must accepts terms and conduction');
                             }

                           }, title: 'Signup',color: isChecked == true ? redColor : lightGrey,),
                         ),
                        CustomSized(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            smallText(title: 'Already have an account ?  ',color: darkFontGrey),
                            InkWell(
                                onTap: (){
                                  Get.to(()=> LoginScreen(),transition: Transition.cupertino);
                                },
                                child: smallText(title: 'Login ',color: redColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
