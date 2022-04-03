import 'dart:io';

import 'package:chanthaburi_app/models/resort/room.dart';
import 'package:chanthaburi_app/resources/firestore/category_collection.dart';
import 'package:chanthaburi_app/resources/firestore/room_collection.dart';
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

class CreateRoom extends StatefulWidget {
  String resortId;
  CreateRoom({Key? key, required this.resortId}) : super(key: key);

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final RoomModel _roomModel = RoomModel(
    roomName: '',
    price: 0,
    imageCover: '',
    listImageDetail: [],
    resortId: '',
    categoryId: '',
    descriptionRoom: '',
    totalRoom: 0,
    roomSize: 0,
    totalGuest: 0,
  );
  final _formKey = GlobalKey<FormState>();
  File? selectImageCover;
  List<File> listImageSelected = [];
  List<QueryDocumentSnapshot> categorys = [];

  @override
  void initState() {
    super.initState();
    onFetchsCategory();
  }

  onFetchsCategory() async {
    try {
      QuerySnapshot<Object?> _categorys =
          await CategoryCollection.categoryList(widget.resortId);
      setState(() {
        categorys = _categorys.docs;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  getImage() async {
    File? image = await PickerImage.getImage();
    if (image != null) {
      setState(() {
        listImageSelected.add(image);
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

  getImageCover() async {
    File? imageCover = await PickerImage.getImage();
    if (imageCover != null) {
      setState(() {
        selectImageCover = imageCover;
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

  takePhotoCover() async {
    File? takePhotoCover = await PickerImage.takePhoto();
    if (takePhotoCover != null) {
      setState(() {
        selectImageCover = takePhotoCover;
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

  takePhoto() async {
    File? takePhoto = await PickerImage.takePhoto();
    if (takePhoto != null) {
      setState(() {
        listImageSelected.add(takePhoto);
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
      _roomModel.resortId = widget.resortId;
      _formKey.currentState!.save();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          dialogContext = context;
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic> response = await RoomCollection.createRoom(
          _roomModel, selectImageCover, listImageSelected);
      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
      _formKey.currentState!.reset();
      setState(() {
        selectImageCover = null;
        listImageSelected = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Text('สร้างข้อมูลห้องพัก'),
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
                fieldRoomName(width),
                fieldPrice(width),
                fieldDescription(width),
                buildDropdown(width),
                fieldRoomSize(width),
                fieldTotalRoom(width),
                fieldAmountGuest(width),
                const SizedBox(height: 35),
                Center(
                  child: Text(
                    'รูปภาพหน้าปกห้องพัก',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyConstant.colorStore),
                  ),
                ),
                const SizedBox(height: 10),
                buildPhoto(width, context),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'รูปภาพรายละเอียดห้องพัก',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyConstant.colorStore),
                  ),
                ),
                buildListImage(context, width),
                buildCreateRoomButton(context, width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell buildListImage(BuildContext context, double width) {
    return InkWell(
      onTap: () =>
          dialogCamera(context, getImage, takePhoto, MyConstant.colorStore),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        height: 150,
        child: listImageSelected.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: listImageSelected.length,
                itemBuilder: (itemBuilder, index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: width * 0.46,
                        child: Image.file(
                          listImageSelected[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 40,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              listImageSelected.removeAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                          iconSize: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                  );
                },
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
    );
  }

  Container buildCreateRoomButton(BuildContext context, double width) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(8.0),
      height: 50,
      child: ElevatedButton(
        child: const Text(
          'สร้างรายการห้องพัก',
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
            dialogCamera(
                context, getImageCover, takePhotoCover, MyConstant.colorStore);
          },
          child: Container(
            width: width * .6,
            height: 150,
            child: selectImageCover != null
                ? Image.file(
                    selectImageCover!,
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
          height: 60,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกราคา';
              return null;
            },
            onSaved: (String? price) => _roomModel.price = double.parse(price!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ราคา(ต่อคืน) :',
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

  Row fieldRoomSize(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          height: 60,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกขนาดห้อง';
              return null;
            },
            onSaved: (String? size) =>
                _roomModel.roomSize = double.parse(size!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ขนาดห้อง ตรม. :',
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

  Row fieldTotalRoom(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          height: 60,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกจำนวนห้องทั้งหมด';
              return null;
            },
            onSaved: (String? totalGuest) =>
                _roomModel.totalGuest = int.parse(totalGuest!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'จำนวนห้องทั้งหมด :',
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

  Row fieldAmountGuest(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          height: 60,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกจำนวนผู้เข้าพักต่อห้อง';
              return null;
            },
            onSaved: (String? totalGuest) =>
                _roomModel.totalGuest = int.parse(totalGuest!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'จำนวนผู้เข้าพักต่อห้อง :',
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
              labelText: "เลือกเลือกประเภทห้องพัก",
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
                return "กรุณากรอกเลือกประเภทห้องพัก";
              }
              return null;
            },
            onChanged: (QueryDocumentSnapshot<Object?>? query) =>
                _roomModel.categoryId = query!.id,
            loadingBuilder: (context, load) =>
                const CircularProgressIndicator(),
            errorBuilder: (context, str, dy) =>
                const Text("ขออภัย ณ ขณะนี้เกิดเหตุขัดข้อง"),
            emptyBuilder: (context, searchEntry) =>
                const Text("ไม่มีข้อมูลประเภทห้องพัก"),
          ),
        ),
      ],
    );
  }

  Row fieldRoomName(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          width: width * .7,
          height: 60,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกชื่อห้องพัก';
              return null;
            },
            onSaved: (String? name) => _roomModel.roomName = name!,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ชื่อห้องพัก :',
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
                _roomModel.descriptionRoom = description ?? '',
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'รายละเอียดห้องพัก',
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
