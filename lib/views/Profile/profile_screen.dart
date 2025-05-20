import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/views/auth_screens/login_screen.dart';
import 'package:emart_app/views/chat_screens/chat_screen.dart';
import 'package:emart_app/views/wishList/wiskList_screen.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/bg_widgets.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/firse_store_services.dart';
import '../../widgets_common/profile_shopping_info.dart';
import '../orders/orders_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> profileList = [
      'My Orders',
      'MY Wishlist',
      'My Messages',
    ];

    List<IconData> profileListIcon = [
     Icons.shopping_cart_rounded,
      Icons.favorite,
      Icons.messenger,
    ];

    var authController = Get.put(AuthController());
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder<DocumentSnapshot>(
          stream: FireStoreServices.getUser(currentUser!.uid),
          builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CupertinoActivityIndicator(color: redColor,),);
            }else if (snapshot.hasError){
              return Center(child: largeText(title: 'Something went wrong'),);
            }else if (snapshot.hasData && snapshot.data != null){
              var data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
              return SafeArea(child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                           data['imageUrl'] != 'none' ? Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: NetworkImage(data['imageUrl']),fit: BoxFit.cover),
                          ),
                          ): Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: AssetImage(imgProfile),fit: BoxFit.cover),
                                ),
                              ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                normalText(title: data['name'] ?? 'N/A'),
                                smallText(title: data['email'] ?? 'N/A'),
                                CustomSized(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(onPressed: (){
                                      Get.to(()=> EditProfileScreen(
                                        imageUrl: data['imageUrl'], email: data['email'],password: data['password'],
                                      ),transition: Transition.cupertino);
                                    }, icon: Icon(Icons.edit,color: whiteColor,)),
                                    InkWell(
                                      onTap: ()async{
                                        await authController.logout(context: context).then((value){
                                          VxToast.show(context, msg: 'Logout successfully');
                                          Get.offAll(()=> LoginScreen(),transition: Transition.cupertino);
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: whiteColor)
                                        ),
                                        child: smallText(color: whiteColor,title: 'Logout'),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                 FutureBuilder(future: FireStoreServices.getCounts(), builder: (context,AsyncSnapshot snapshot){
                   if(snapshot.connectionState == ConnectionState.waiting){
                     return Center(child: CupertinoActivityIndicator(),);
                   }
                  else if(snapshot.hasData){
                     var countData = snapshot.data ;
                     return  Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         ProfileContainer(infoTitle: countData[0].toString(),title: 'in your cart',),
                         ProfileContainer(infoTitle: countData[1].toString(),title: 'in your wishlist',),
                         ProfileContainer(infoTitle: countData[2].toString(),title: 'you ordered',),
                       ],
                     );
                   }else{
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProfileContainer(infoTitle: '--/--/--',title: 'in your cart',),
                        ProfileContainer(infoTitle: '--/--/--',title: 'in your wishlist',),
                        ProfileContainer(infoTitle: '--/--/--',title: 'you ordered',),
                      ],
                    );
                   }
                 }),
                  CustomSized(),
                  Card(
                    color: whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context,index){
                          return ListTile(
                            onTap: (){
                              switch(index){
                                case(0):
                                  Get.to(()=> OrderScreen(),transition: Transition.cupertino);
                                  break;
                                case(1):
                                  Get.to(()=> WishList(),transition: Transition.cupertino);
                                  break;
                                case(2):
                                  Get.to(()=> ChatScreen(userId: currentUser!.uid),transition: Transition.cupertino);
                                  break;
                              }
                            },
                            dense: true,
                            leading: Icon(profileListIcon[index],color: darkFontGrey,),
                            title: normalText(title: profileList[index],color: darkFontGrey),
                            trailing: Icon(Icons.arrow_forward_ios),
                          );
                        }, separatorBuilder: (context,index){
                      return Divider(color: darkFontGrey,);
                    }, itemCount: profileList.length),
                  )
                ],
              ));
            }else{
              return  Center(child: largeText(title: 'Check your internet connection'),);
            }
          },
        ),
      ),
    );
  }
}