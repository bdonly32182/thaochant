import 'package:chanthaburi_app/models/business/introduce_business.dart';
import 'package:chanthaburi_app/pages/introduce_product/upsert_introduce_product.dart';
import 'package:chanthaburi_app/resources/firestore/introduce_product_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IntroduceProducts extends StatefulWidget {
  const IntroduceProducts({Key? key}) : super(key: key);

  @override
  State<IntroduceProducts> createState() => _IntroduceProductsState();
}

class _IntroduceProductsState extends State<IntroduceProducts> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("สินค้าที่แนะนำทั้งหมด"),
        backgroundColor: MyConstant.themeApp,
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const UpsertIntroduceProduct(),
                    ),
                  ),
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder(
        stream: IntroduceProductCollection.introduceProducts(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<IntroduceProductModel>> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PouringHourGlass();
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    IntroduceProductModel product =
                        snapshot.data!.docs[index].data();
                    String introduceId = snapshot.data!.docs[index].id;
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => UpsertIntroduceProduct(
                            introduceProductModel: product,
                            docId: introduceId,
                          ),
                        ),
                      ),
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
