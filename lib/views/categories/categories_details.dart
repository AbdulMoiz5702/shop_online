import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/services/firse_store_services.dart';
import 'package:emart_app/views/categories/item_details.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/bg_widgets.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../consts/images.dart';
import '../../controllers/product_controller.dart';


class CategoriesDetails extends StatelessWidget {
  final String title ;
  const CategoriesDetails({required this.title});

  @override
  Widget build(BuildContext context) {
    var categoryController = Get.put(ProductController());
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: normalText(title: title),
        ),
        body: StreamBuilder(
          stream: FireStoreServices.getProducts(title),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CupertinoActivityIndicator(),);
            }else if (snapshot.hasData){
              var data = snapshot.data!.docs ;
              return Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics:const  BouncingScrollPhysics(),
                    child: Row(
                      children:List.generate(categoryController.subCat.length, (index){
                        return Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: whiteColor
                          ),
                          height: 50,
                          width: 120,
                          child: smallText(title: categoryController.subCat[index].toString(),color: darkFontGrey),
                        );
                      }),
                    ),
                  ),
                  CustomSized(),
                  Expanded(
                    child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 5/7,
                          crossAxisCount: 2,crossAxisSpacing: 5,mainAxisSpacing: 8,
                        ), itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          categoryController.checkIsFav(data[index]);
                          Get.to(()=> ItemDetailsScreen(title: title,data: data[index],),transition: Transition.cupertino);
                        },
                        child: Card(
                          margin: EdgeInsets.only(left: 8),
                          color: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image(image: NetworkImage(data[index]['p_images'][0]),height:MediaQuery.sizeOf(context).height * 0.18,width:MediaQuery.sizeOf(context).width * 0.35 ,fit: BoxFit.cover,),
                                CustomSized(),
                                normalText(title:data[index]['p_name'],color: darkFontGrey),
                                CustomSized(),
                                normalText(title: '${data[index]['p_price']} \$',color: redColor),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  )
                ],
              );
            }else if (snapshot.data!.docs.isEmpty){
              return Center(child: largeText(title: 'No Product Found'),);
            }
            else{
              return Center(child: largeText(title: 'Something went wrong'),);
            }
          },
        ),
      ),
    );
  }
}
