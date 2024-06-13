import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:emart_app/views/auth_screens/login_screen.dart';
import 'package:emart_app/views/home_screen/home.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void navigateUser(){
    Future.delayed(Duration(seconds: 3),(){
      auth.authStateChanges().listen((User? user) {
        if(user != null && mounted){
          Get.to(()=> Home() ,transition: Transition.cupertino);
        }else{
          Get.to(()=> LoginScreen() ,transition: Transition.cupertino);
        }
      });

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSized(height: 0.35,),
            Container(
              padding: EdgeInsets.all(5),
              height: 100,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: whiteColor,
              ),
              child: Image.asset(icAppLogo,fit: BoxFit.cover,alignment: Alignment.center,),
            ),
            CustomSized(),
            normalText(title: appname),
            CustomSized(),
            smallText(title: appversion),
            Spacer(),
            smallText(title: credits),
            CustomSized(),
          ],
        ),
      ),
    );
  }
}
