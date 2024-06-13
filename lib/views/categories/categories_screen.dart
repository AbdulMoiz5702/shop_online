import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/product_controller.dart';
import 'package:emart_app/views/categories/categories_details.dart';
import 'package:emart_app/widgets_common/bg_widgets.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../consts/colors.dart';
import '../../consts/images.dart';
import '../../consts/strings.dart';
import '../../widgets_common/CustomSized.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var categoryController = Get.put(ProductController());
    return BgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3/5,
              crossAxisCount: 3,crossAxisSpacing: 2,mainAxisSpacing: 8,
            ), itemBuilder: (context,index){
          return InkWell(
            onTap: (){
              categoryController.getSubCategories(title: categoriesList[index]);
              Get.to(()=> CategoriesDetails(title: categoriesList[index]),transition: Transition.cupertino);
            },
            child: Card(
              color: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: EdgeInsets.all(5),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(image: AssetImage(categoriesListImages[index]),height:MediaQuery.sizeOf(context).height * 0.15,width:MediaQuery.sizeOf(context).width * 0.29 ,fit: BoxFit.cover,isAntiAlias: true,),
                    CustomSized(),
                    smallText(title: categoriesList[index],color: darkFontGrey),
                  ],
                ),
              ),
            ),
          );
        })
      ),
    );
  }
}