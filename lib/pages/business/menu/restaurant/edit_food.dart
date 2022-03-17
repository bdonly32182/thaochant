import 'dart:io';

import 'package:chanthaburi_app/models/restaurant/food.dart';
import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditFood extends StatefulWidget {
  String foodName, foodId;
  double price;
  String imageRef;
  String restaurantId;
  String categoryId;
  String description;
  int status;
  List<String> optionId;
  EditFood({
    Key? key,
    required this.foodId,
    required this.foodName,
    required this.price,
    required this.imageRef,
    required this.restaurantId,
    required this.categoryId,
    required this.description,
    required this.status,
    required this.optionId,
  }) : super(key: key);

  @override
  State<EditFood> createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  final FoodModel _foodModel = FoodModel(
    foodName: '',
    price: 0,
    imageRef: '',
    restaurantId: '',
    categoryId: '',
    description: '',
    status: 1,
    optionId: [],
  );
  final _formKey = GlobalKey<FormState>();
  File? imageSelected;
  List<QueryDocumentSnapshot> categorys = [];

  @override
  void initState() {
    super.initState();
    onFetchsCategory();
  }

  onFetchsCategory() async {
    try {
      QuerySnapshot<Object?> _categorys =
          await CategoryCollection.categoryList(widget.restaurantId);
      setState(() {
        categorys = _categorys.docs;
        _foodModel.restaurantId = widget.restaurantId;
        _foodModel.imageRef = widget.imageRef;
        _foodModel.categoryId = widget.categoryId;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  getImage() async {
    File? image = await PickerImage.getImage();
    if (image != null) {
      setState(() {
        imageSelected = image;
      });
    }
  }

  takePhoto() async {
    File? takePhoto = await PickerImage.takePhoto();
    if (takePhoto != null) {
      setState(() {
        imageSelected = takePhoto;
      });
    }
  }

  _onSubmit() async {
    late BuildContext dialogContext;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          dialogContext = context;
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic> response = await FoodCollection.editFood(
          widget.foodId, _foodModel, imageSelected);
      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
    }
  }

  onDeleteFood(BuildContext context) async {
    late BuildContext dialogContext;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        dialogContext = context;
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> response =
        await FoodCollection.deleteFood(widget.foodId, _foodModel.imageRef);

    Navigator.pop(dialogContext);
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext showContext) => ResponseDialog(response: response),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลรายการอาหาร'),
        backgroundColor: MyConstant.colorStore,
        actions: [
          IconButton(
            onPressed: () {
              onDeleteFood(context);
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                fieldFoodName(width),
                fieldPrice(width),
                buildDropdown(width),
                fieldDescription(width),
                const SizedBox(height: 35),
                Center(
                  child: Text(
                    'เลือกรูปภาพหน้าปกเมนูอาหาร',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyConstant.colorStore),
                  ),
                ),
                const SizedBox(height: 10),
                buildPhoto(width, context),
                buildCreateFoodButton(context, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildCreateFoodButton(BuildContext context, double width) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(8.0),
      height: 50,
      child: ElevatedButton(
        child: const Text(
          'แก้ไขรายการอาหาร',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: _onSubmit,
        style: ElevatedButton.styleFrom(
          primary: MyConstant.colorStore,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Row buildPhoto(double width, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            dialogCamera(context, getImage, takePhoto,MyConstant.colorStore);
          },
          child: Container(
            width: width * .6,
            height: 150,
            child: imageSelected != null
                ? Image.file(
                    imageSelected!,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    widget.imageRef,
                    fit: BoxFit.fitWidth,
                    width: width * 0.16,
                    errorBuilder:
                        (BuildContext buildImageError, object, stackthree) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.image,
                            color: Color.fromRGBO(229, 153, 22, 0.7),
                            size: 60,
                          )
                        ],
                      );
                    },
                  ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row fieldPrice(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          height: 60,
          child: TextFormField(
            initialValue: widget.price.toString(),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกราคา';
              return null;
            },
            onSaved: (String? price) => _foodModel.price = double.parse(price!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ราคา :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.attach_money,
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
      ],
    );
  }

  Row buildDropdown(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          height: 60,
          child: categorys.isNotEmpty
              ? DropdownButton(
                  hint: const Text('เลือกเลือกประเภทอาหาร'),
                  items: categorys.map((DocumentSnapshot category) {
                    return DropdownMenuItem(
                      child: Text(
                        category.get('categoryName'),
                        style: TextStyle(
                          color: MyConstant.colorStore,
                        ),
                      ),
                      value: category.id,
                    );
                  }).toList(),
                  value: _foodModel.categoryId,
                  onChanged: (String? value) {
                    setState(() {
                      _foodModel.categoryId = value!;
                    });
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('ไม่มีหมวดหมู่'),
                  ],
                ),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Row fieldFoodName(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          width: width * .7,
          height: 60,
          child: TextFormField(
            initialValue: widget.foodName,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกชื่อเมนูอาหาร';
              return null;
            },
            onSaved: (String? name) => _foodModel.foodName = name!,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ชื่อเมนูอาหาร :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.card_membership,
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
      ],
    );
  }

  Row fieldDescription(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          child: TextFormField(
            initialValue: widget.description,
            maxLines: 2,
            onSaved: (String? description) =>
                _foodModel.description = description ?? '',
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'รายละเอียดสินค้า',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.description,
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
        )
      ],
    );
  }
}
