import 'dart:io';

import 'package:chanthaburi_app/models/user/user.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateGuide extends StatefulWidget {
  CreateGuide({Key? key}) : super(key: key);

  @override
  State<CreateGuide> createState() => _CreateGuideState();
}

class _CreateGuideState extends State<CreateGuide> {
  File? profileImage;

  bool eyesPassword = true;
  bool eyesConfirm = true;
  final _formKey = GlobalKey<FormState>();
  final UserModel _user = UserModel(
    email: '',
    fullName: '',
    password: '',
    phoneNumber: '',
    role: MyConstant.guideName,
    profileRef: '',
    tokenDevice: '',
  );
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
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

  void createUser() async {
    late BuildContext dialogContext;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (profileImage != null) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext showContext) {
            dialogContext = context;
            return const PouringHourGlass();
          },
        );
        Map<String, dynamic> response =
            await AuthMethods.register(_user, profileImage);
        Navigator.pop(dialogContext);
        showDialog(
          context: context,
          builder: (BuildContext showContext) =>
              ResponseDialog(response: response),
        );

        _formKey.currentState!.reset();
        setState(() {
          profileImage = null;
          passwordController.clear();
          confirmPassController.clear();
          eyesPassword = true;
          eyesConfirm = true;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext showContext) => const ResponseDialog(
              response: {"status": "199", "message": "กรุณาแนบรูปของไกด์"}),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.colorGuide,
      ),
      body: SafeArea(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  buildNameRoute(width),
                  buildRowImage(width),
                  buildEmail(width),
                  buildPassword(width),
                  buildConfirmPassword(width),
                  buildName(width),
                  buildPhone(width),
                  buildButton(width),
                ],
              ),
            )),
      ),
    );
  }

  Row buildRowImage(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () =>
              dialogCamera(context, getImage, takePhoto, MyConstant.colorGuide),
          child: Container(
            width: width * .7,
            height: 90,
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (profileImage == null)
                  const Icon(
                    Icons.add_a_photo_rounded,
                    size: 40,
                    color: Color.fromRGBO(49, 143, 181, 0.5),
                  )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black54,
                  offset: Offset(0, 1),
                ),
              ],
              image: profileImage != null
                  ? DecorationImage(
                      image: Image.file(profileImage!).image,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Row buildNameRoute(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 40),
          width: width * 1,
          child: const Center(
            child: Text(
              'สร้างบัญชีสำหรับไกด์',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildButton(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * 0.5,
          child: ElevatedButton(
            onPressed: createUser,
            child: const Text(
              'สมัครสมาชิก',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(primary: MyConstant.colorGuide),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: MyConstant.colorGuide,
                blurRadius: 10,
                offset: const Offset(0.2, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildPassword(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * 0.7,
          child: TextFormField(
            controller: passwordController,
            onSaved: (String? password) => _user.password = password!,
            obscureText: eyesPassword,
            validator: (value) {
              if (value!.isEmpty) return 'Please input password';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'รหัสผ่าน :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                suffixIcon: IconButton(
                  icon: eyesPassword
                      ? Icon(Icons.remove_red_eye, color: MyConstant.colorGuide)
                      : Icon(Icons.remove_red_eye_outlined,
                          color: MyConstant.colorGuide),
                  onPressed: () => setState(() {
                    eyesPassword = !eyesPassword;
                  }),
                ),
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: MyConstant.colorGuide,
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
              color: MyConstant.colorGuide,
              fontWeight: FontWeight.w700,
            ),
          ),
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ]),
        )
      ],
    );
  }

  Row buildEmail(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * 0.7,
          child: TextFormField(
            onSaved: (String? email) => _user.email = email!,
            validator: (String? value) {
              RegExp regEmail = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
              bool matches = regEmail.hasMatch(value!);
              if (!matches) return "รูปแบบอีเมลไม่ถูกต้อง";
              if (value.isEmpty) return 'กรุณากรอกอีเมล';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'อีเมล :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: MyConstant.colorGuide,
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
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
          ),
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0.2, 0.2),
            ),
          ]),
        )
      ],
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
            onSaved: (String? phoneNumber) => _user.phoneNumber = phoneNumber!,
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
                  Icons.phone,
                  color: MyConstant.colorGuide,
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
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
          ),
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 0.2),
            ),
          ]),
        )
      ],
    );
  }

  Row buildName(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * 0.7,
          child: TextFormField(
            onSaved: (String? fullName) => _user.fullName = fullName!,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอก ชื่อ-นามสกุล';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ชื่อ - นามสกุล :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(
                  Icons.person,
                  color: MyConstant.colorGuide,
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
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
          ),
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 2),
            ),
          ]),
        )
      ],
    );
  }

  Row buildConfirmPassword(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * 0.7,
          child: TextFormField(
            controller: confirmPassController,
            obscureText: eyesConfirm,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกยืนยันรหัสผ่าน';
              if (value != passwordController.text) {
                return "กรุณายืนยันรหัสให้ตรงกัน";
              }
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ยืนยันรหัสผ่าน :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                suffixIcon: IconButton(
                  icon: eyesConfirm
                      ? Icon(Icons.remove_red_eye, color: MyConstant.colorGuide)
                      : Icon(Icons.remove_red_eye_outlined,
                          color: MyConstant.colorGuide),
                  onPressed: () => setState(() {
                    eyesConfirm = !eyesConfirm;
                  }),
                ),
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: MyConstant.colorGuide,
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
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
          ),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, 8),
              )
            ],
          ),
        )
      ],
    );
  }
}
