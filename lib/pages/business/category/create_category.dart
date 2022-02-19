import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:flutter/material.dart';

class CreateCategory extends StatefulWidget {
  String businessId;
  CreateCategory({Key? key, required this.businessId}) : super(key: key);

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  Future<void> onCreateCategory(String categoryName, String businessId) async {
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
          await CategoryCollection.createCategory(categoryName, businessId);
      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
      _categoryController.clear();
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
                    onPressed: () => onCreateCategory(
                        _categoryController.text, widget.businessId),
                    child:const Text('สร้างหมวดหมู่'),
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
