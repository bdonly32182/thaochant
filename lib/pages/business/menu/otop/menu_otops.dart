import 'package:chanthaburi_app/pages/business/category/category_list.dart';
import 'package:chanthaburi_app/pages/business/category/create_category.dart';
import 'package:chanthaburi_app/pages/business/menu/otop/create_menu_otop.dart';
import 'package:chanthaburi_app/pages/business/menu/otop/menu_in_category.dart';
import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuOtops extends StatefulWidget {
  String businessId;
  MenuOtops({Key? key, required this.businessId}) : super(key: key);

  @override
  State<MenuOtops> createState() => _MenuOtopsState();
}

class _MenuOtopsState extends State<MenuOtops> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.colorStore,
        title: const Center(child: Text('รายการสินค้า')),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildRowCreateAndEdit(context),
            StreamBuilder(
              stream: CategoryCollection.streamCategorys(widget.businessId),
              builder: (builder, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const InternalError();
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data!.docs.isEmpty) {
                    return const ShowDataEmpty();
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (itemBuilder, index) {
                        return MenuInCategory(
                          categoryId: snapshot.data!.docs[index].id,
                          categoryName: snapshot.data!.docs[index]
                              ['categoryName'],
                          businessId: snapshot.data!.docs[index]['businessId'],
                        );
                      });
                }
                return const PouringHourGlass();
              },
            ),
          ],
        ),
      ),
    );
  }

  Row buildRowCreateAndEdit(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return SizedBox(
                    height: 120,
                    child: Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: 55,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(builder);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) =>
                                      CreateMenuOtop(otopId: widget.businessId),
                                ),
                              );
                            },
                            child: Text(
                              'สร้างผลิตภัณฑ์ชุมชน',
                              style: TextStyle(
                                fontSize: 18,
                                color: MyConstant.colorStore,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(0, 0.4),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          height: 60,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(builder);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CreateCategory(
                                    businessId: widget.businessId,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'สร้างหมวดหมู่ผลิตภัณฑ์ชุมชน',
                              style: TextStyle(
                                fontSize: 18,
                                color: MyConstant.colorStore,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Row(
            children: [
              Icon(
                Icons.add,
                color: Colors.grey.shade700,
              ),
              Text(
                'เพิ่ม',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => CategoryList(
                  businessId: widget.businessId,
                  typeBusiness: MyConstant.productOtopCollection,
                ),
              ),
            );
          },
          child: Row(
            children: [
              Icon(
                Icons.note_alt_outlined,
                color: Colors.grey.shade700,
              ),
              Text(
                'แก้ไขหมวดหมู่',
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
