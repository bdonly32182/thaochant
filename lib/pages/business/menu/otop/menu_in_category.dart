import 'package:chanthaburi_app/pages/business/menu/otop/card_menu_top.dart';
import 'package:chanthaburi_app/resources/firestore/product_otop_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.all(6.0),
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.categoryName,
                  style: TextStyle(
                    color: MyConstant.colorStore,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder(
            stream: ProductOtopCollection.products(
                widget.businessId, widget.categoryId),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('เกิดเหตุขัดข้อง');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
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
                    productId: snapshot.data!.docs[index].id,
                    otopId: snapshot.data!.docs[index]['otopId'],
                    status: snapshot.data!.docs[index]['status'],
                  );
                },
              );
            },
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 0.4),
          ),
        ],
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
