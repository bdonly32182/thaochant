import 'package:chanthaburi_app/pages/business/category/category_list.dart';
import 'package:chanthaburi_app/pages/business/category/create_category.dart';
import 'package:flutter/material.dart';

class MenuList extends StatefulWidget {
  String businessId;
  MenuList({Key? key, required this.businessId}) : super(key: key);

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return Container(
                            height: 100,
                            color: Colors.amber,
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    print('create menu');
                                  },
                                  child: Text('สร้างเมนู'),
                                ),
                                ElevatedButton(
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
                                  child: Text('สร้างหมวดหมู่'),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Text('เพิ่ม'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) =>
                            CategoryList(businessId: widget.businessId),
                      ),
                    );
                  },
                  child: Text('แก้ไขหมวดหมู่'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
