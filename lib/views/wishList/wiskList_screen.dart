import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/colors.dart';
import 'package:emart_app/consts/firebase_const.dart';
import 'package:emart_app/services/firse_store_services.dart';
import 'package:emart_app/widgets_common/text_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets_common/CustomSized.dart';


class WishList extends StatelessWidget {
  const WishList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          title: normalText(title: 'My WishList',color: darkFontGrey),
        ),
        body: StreamBuilder(
            stream: FireStoreServices.getWishList(currentUser!.uid),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CupertinoActivityIndicator(),);
              }else if (snapshot.data!.docs.isEmpty){
                return Center(child: largeText(title: 'No Order ',color: darkFontGrey));
              } else if (snapshot.hasData){
                var data = snapshot.data!.docs ;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context,index){
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          tileColor: lightGrey,
                          contentPadding: EdgeInsets.all(5),
                          title: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  height:70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(image: NetworkImage(data[index]['p_images'][0]),fit: BoxFit.cover),
                                  ),
                                ),
                                CustomSized(),
                                normalText(title: data[index]['p_name'],color: darkFontGrey,),
                              ],
                            ),
                          ),
                          trailing: IconButton(onPressed: () async {
                           await fireStore.collection(productsCollections).doc(data[index].id).set({
                             'p_wishList':FieldValue.arrayRemove([currentUser!.uid]),
                           },SetOptions(merge: true));
                          }, icon: Icon(Icons.favorite,color: redColor,)),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                normalText(title: 'Price : ${data[index]['p_price']}',color: darkFontGrey,),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                );
              }
              else{
                return Center(child: largeText(title: 'Something went wrong',color: darkFontGrey));
              }
            }
        )
    );
  }
}
