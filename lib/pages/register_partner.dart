import 'dart:io';

import 'package:chanthaburi_app/models/googlemap/google_map.dart';
import 'package:chanthaburi_app/models/user/partner.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/map/geolocation.dart';
import 'package:chanthaburi_app/utils/map/google_map_fluter.dart';
import 'package:chanthaburi_app/utils/map/show_map.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterPartner extends StatefulWidget {
  RegisterPartner({Key? key}) : super(key: key);

  @override
  State<RegisterPartner> createState() => _RegisterPartnerState();
}

class _RegisterPartnerState extends State<RegisterPartner> {
  final _formKey = GlobalKey<FormState>();
  final PartnerModel _partnerModel = PartnerModel(
    fullName: '',
    email: '',
    phoneNumber: '',
    password: '',
    role: MyConstant.sellerName,
    profileRef: '',
    verifyRef: '',
    lat: 0,
    lng: 0,
    address: '',
    isAccept: false,
    tokenDevice: '',
  );
  File? profileImage;
  File? verifyImage;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  bool eyesPassword = true;
  bool eyesConfirm = true;
  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  void checkPermission() async {
    try {
      Position positionBuyer = await determinePosition();
      setState(() {
        _partnerModel.lat = positionBuyer.latitude;
        _partnerModel.lng = positionBuyer.longitude;
      });
    } catch (e) {
      PermissionStatus locationStatus = await Permission.location.status;
      if (locationStatus.isPermanentlyDenied || locationStatus.isDenied) {
        alertService(
          context,
          'ไม่อนุญาติแชร์ Location',
          'โปรดแชร์ Location',
        );
      }
    }
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

  void getVerifyImage() async {
    File? _imagePath = await PickerImage.getImage();
    if (_imagePath != null) {
      setState(() {
        verifyImage = _imagePath;
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

  takePhotoVerify() async {
    File? takePhoto = await PickerImage.takePhoto();
    if (takePhoto != null) {
      setState(() {
        verifyImage = takePhoto;
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

  void createPartner() async {
    late BuildContext dialogContext;
    if (_formKey.currentState!.validate()) {
      if (profileImage != null) {
        _formKey.currentState!.save();
        {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext showContext) {
              dialogContext = context;
              return const PouringHourGlass();
            },
          );
          Map<String, dynamic> response = await AuthMethods.registerPartner(
              _partnerModel, profileImage, verifyImage);
          Navigator.pop(dialogContext);
          showDialog(
            context: context,
            builder: (BuildContext showContext) =>
                ResponseDialog(response: response),
          );

          _formKey.currentState!.reset();
          setState(() {
            profileImage = null;
            verifyImage = null;
            passwordController.clear();
            confirmPassController.clear();
            eyesPassword = true;
            eyesConfirm = true;
          });
        }
      } else {
        dialogAlert(context, "แจ้งเตือน", "แนบรูปถ่ายของท่าน");
      }
    } else {
      dialogAlert(context, "แจ้งเตือน", "กรุณากรอกข้อมูลให้ครบ");
    }
  }

  _navigationGoogleMap(BuildContext context) async {
    try {
      final GoogleMapModel _result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) => SelectLocation(
            initLat: _partnerModel.lat,
            initLng: _partnerModel.lng,
          ),
        ),
      );
      setState(() {
        _partnerModel.lat = _result.latitude!;
        _partnerModel.lng = _result.longitude!;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(children: [
                  buildNameRoute(width),
                  buildRowImage(width),
                  buildEmail(width),
                  buildPassword(width),
                  buildConfirmPassword(width),
                  buildName(width),
                  buildAddress(width),
                  buildPhone(width),
                  buildVerifyImage(width),
                  buildShowmap(width, height, context),
                  buildButton(width),
                  buildLogin(width),
                ]),
              ),
            )),
      ),
    );
  }

  Row buildAddress(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * 0.7,
          child: TextFormField(
            maxLines: 4,
            onSaved: (String? address) => _partnerModel.address = address!,
            validator: (String? value) {
              if (value!.isEmpty) return 'กรุณากรอกรายละเอียดที่อยู่';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'รายละเอียดที่อยู่ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(
                  Icons.location_on,
                  color: MyConstant.themeApp,
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
              color: MyConstant.themeApp,
              fontWeight: FontWeight.w700,
            ),
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

  Container buildShowmap(double width, double height, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: width * 1,
      height: height * 0.3,
      child: _partnerModel.lat != 0 && _partnerModel.lng != 0
          ? InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _navigationGoogleMap(context);
              },
              child: Stack(
                children: [
                  SizedBox(
                    width: width * 1,
                    height: height * 0.3,
                    child: ShowMap(
                      lat: _partnerModel.lat,
                      lng: _partnerModel.lng,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.4,
                        height: 40,
                        child: const Text(
                          "เลือกตำแหน่งธุรกิจ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyConstant.themeApp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const PouringHourGlass(),
    );
  }

  Row buildVerifyImage(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Platform.isIOS
          ? []
          : [
              InkWell(
                onTap: () => dialogCamera(context, getVerifyImage,
                    takePhotoVerify, MyConstant.themeApp),
                child: Container(
                  width: width * .7,
                  height: 160,
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (verifyImage == null)
                        const Icon(
                          Icons.add_a_photo_rounded,
                          size: 40,
                          color: Color.fromRGBO(41, 187, 137, 0.5),
                        ),
                      const Text(
                        'แนบรูปบัตรประชาชน',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black54,
                        offset: Offset(0, 1),
                      ),
                    ],
                    image: verifyImage != null
                        ? DecorationImage(
                            image: Image.file(verifyImage!).image,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
              ),
            ],
    );
  }

  Row buildRowImage(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () =>
              dialogCamera(context, getImage, takePhoto, MyConstant.themeApp),
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
                    color: Color.fromRGBO(41, 187, 137, 0.5),
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
              'สมัครพาร์ทเนอร์',
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

  Container buildLogin(double width) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 15),
      width: width * 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('มีบัญชีผู้ใช้งานอยู่แล้ว ? '),
          InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, MyConstant.routeAuthen, (route) => false);
            },
            child: Text(
              ' กลับสู่หน้าล็อกอิน ',
              style: TextStyle(color: MyConstant.themeApp),
            ),
          ),
        ],
      ),
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
            onPressed: createPartner,
            child: const Text(
              'สมัครพาร์ทเนอร์',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(primary: MyConstant.themeApp),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: MyConstant.themeApp,
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
            onSaved: (String? password) => _partnerModel.password = password!,
            obscureText: eyesPassword,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกรหัสผ่าน';
              if (value.length < 6) return 'กรุณากรอกรหัสผ่านอย่างน้อย 6 ตัว';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'รหัสผ่าน :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                suffixIcon: IconButton(
                  icon: eyesPassword
                      ? Icon(Icons.remove_red_eye, color: MyConstant.themeApp)
                      : Icon(Icons.remove_red_eye_outlined,
                          color: MyConstant.themeApp),
                  onPressed: () => setState(() {
                    eyesPassword = !eyesPassword;
                  }),
                ),
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: MyConstant.themeApp,
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
              color: MyConstant.themeApp,
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
            onSaved: (String? email) => _partnerModel.email = email!,
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
                  color: MyConstant.themeApp,
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
                color: MyConstant.themeApp, fontWeight: FontWeight.w700),
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
            onSaved: (String? phoneNumber) =>
                _partnerModel.phoneNumber = phoneNumber!,
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
                  color: MyConstant.themeApp,
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
                color: MyConstant.themeApp, fontWeight: FontWeight.w700),
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
            onSaved: (String? fullName) => _partnerModel.fullName = fullName!,
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
                  color: MyConstant.themeApp,
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
                color: MyConstant.themeApp, fontWeight: FontWeight.w700),
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
                      ? Icon(Icons.remove_red_eye, color: MyConstant.themeApp)
                      : Icon(Icons.remove_red_eye_outlined,
                          color: MyConstant.themeApp),
                  onPressed: () => setState(() {
                    eyesConfirm = !eyesConfirm;
                  }),
                ),
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: MyConstant.themeApp,
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
                color: MyConstant.themeApp, fontWeight: FontWeight.w700),
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
