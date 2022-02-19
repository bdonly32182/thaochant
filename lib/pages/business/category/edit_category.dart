import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  String categoryId;
  EditCategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _categoryController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  void getCategory() async {
    DocumentSnapshot category =
        await CategoryCollection.category(widget.categoryId);
    setState(() {
      _categoryController.text = category.get('categoryName');
    });
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
                  controller: _categoryController,
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
                    onPressed: () => onDeleteCategory(widget.categoryId),
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
                        _categoryController.text, widget.categoryId),
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
