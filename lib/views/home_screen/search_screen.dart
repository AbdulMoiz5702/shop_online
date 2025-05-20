import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/services/firse_store_services.dart';
import 'package:emart_app/widgets_common/featuresproducts.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets_common/CustomSized.dart';
import '../categories/item_details.dart';


class SearchScreen extends StatelessWidget {
  final String search ;
  const SearchScreen({required this.search});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FireStoreServices.getSearchProducts(search),
        builder: (context,AsyncSnapshot<QuerySnapshot>  snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CupertinoActivityIndicator(),);
          } else if (snapshot.data!.docs.isEmpty){
            return Center(child: largeText(title: 'No Product Found',color: darkFontGrey));
          }else if (snapshot.hasData){
            var data = snapshot.data!.docs ;
            var filerProducts = data.where((element) => element['p_name'].toString().toLowerCase().contains(search.toString().toLowerCase())).toList();
            return ListView.builder(
              physics:const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(2),
              itemCount: filerProducts.length,
                itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    Get.to(()=> ItemDetailsScreen(title: filerProducts[index]['p_subcategory'], data: filerProducts[index]),transition: Transition.cupertino);
                  },
                  child: Card(
                    margin: EdgeInsets.all(4),
                    color: whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      height: MediaQuery.sizeOf(context).height * 0.25,
                      width: MediaQuery.sizeOf(context).width * 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:MediaQuery.sizeOf(context).height * 0.16,width:MediaQuery.sizeOf(context).width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(image: NetworkImage(filerProducts[index]['p_images'][0]),fit: BoxFit.cover,isAntiAlias: true),
                                ),),
                              CustomSized(height: 0.01,),
                              normalText(title: filerProducts[index]['p_name'],color: darkFontGrey),
                              smallText(title: '${filerProducts[index]['p_price']} \$',color: darkFontGrey)
                            ],
                          ),
                          CustomSized(width: 0.05,),
                          Expanded(child: Text(filerProducts[index]['p_description'],style: const TextStyle(color: darkFontGrey),))
                        ],
                      ),
                    ),
                  ),
                );
                }
            ) ;
          }else{
            return Center(child: largeText(title: 'something went wrong',color: darkFontGrey));
          }
        },
      ),
    );
  }
}
