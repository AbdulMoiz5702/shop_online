import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/controllers/product_controller.dart';
import 'package:emart_app/views/chat_screen/chat_screen.dart';
import 'package:emart_app/widgets_common/CustomButtom.dart';
import 'package:emart_app/widgets_common/CustomSized.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String title;
  final dynamic data;
  const ItemDetailsScreen({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    var itemDetailController = Get.put(ProductController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          itemDetailController.resetvalue();
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: normalText(title: title, color: darkFontGrey),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share_sharp,
                color: darkFontGrey,
              )),
          Obx(
          ()=> IconButton(
                onPressed: () {
                  if(itemDetailController.isFavorite.value == true){
                    itemDetailController.removeToWishList(data.id);
                    itemDetailController.isFavorite.value == false;
                  }else{
                    itemDetailController.addToWishList(data.id);
                    itemDetailController.isFavorite.value == true;
                  }
                },
                icon: Icon(
                  Icons.favorite,
                  color: itemDetailController.isFavorite.value == true ? redColor :darkFontGrey,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
                enlargeCenterPage: true,
                scrollPhysics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                autoPlayCurve: Curves.easeInOutExpo,
                autoPlay: true,
                aspectRatio: 10 / 8,
                isFastScrollingEnabled: true,
                itemCount: data['p_images'].length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(data['p_images'][index]),
                          fit: BoxFit.fill,
                          isAntiAlias: true),
                    ),
                  );
                }),
            CustomSized(),
            CustomSized(height: 0.01),
            VxRating(
              isSelectable: false,
              value: double.parse(data['p_rating']),
              onRatingUpdate: (value) {},
              normalColor: textfieldGrey,
              count: 5,
              selectionColor: golden,
              maxRating: 5,
              size: 25,
            ),
            CustomSized(),
            normalText(title: '${data['p_price']} \$', color: redColor),
            CustomSized(),
            Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.sizeOf(context).width * 1,
                height: MediaQuery.sizeOf(context).height * 0.08,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: textfieldGrey),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        smallText(title: 'Seller', color: whiteColor),
                        normalText(
                            title: data['p_seller'], color: darkFontGrey),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Get.to(()=> ChatScreen(name: data['p_seller']),transition: Transition.cupertino,arguments: [data['p_seller'],data['vendor_id']]);

                        },
                        icon: Icon(
                          Icons.message_outlined,
                          color: darkFontGrey,
                        )),
                  ],
                )),
            CustomSized(),
            Card(
              color: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Container(
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.sizeOf(context).width * 1,
                    height: MediaQuery.sizeOf(context).height * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: whiteColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        smallText(title: 'Colors', color: textfieldGrey),
                        CustomSized(),
                        Obx(
                          () => Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(data['p_colors'].length,
                                  (index) {
                                return InkWell(
                                  onTap: () {
                                    itemDetailController
                                        .changeColorIndex(index);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(2),
                                    height: 100,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(
                                          int.parse(data['p_colors'][index])),
                                    ),
                                    child: Visibility(
                                        visible: index ==
                                            itemDetailController
                                                .colorIndex.value,
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        )),
                                  ),
                                );
                              })),
                        ),
                      ],
                    )),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      smallText(
                        title: 'Quantity :',
                        color: darkFontGrey,
                      ),
                      CustomSized(),
                      smallText(
                        title: '',
                        color: darkFontGrey,
                      ),
                    ],
                  ),
                  CustomSized(
                    width: 0.04,
                  ),
                  Obx(
                    () => Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            itemDetailController.increaseQuantity(
                                int.parse(data['p_quantity']));
                            itemDetailController.totalPriceCalculate(
                                int.parse(data['p_price']));
                          },
                          icon: Icon(Icons.add),
                        ),
                        normalText(
                          title: itemDetailController.quantity.value,
                          color: darkFontGrey,
                        ),
                        IconButton(
                            onPressed: () {
                              itemDetailController.decreaseQuantity();
                              itemDetailController.totalPriceCalculate(
                                  int.parse(data['p_price']));
                            },
                            icon: Icon(Icons.remove)),
                      ],
                    ),
                  ),
                  CustomSized(
                    width: 0.04,
                  ),
                  smallText(
                    title: 'available ( ${data['p_quantity']} )',
                    color: darkFontGrey,
                  ),
                ],
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    smallText(
                      title: 'Total :',
                      color: darkFontGrey,
                    ),
                    CustomSized(
                      width: 0.06,
                    ),
                    Obx(
                      () => normalText(
                        title: '\$ ${itemDetailController.totalPrice.value}',
                        color: redColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            normalText(title: 'Description', color: darkFontGrey),
            CustomSized(
              width: 0.06,
              height: 0.01,
            ),
            smallText(title: data['p_description'], color: darkFontGrey),
            CustomSized(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
          ()=>itemDetailController.isLoading.value == true ? const Center(child: CupertinoActivityIndicator(color: redColor,),): SizedBox(
            width: MediaQuery.sizeOf(context).width * 1,
            child: CustomButton(
                onTap: () {
                  if(itemDetailController.quantity.value != 0){
                    itemDetailController.addToCart(
                        title: data['p_name'],
                        imageLink: data['p_images'][0],
                        sellerName: data['p_seller'],
                        vendorId: data['vendor_id'],
                        color: data['p_colors'][itemDetailController.colorIndex.value],
                        quantity: itemDetailController.quantity.value.toString(),
                        totalPrice: itemDetailController.totalPrice.value.toString(),
                        context: context);
                  }else{
                    VxToast.show(context, msg: 'You must have to buy a product');
                  }
                },
                title: 'Add to Cart',
                color: redColor,
                width: 0.8,
                height: 0.06)),
      ),
    );
  }
}
