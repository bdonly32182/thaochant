import 'dart:io';

import 'package:chanthaburi_app/models/otop/product.dart';
import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/resources/firestore/product_otop_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditMenuOtop extends StatefulWidget {
  final String otopId;
  final String productId;
  const EditMenuOtop({
    Key? key,
    required this.otopId,
    required this.productId,
  }) : super(key: key);

  @override
  _EditMenuOtopState createState() => _EditMenuOtopState();
}

class _EditMenuOtopState extends State<EditMenuOtop> {
  final ProductOtopModel productOtop = ProductOtopModel(
    productName: '',
    price: 0,
    imageRef: '',
    otopId: '',
    categoryId: '',
    description: '',
    status: 1,
    weight: 0,
    width: 0,
    height: 0,
    long: 0,
  );
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController longController = TextEditingController();
  List<QueryDocumentSnapshot<Object?>> categorys = [];
  String? categoryId;
  final _formKey = GlobalKey<FormState>();
  File? imageSelected;

  @override
  void initState() {
    super.initState();
    onFetchProduct();
  }

  onFetchProduct() async {
    try {
      DocumentSnapshot _product =
          await ProductOtopCollection.productById(widget.productId);
      QuerySnapshot _categorys =
          await CategoryCollection.categoryList(widget.otopId);
      setState(() {
        categorys = _categorys.docs;
        productNameController.text = _product.get('productName');
        priceController.text = _product.get('price').toString();
        productOtop.categoryId = _product.get('categoryId');
        productOtop.imageRef = _product.get('imageRef');
        descriptionController.text = _product.get('description');
        weightController.text = _product.get('weight').toString();
        widthController.text = _product.get('width').toString();
        heightController.text = _product.get('height').toString();
        longController.text = _product.get('long').toString();
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
      Map<String, dynamic> response = await ProductOtopCollection.editProduct(
          widget.productId, productOtop, imageSelected);
      Navigator.pop(dialogContext);

      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
    }
  }

  _onDeleteProduct(BuildContext context) async {
    late BuildContext dialogContext;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        dialogContext = context;
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> response = await ProductOtopCollection.deleteProduct(
        widget.productId, productOtop.imageRef);

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
        title: const Text('แก้ไขข้อมูลรายการสินค้า'),
        backgroundColor: MyConstant.colorStore,
        actions: [
          IconButton(
            onPressed: () {
              _onDeleteProduct(context);
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.deferToChild,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                fieldItemName(width),
                fieldPrice(width),
                fieldDescription(width),
                buildDropdown(width),
                fieldWeight(width),
                fieldWidth(width),
                fieldHeight(width),
                fieldLong(width),
                const SizedBox(height: 35),
                Center(
                  child: Text(
                    'เลือกรูปภาพสำหรับสินค้า',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyConstant.colorStore),
                  ),
                ),
                const SizedBox(height: 10),
                buildPhoto(width, context),
                buildCreateShopButton(context, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildCreateShopButton(BuildContext context, double width) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(10.0),
      height: 50,
      child: ElevatedButton(
        child: const Text(
          'แก้ไขรายการสินค้า',
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
                : Image.network(
                    productOtop.imageRef,
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
            controller: priceController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกราคา';
              return null;
            },
            onSaved: (String? price) =>
                productOtop.price = double.parse(price!),
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

  Row fieldWeight(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          height: 60,
          child: TextFormField(
            controller: weightController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกน้ำหนัก';
              return null;
            },
            onSaved: (String? weight) =>
                productOtop.weight = double.parse(weight!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'น้ำหนัก(กก.) :',
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

  Row fieldWidth(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          height: 60,
          child: TextFormField(
            controller: widthController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกความกว้าง';
              return null;
            },
            onSaved: (String? width) =>
                productOtop.width = double.parse(width!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ความกว้าง(ซ.ม.) :',
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

  Row fieldHeight(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          height: 60,
          child: TextFormField(
            controller: heightController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกความสูง';
              return null;
            },
            onSaved: (String? height) =>
                productOtop.height = double.parse(height!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ความสูง(ซ.ม.) :',
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

  Row fieldLong(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          height: 60,
          child: TextFormField(
            controller: longController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกความยาว';
              return null;
            },
            onSaved: (String? long) => productOtop.long = double.parse(long!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ความยาว(ซ.ม.) :',
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
                  hint: const Text('เลือกเลือกประเภทสินค้า'),
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
                  value: productOtop.categoryId,
                  onChanged: (String? value) {
                    setState(() {
                      productOtop.categoryId = value!;
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

  Row fieldItemName(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          width: width * .7,
          height: 60,
          child: TextFormField(
            controller: productNameController,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกชื่อสินค้า';
              return null;
            },
            onSaved: (String? name) => productOtop.productName = name!,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ชื่อสินค้า :',
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
            controller: descriptionController,
            maxLines: 2,
            onSaved: (String? description) =>
                productOtop.description = description ?? '',
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
