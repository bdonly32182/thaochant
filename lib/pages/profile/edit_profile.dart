import 'dart:io';

import 'package:chanthaburi_app/pages/authen.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget {
  String fullName, phoneNumber, profileRef, docId;
  Color theme;

  EditProfile({
    Key? key,
    required this.fullName,
    required this.phoneNumber,
    required this.profileRef,
    required this.theme,
    required this.docId,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  File? profileImage;
  @override
  void initState() {
    super.initState();
    setState(() {
      _fullNameController.text = widget.fullName;
      _phoneController.text = widget.phoneNumber;
    });
  }

  void getImage() async {
    File? _imagePath = await PickerImage.getImage();
    if (_imagePath != null) {
      setState(() {
        profileImage = _imagePath;
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
        profileImage = takePhoto;
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

  onEditProfile(BuildContext buildContext) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    await UserCollection.changeProfile(
      widget.docId,
      _fullNameController.text,
      _phoneController.text,
      widget.profileRef,
      profileImage,
    );
    Navigator.pop(buildContext);
    Navigator.pop(context);
  }

  onDeleteAccount(String docId) async {
    try {
      await AuthMethods.deleteAccount(docId);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext showContext) => const ResponseDialog(
          response: {"status": "200", "message": "ลบบัญชีผู้ใช้งานเรียบร้อย"},
        ),
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const Authen()),
          (route) => false);
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext showContext) => const ResponseDialog(
          response: {"status": "400", "message": "ลบบัญชีผู้ใช้งานล้มเหลว"},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("แก้ไขข้อมูลส่วนตัว"),
        backgroundColor: widget.theme,
      ),
      body: SafeArea(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildProfileImage(context, width),
                  buildFullName(width),
                  buildPhone(width),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: width * 0.4,
                    child: ElevatedButton(
                      child: Row(
                        children: const [
                          Text("แก้ไขข้อมูลส่วนตัว"),
                        ],
                      ),
                      onPressed: () => dialogConfirm(
                        context,
                        "แจ้งเตือน",
                        "คุณแน่ใจที่จะเปลี่ยนข้อมูลส่วนตัวใช่หรือไม่",
                        onEditProfile,
                      ),
                      style: ElevatedButton.styleFrom(primary: widget.theme),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: width * 0.4,
                    child: ElevatedButton(
                      child: Row(
                        children: const [
                          Text(
                            "ลบบัญชีผู้ใช้งาน",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () => dialogDeleteAccount(
                        context,
                        widget.docId,
                        onDeleteAccount,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  InkWell buildProfileImage(BuildContext context, double width) {
    return InkWell(
      onTap: () => dialogCamera(
        context,
        getImage,
        takePhoto,
        widget.theme,
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 50.0,
              bottom: 10.0,
            ),
            width: width * 0.3,
            height: 110.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: profileImage == null
                  ? widget.profileRef.isNotEmpty
                      ? Image.network(
                          widget.profileRef,
                          fit: BoxFit.cover,
                          width: width * 0.26,
                          height: 110.0,
                          errorBuilder: (BuildContext buildImageError, object,
                              stackthree) {
                            return Container(
                              width: width * 0.26,
                              height: 110.0,
                              child: ShowImage(
                                pathImage: MyConstant.iconUser,
                              ),
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(0, 02),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : buildImageIconUser(width)
                  : buildImageFile(width),
            ),
          ),
          Icon(
            Icons.add_a_photo_outlined,
            color: widget.theme,
          )
        ],
      ),
    );
  }

  Container buildImageIconUser(double width) {
    return Container(
      width: width * 0.26,
      height: 110.0,
      child: ShowImage(
        pathImage: MyConstant.iconUser,
      ),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            offset: Offset(0, 02),
          ),
        ],
      ),
    );
  }

  Container buildImageFile(double width) {
    return Container(
      width: width * 0.26,
      height: 110.0,
      child: Image.file(
        profileImage!,
        fit: BoxFit.cover,
      ),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            offset: Offset(0, 02),
          ),
        ],
      ),
    );
  }

  Row buildPhone(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * 0.7,
          child: TextFormField(
            inputFormatters: [phoneMask],
            controller: _phoneController,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกเบอร์โทรศัพท์';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'เบอร์โทรศัพท์ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(
                  Icons.phone_android,
                  color: widget.theme,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                )),
            style: TextStyle(color: widget.theme, fontWeight: FontWeight.w700),
          ),
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 0.2),
            ),
          ]),
        ),
      ],
    );
  }

  Row buildFullName(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * 0.7,
          child: TextFormField(
            controller: _fullNameController,
            validator: (String? value) {
              if (value!.isEmpty) return 'กรุณากรอกชื่อ-นามสกุล';
              return null;
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: 'ชื่อ-นามสกุล :',
              labelStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(
                Icons.person,
                color: widget.theme,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(color: widget.theme, fontWeight: FontWeight.w700),
          ),
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0.2, 0.2),
            ),
          ]),
        ),
      ],
    );
  }
}
