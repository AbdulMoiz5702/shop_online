import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/home_controller.dart';
import 'package:emart_app/services/firse_store_services.dart';
import 'package:emart_app/views/categories/categories_details.dart';
import 'package:emart_app/views/categories/item_details.dart';
import 'package:emart_app/views/home_screen/search_screen.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/featuresproducts.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../widgets_common/featured_categories.dart';
import '../../widgets_common/home_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        title: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            width: MediaQuery.sizeOf(context).width * 1,
            padding: EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: TextFormField(
              onFieldSubmitted: (value){
                if(controller.searchController.text.isNotEmpty){
                  Get.to(()=> SearchScreen(search: controller.searchController.text.toString(),),);
                  controller.searchController.clear();
                }

              },
              controller: controller.searchController,
              decoration:  InputDecoration(
                border: InputBorder.none,
                suffixIcon: IconButton(onPressed: (){
                  if(controller.searchController.text.isNotEmpty){
                    Get.to(()=> SearchScreen(search: controller.searchController.text.toString(),),);controller.searchController.clear();

                  }
                },icon:const Icon(Icons.search,color: darkFontGrey),),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics:const BouncingScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder(stream: FireStoreServices.getAppProducts(), builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CupertinoActivityIndicator(),);
              }else if (snapshot.hasData){
                var data = snapshot.data!.docs;
                return VxSwiper.builder(
                    enlargeCenterPage: true,
                    scrollPhysics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    autoPlayCurve: Curves.easeInOutExpo,
                    autoPlay: true,
                    aspectRatio: 18/9,
                    itemCount: data.length, itemBuilder: (context,index){
                  return Container(
                    margin: EdgeInsets.all(5),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image: NetworkImage(data[index]['p_images'][0]),fit: BoxFit.fill,isAntiAlias: true),
                    ),
                  );
                });
              }else {
                return  Center(child: smallText(title: 'Something went wrong'));
              }
            }),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: normalText(title: 'Featured',color: darkFontGrey),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics:const BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(3, (index){
                  return Column(
                      children: [
                        FeaturedCategories(title: featuredCategoriesList[index],imagePath: featuredCategoriesImages[index],onTap: (){
                          Get.to(()=> CategoriesDetails(title: featuredCategoriesList[index],),transition: Transition.cupertino);
                        },),
                        const CustomSized(),
                        FeaturedCategories(title: featuredCategoriesList2[index],imagePath: featuredCategoriesImages2[index],onTap: (){
                          Get.to(()=> CategoriesDetails(title: featuredCategoriesList2[index],),transition: Transition.cupertino);
                        },),
                      ],
                  );
                })
              ),
            ),
            const CustomSized(),
            Container(
          height: MediaQuery.sizeOf(context).height * 0.285,
          width: MediaQuery.sizeOf(context).width * 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: redColor,
          ),
          child: StreamBuilder(stream: FireStoreServices.getFeaturedProducts(), builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CupertinoActivityIndicator(),);
            }else if (snapshot.data!.docs.isNotEmpty){
              var data = snapshot.data!.docs;
                 return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(data.length, (index) {
                    return InkWell(
                      onTap: (){
                        Get.to(()=> ItemDetailsScreen(title: data[index]['p_subcategory'], data: data[index]),transition: Transition.cupertino);
                      },
                        child: FeaturedProducts(height:0.25,width:0.45,imagePath: data[index]['p_images'][0], title:data[index]['p_name'], price: '${data[index]['p_price']} \$'));
                  }),
                ),
              );
            }else if (snapshot.data!.docs.isEmpty){
              return  Center(child: smallText(title: 'Currently no feature products',color: whiteColor));
            }else {
              return  Center(child: smallText(title: 'Something went wrong',color: whiteColor));
            }
          }),
        ),
            const CustomSized(),
            StreamBuilder(stream: FireStoreServices.getAppProducts(), builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CupertinoActivityIndicator(),);
              }else if (snapshot.hasData){
                var data = snapshot.data!.docs;
                return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.length,
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 5/8,
                      crossAxisCount: 2,crossAxisSpacing: 5,mainAxisSpacing: 8,
                    ), itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      Get.to(()=> ItemDetailsScreen(title: data[index]['p_subcategory'], data: data[index]),transition: Transition.cupertino);
                    },
                    child: Card(
                      margin:const EdgeInsets.only(left: 8),
                      color: whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                             height:MediaQuery.sizeOf(context).height * 0.18,width:MediaQuery.sizeOf(context).width * 0.41,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(image: NetworkImage(data[index]['p_images'][0]),fit: BoxFit.cover,isAntiAlias: true),
                              ),),
                            const CustomSized(),
                            normalText(title: data[index]['p_name'],color: darkFontGrey),
                            const CustomSized(),
                            normalText(title: '${data[index]['p_price']} \$',color: redColor),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              }else {
                return  Center(child: smallText(title: 'Something went wrong'));
              }
            })

          ],
        ),
      ),
    );
  }
}
