import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/home_controller.dart';
import 'package:emart_app/views/Cart/cart_screen.dart';
import 'package:emart_app/views/Profile/profile_screen.dart';
import 'package:emart_app/views/categories/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'home_screen.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());
    var navigationBar = [
      BottomNavigationBarItem(icon: Icon(Icons.home_filled),label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.category_rounded),label: 'Categories'),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: 'Cart'),
      BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile'),
    ];
    var screens = [
      HomeScreen(),
      CategoriesScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
    return WillPopScope(
      onWillPop: ()async {
        return false ;
      },
      child: Scaffold(
        body: Obx(()=> screens.elementAt(homeController.currentIndex.value)),
        bottomNavigationBar: Obx(
            ()=> BottomNavigationBar(
              onTap: (index){
                homeController.currentIndex.value = index;
              },
            currentIndex: homeController.currentIndex.value,
            selectedItemColor: redColor,
            unselectedItemColor: darkFontGrey,
              selectedLabelStyle: TextStyle(color: redColor),
            unselectedIconTheme: IconThemeData(color: darkFontGrey),
            selectedIconTheme: IconThemeData(color: redColor),
            unselectedLabelStyle:  TextStyle(color: darkFontGrey),
            backgroundColor: whiteColor,
              type: BottomNavigationBarType.fixed,
              items: navigationBar),
        ),
      ),
    );
  }
}

