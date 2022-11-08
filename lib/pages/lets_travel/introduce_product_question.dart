import 'package:chanthaburi_app/models/business/introduce_business.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IntroduceProductQuestion extends StatefulWidget {
  final List<IntroduceProductModel> selects;
  final Function onSelected;
  final Function onRemove;
  final QuerySnapshot<IntroduceProductModel> intros;
  const IntroduceProductQuestion({
    Key? key,
    required this.onSelected,
    required this.selects,
    required this.onRemove,
    required this.intros,
  }) : super(key: key);

  @override
  State<IntroduceProductQuestion> createState() =>
      _IntroduceProductQuestionState();
}

class _IntroduceProductQuestionState extends State<IntroduceProductQuestion> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: height * 0.1),
          decoration: const BoxDecoration(
            color: Colors.white60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'ท่านสนใจซื้อสินค้าอะไรจากชุมชนหลังวัดโรมัน บ้านท่าเรือจ้าง และริมน้ำจันทบูร นี้',
                  style: TextStyle(
                    color: MyConstant.themeApp,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  softWrap: true,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '* เลือกได้มากกว่า 1 ข้อ',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.intros.docs.length,
                itemBuilder: (context, index) {
                  IntroduceProductModel product =
                      widget.intros.docs[index].data();
                  String id = widget.intros.docs[index].id;
                  bool isSelected = widget.selects
                      .where((select) =>
                          select.businessId == product.businessId &&
                          select.name == product.name)
                      .isNotEmpty;
                  return Card(
                    margin: const EdgeInsets.only(
                      left: 18.0,
                      right: 18.0,
                      top: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CheckboxListTile(
                      activeColor: MyConstant.themeApp,
                      title: Text(product.name),
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          if (checked) {
                            widget.onSelected(product, id);
                          } else {
                            widget.onRemove(product, id);
                          }
                        }
                      },
                      value: isSelected,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
