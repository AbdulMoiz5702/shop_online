import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/product_controller.dart';
import 'package:emart_app/views/categories/categories_details.dart';
import 'package:emart_app/widgets_common/bg_widgets.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../consts/colors.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12, // Increased spacing between columns
            mainAxisSpacing: 16,  // Increased spacing between rows
            childAspectRatio: 2.8 / 4.5, // Slightly wider and taller cards
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                categoryController.getSubCategories(title: categoriesList[index]);
                Get.to(
                      () => CategoriesDetails(title: categoriesList[index]),
                  transition: Transition.cupertino,
                );
              },
              child: Card(
                color: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        categoriesListImages[index],
                        height: MediaQuery.sizeOf(context).height * 0.14,
                        width: MediaQuery.sizeOf(context).width * 0.3,
                        fit: BoxFit.fill,
                        isAntiAlias: true,
                      ),
                      const SizedBox(height: 8),
                      smallText(title: categoriesList[index], color: darkFontGrey),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ),
    );
  }
}