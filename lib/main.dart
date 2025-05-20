import 'package:emart_app/views/splash_screen/splash_sreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'consts/consts.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey= 'pk_test_51MqVILCEgj2JoMLjZnb2u8ibbdnwBnsJNpZ6wbjziAs1eitcwNnOqkYHRUErziqKO1m3oHG9yKEIVaIcFA6M1V8S00Z9ZOjwwX';
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appname,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: darkFontGrey
            )
          )
        ),
        home: SplashScreen(),
      ),
    );
  }
}
