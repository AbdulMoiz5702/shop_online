import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/views/auth_screens/signup_screen.dart';
import 'package:emart_app/views/home_screen/home.dart';
import 'package:emart_app/widgets_common/CustomButtom.dart';
import 'package:emart_app/widgets_common/custom_text_feild.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../consts/colors.dart';
import '../../consts/images.dart';
import '../../widgets_common/CustomSized.dart';
import '../../widgets_common/bg_widgets.dart';



class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              normalText(title: 'Login to Crafted Marketplace'),
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
                        CustomTextField(title: 'Email', hintText: 'example@gmail.com',controller: emailController,),
                        CustomSized(),
                        CustomTextField(title: 'Password', hintText: 'Password',controller: passwordController,),
                        CustomSized(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: smallText(title: 'Forgot Password ?',color: darkFontGrey),
                        ),
                        CustomSized(),
                        Obx(
                              ()=> authController.isLoading.value == true ? Center(child: CupertinoActivityIndicator(color: redColor,)):CustomButton(onTap: ()async{
                            await authController.login(email: emailController.text.trim(), password: passwordController.text.trim(), context: context);
                          }, title: 'Login'),
                        ),
                        CustomSized(),
                        Align(
                          alignment: Alignment.center,
                            child: smallText(title: 'or create a new account',color: darkFontGrey)),
                        CustomSized(),
                        CustomButton(onTap: (){
                          Get.to(()=> SignupScreen(),transition: Transition.cupertino);
                        }, title: 'Signup',color: golden,),
                        CustomSized(),
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
