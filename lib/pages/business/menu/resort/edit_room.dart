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
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditRoom extends StatefulWidget {
  String imageCover, resortId, roomId, categoryId, descriptionRoom, roomName;
  double roomSize, price;
  int totalRoom, totalGuest;
  List<String> listImageDetail;
  EditRoom({
    Key? key,
    required this.roomId,
    required this.roomName,
    required this.price,
    required this.imageCover,
    required this.listImageDetail,
    required this.resortId,
    required this.categoryId,
    required this.descriptionRoom,
    required this.totalRoom,
    required this.roomSize,
    required this.totalGuest,
  }) : super(key: key);

  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
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
  List<QueryDocumentSnapshot<Object?>> categorys = [];
  File? selectImageCover;
  List<File> listImageSelected = [];
  List<String> listImageDelete = [];
  @override
  void initState() {
    super.initState();
    onFetchRoom();
  }

  onFetchRoom() async {
    try {
      QuerySnapshot _categorys =
          await CategoryCollection.categoryList(widget.resortId);
      setState(() {
        categorys = _categorys.docs;
        _roomModel.categoryId = widget.categoryId;
        _roomModel.imageCover = widget.imageCover;
        _roomModel.listImageDetail = widget.listImageDetail;
      });
    } catch (e) {}
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
      _formKey.currentState!.save();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          dialogContext = context;
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic> response = await RoomCollection.editProduct(
        widget.roomId,
        _roomModel,
        selectImageCover,
        listImageSelected,
        listImageDelete,
      );
      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
      _formKey.currentState!.reset();
      setState(() {
        listImageSelected = [];
      });
    }
  }

  _onDeleteRoom(BuildContext buildContext) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> response = await RoomCollection.deleteRoom(
        widget.roomId, widget.imageCover, widget.listImageDetail);

    Navigator.pop(buildContext);
    Navigator.pop(context);
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
        title: const Text('แก้ไขข้อมูลห้องพัก'),
        backgroundColor: MyConstant.colorStore,
        actions: [
          IconButton(
            onPressed: () {
              dialogConfirm(
                context,
                "แจ้งเตือน",
                "คุณแน่ใจแล้วที่จะลบรายการนี้ใช่หรือไม่",
                _onDeleteRoom,
              );
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
                fieldRoomName(width),
                fieldPrice(width),
                fieldDescription(width),
                buildDropdown(width),
                fieldRoomSize(width),
                fieldTotalRoom(width),
                fieldTotalGuest(width),
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
                    listImageSelected.isEmpty
                        ? 'รูปภาพดั้งเดิม'
                        : 'รูปภาพที่เพิ่มขึ้นมาใหม่',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MyConstant.colorStore),
                  ),
                ),
                buildListImage(context, width),
                buildEditRoomButton(context, width),
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
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: _roomModel.listImageDetail.length,
                itemBuilder: (itemBuilder, index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: width * 0.46,
                        child: Image.network(
                          _roomModel.listImageDetail[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 36,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              listImageDelete
                                  .add(widget.listImageDetail[index]);
                              _roomModel.listImageDetail.removeAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 18,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
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
    );
  }

  Row fieldTotalRoom(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          child: TextFormField(
            initialValue: widget.totalRoom.toString(),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกจำนวนห้องทั้งหมด';
              return null;
            },
            onSaved: (String? totalGuest) =>
                _roomModel.totalRoom = int.parse(totalGuest!),
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

  Container buildEditRoomButton(BuildContext context, double width) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(8.0),
      height: 50,
      child: ElevatedButton(
        child: const Text(
          'แก้ไขรายการห้องพัก',
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
                : Image.network(
                    widget.imageCover,
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
          child: TextFormField(
            initialValue: widget.price.toString(),
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
          child: TextFormField(
            initialValue: widget.roomSize.toString(),
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

  Row fieldTotalGuest(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .7,
          child: TextFormField(
            initialValue: widget.totalGuest.toString(),
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
                  value: _roomModel.categoryId,
                  onChanged: (String? value) {
                    setState(() {
                      _roomModel.categoryId = value!;
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

  Row fieldRoomName(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          width: width * .7,
          child: TextFormField(
            initialValue: widget.roomName,
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
            initialValue: widget.descriptionRoom,
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
