import 'dart:io';

import 'package:chanthaburi_app/models/restaurant/food.dart';
import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/resources/firestore/food_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateFood extends StatefulWidget {
  String restaurantId;
  CreateFood({Key? key, required this.restaurantId}) : super(key: key);

  @override
  State<CreateFood> createState() => _CreateFoodState();
}

class _CreateFoodState extends State<CreateFood> {
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
    } else {
      PermissionStatus photoStatus = await Permission.photos.status;
      if (photoStatus.isPermanentlyDenied) {
        alertService(
          context,
          'ไม่อนุญาติแชร์ Photo',
          'โปรดแชร์ Photo',
        );
      }
    }
  }

  takePhoto() async {
    File? takePhoto = await PickerImage.takePhoto();
    if (takePhoto != null) {
      setState(() {
        imageSelected = takePhoto;
      });
    } else {
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (cameraStatus.isPermanentlyDenied) {
        alertService(
          context,
          'ไม่อนุญาติแชร์ Camera',
          'โปรดแชร์ Camera',
        );
      }
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
      Map<String, dynamic> response =
          await FoodCollection.createFood(_foodModel, imageSelected);
      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
      _formKey.currentState!.reset();
      setState(() {
        imageSelected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Text('สร้างข้อมูลรายการอาหาร'),
        backgroundColor: MyConstant.colorStore,
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
          'สร้างรายการอาหาร',
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
            dialogCamera(context, getImage, takePhoto, MyConstant.colorStore);
          },
          child: Container(
            width: width * .6,
            height: 150,
            child: imageSelected != null
                ? Image.file(
                    imageSelected!,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.image,
                        color: Color.fromRGBO(229, 153, 22, 0.7),
                        size: 60,
                      ),
                    ],
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
          child: TextFormField(
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
          height: 80,
          child: DropdownSearch(
            mode: Mode.MENU,
            items: categorys,
            itemAsString: (QueryDocumentSnapshot<Object?>? item) =>
                item!.get("categoryName"),
            maxHeight: 260,
            dropdownSearchDecoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: "เลือกประเภทอาหาร",
              contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (QueryDocumentSnapshot<Object?>? valid) {
              if (valid == null) {
                return "กรุณากรอกเลือกประเภทอาหาร";
              }
              return null;
            },
            onChanged: (QueryDocumentSnapshot<Object?>? query) =>
                _foodModel.categoryId = query!.id,
            loadingBuilder: (context, load) =>
                const CircularProgressIndicator(),
            errorBuilder: (context, str, dy) =>
                const Text("ขออภัย ณ ขณะนี้เกิดเหตุขัดข้อง"),
            emptyBuilder: (context, searchEntry) =>
                const Text("ไม่มีข้อมูลประเภทอาหาร"),
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
          child: TextFormField(
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
