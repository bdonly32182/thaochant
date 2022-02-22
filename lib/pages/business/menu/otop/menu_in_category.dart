import 'package:chanthaburi_app/pages/business/menu/otop/card_menu_top.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/resources/firestore/product_otop_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MenuInCategory extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String businessId;
  const MenuInCategory({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.businessId,
  }) : super(key: key);

  @override
  State<MenuInCategory> createState() => _MenuInCategoryState();
}

class _MenuInCategoryState extends State<MenuInCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      width: double.maxFinite,
      child: ExpansionTile(
        title: Text(
          widget.categoryName,
          style: TextStyle(
            color: MyConstant.colorStore,
            fontSize: 18,
          ),
        ),
        trailing: Icon(
          Icons.arrow_drop_down,
          color: MyConstant.colorStore,
        ),
        children: [
          FutureBuilder(
            future: ProductOtopCollection.products(
                widget.businessId, widget.categoryId),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('เกิดเหตุขัดข้อง');
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.docs.isEmpty) {
                  return const Text('ไม่มีข้อมูลสินค้า');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    return CardMenuOtop(
                      imageRef: snapshot.data!.docs[index]['imageRef'],
                      price: snapshot.data!.docs[index]['price'].toString(),
                      productName: snapshot.data!.docs[index]['productName'],
                    );
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
