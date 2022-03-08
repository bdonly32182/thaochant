import 'package:chanthaburi_app/pages/business/category/edit_category.dart';
import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  String businessId;
  String typeBusiness;
  CategoryList({Key? key, required this.businessId,required this.typeBusiness}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  bool refresh = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyConstant.colorStore,
          title: const Text('รายการหมวดหมู่ทั้งหมด'),
        ),
        body: StreamBuilder(
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
                itemBuilder: (itemBuilder, int index) {
                  return InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditCategory(
                            categoryId: snapshot.data!.docs[index].id,
                            typeBusiness: widget.typeBusiness,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.all(10.0),
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data!.docs[index]['categoryName'],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 0.6),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const PouringHourGlass();
          },
        ));
  }
}
