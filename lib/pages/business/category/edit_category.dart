import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/resources/firestore/product_otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/room_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  String categoryId;
  String typeBusiness;
  EditCategory({Key? key, required this.categoryId, required this.typeBusiness})
      : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  int? productSize;
  @override
  void initState() {
    super.initState();
    getCategory();
  }

  void getCategory() async {
    try {
      DocumentSnapshot category =
          await CategoryCollection.category(widget.categoryId);
      switch (widget.typeBusiness) {
        case 'productOtopCollection':
          int productOtopSize =
              await ProductOtopCollection.checkProduct(widget.categoryId);
          setState(() {
            productSize = productOtopSize;
          });
          break;
        case 'foodCollection':
          int productFoodSize =
              await FoodCollection.checkFood(widget.categoryId);
          setState(() {
            productSize = productFoodSize;
          });
          break;
        case 'roomCollection':
          int productRoomSize =
              await RoomCollection.checkRoom(widget.categoryId);
          setState(() {
            productSize = productRoomSize;
          });
          break;
        default:
      }
      setState(() {
        categoryController.text = category.get('categoryName');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> onEditCategory(String categoryName, String businessId) async {
    late BuildContext dialogContext;

    if (_formKey.currentState!.validate()) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          dialogContext = context;
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic>? response =
          await CategoryCollection.editCategory(categoryName, businessId);
      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
    }
  }

  Future<void> onDeleteCategory(String categoryId) async {
    late BuildContext dialogContext;

    if (_formKey.currentState!.validate()) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          dialogContext = context;
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic>? response =
          await CategoryCollection.deleteCategory(categoryId);
      Navigator.pop(dialogContext);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.colorStore,
        title: const Text('สร้างหมวดหมู่'),
      ),
      backgroundColor: MyConstant.backgroudApp,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 20.0,
                  left: 8.0,
                  right: 8.0,
                  bottom: 10.0,
                ),
                child: TextFormField(
                  controller: categoryController,
                  validator: (value) {
                    if (value!.isEmpty) return 'กรุณากรอกหมวดหมู่';
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'ชื่อหมวดหมู่ :',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      prefix: Icon(
                        Icons.account_balance,
                        color: MyConstant.colorStore,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      )),
                  style: TextStyle(
                    color: MyConstant.colorStore,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      if (productSize == 0) {
                        onDeleteCategory(widget.categoryId);
                      } else {
                        dialogAlert(context, 'ไม่สามารถลบได้',
                            'เนื่องจากมีสินค้าอยู่ที่หมวดหมู่นี้');
                      }
                    },
                    child: Text(
                      'ลบหมวดหมู่',
                      style: TextStyle(
                        color: Colors.red[800],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    )),
              ),
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ElevatedButton(
                    onPressed: () => onEditCategory(
                        categoryController.text, widget.categoryId),
                    child: Text('แก้ไขหมวดหมู่'),
                    style: ElevatedButton.styleFrom(
                      primary: MyConstant.colorStore,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
