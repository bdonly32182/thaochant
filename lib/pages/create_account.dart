import 'dart:io';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:path/path.dart';
import 'package:chanthaburi_app/models/user/user.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  File? profileImage;
  bool focusEmail = false;
  bool focusPhone = false;
  bool focusName = false;
  bool focusPassword = false;
  bool focusConfirmPass = false;
  bool eyesPassword = true;
  bool eyesConfirm = true;
  bool isPartner = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final UserModel _user = UserModel(
    email: '',
    fullName: '',
    password: '',
    phoneNumber: '',
    role: 'buyer',
    profileRef: '',
  );
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  void getImage() async {
    try {
      File? _imagePath = await PickerImage.getImage();
      setState(() {
        profileImage = _imagePath;
      });
    } catch (e) {
      print("get image error");
    }
  }

  void createUser() async {
    late BuildContext dialogContext;
    late String fileName;
    if (profileImage != null) {
      fileName = basename(profileImage!.path);
      _user.profileRef = "images/register/$fileName";
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        barrierDismissible: false,
        context: this.context,
        builder: (BuildContext showContext) {
          dialogContext = this.context;
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic> response = await AuthMethods.register(
        _user,
        isPartner,
      );

      if (profileImage != null && response["status"] == "200") {
        fileName = basename(profileImage!.path);
        StorageFirebase.PutFileToStorage(
            "images/register/$fileName", profileImage!);
      }
      Navigator.pop(dialogContext);
      showDialog(
        context: this.context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );

      _formKey.currentState!.reset();
      setState(() {
        profileImage = null;
        passwordController.clear();
        confirmPassController.clear();
        focusEmail = false;
        focusPhone = false;
        focusName = false;
        eyesPassword = true;
        eyesConfirm = true;
        focusPassword = false;
        focusConfirmPass = false;
        isPartner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  buildCheckbokPartner(width),
                  buildButton(width),
                  buildLogin(width),
                ],
              ),
            )),
      ),
    );
  }

  Container buildCheckbokPartner(double width) {
    return Container(
      margin: EdgeInsets.only(left: width * 0.12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            activeColor: MyConstant.themeApp,
            value: isPartner,
            onChanged: (bool? value) {
              if (value!) {
                _user.role = MyConstant.sellerName;
              }
              setState(() {
                isPartner = value;
              });
            },
          ),
          const Text(
            "ต้องการเป็นพาร์ทเนอร์หรือไม่",
          ),
        ],
      ),
    );
  }

  Row buildRowImage(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: getImage,
          child: Container(
            width: width * .7,
            height: 90,
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (profileImage == null)
                  Icon(
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
          margin: EdgeInsets.only(top: 40),
          width: width * 0.5,
          child: const Text(
            'สร้างบัญชีผู้ใช้งาน',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  Container buildLogin(double width) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 15),
      width: width * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('มีบัญชีผู้ใช้งานอยู่แล้ว ? '),
          InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  this.context, MyConstant.routeAuthen, (route) => false);
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
            onPressed: createUser,
            child: const Text(
              'สมัครสมาชิก',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(primary: MyConstant.themeApp),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: focusPassword &&
                        focusEmail &&
                        focusPhone &&
                        focusName &&
                        focusConfirmPass
                    ? Colors.tealAccent.shade100
                    : Colors.white,
                blurRadius: 14,
                offset: const Offset(0, 0.5),
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
            onChanged: (text) => setState(() {
              if (text.isEmpty) {
                focusPassword = false;
              } else {
                focusPassword = true;
              }
            }),
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
                      ? Icon(Icons.remove_red_eye,
                          color:
                              focusPassword ? MyConstant.themeApp : Colors.grey)
                      : Icon(Icons.remove_red_eye_outlined,
                          color: focusPassword
                              ? MyConstant.themeApp
                              : Colors.grey),
                  onPressed: () => setState(() {
                    eyesPassword = !eyesPassword;
                  }),
                ),
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: focusPassword ? MyConstant.themeApp : Colors.grey,
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
              fontWeight: focusPassword ? FontWeight.w900 : FontWeight.normal,
            ),
          ),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: focusPassword ? Colors.black26 : Colors.white,
              blurRadius: 15,
              offset: const Offset(0, 8),
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
            onChanged: (text) => setState(() {
              if (text.isEmpty) {
                focusEmail = false;
              } else {
                focusEmail = true;
              }
            }),
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
                  color: focusEmail ? MyConstant.themeApp : Colors.grey,
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
                fontWeight: focusEmail ? FontWeight.w900 : FontWeight.normal),
          ),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: focusEmail ? Colors.black26 : Colors.white,
              blurRadius: 15,
              offset: const Offset(0.2, 0.2),
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
            onChanged: (text) => setState(() {
              if (text.isEmpty) {
                focusPhone = false;
              } else {
                focusPhone = true;
              }
            }),
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
                  color: focusPhone ? MyConstant.themeApp : Colors.grey,
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
                fontWeight: focusPhone ? FontWeight.w900 : FontWeight.normal),
          ),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: focusPhone ? Colors.black26 : Colors.white,
              blurRadius: 15,
              offset: const Offset(0, 0.2),
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
          margin: EdgeInsets.only(top: 20),
          width: width * 0.7,
          child: TextFormField(
            onSaved: (String? fullName) => _user.fullName = fullName!,
            onChanged: (text) => setState(() {
              if (text.isEmpty) {
                focusName = false;
              } else {
                focusName = true;
              }
            }),
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
                  color: focusName ? MyConstant.themeApp : Colors.grey,
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
                fontWeight: focusName ? FontWeight.w900 : FontWeight.normal),
          ),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: focusName ? Colors.black26 : Colors.white,
              blurRadius: 15,
              offset: const Offset(0, 2),
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
            onChanged: (text) => setState(() {
              if (text.isEmpty) {
                focusConfirmPass = false;
              } else {
                focusConfirmPass = true;
              }
            }),
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
                      ? Icon(Icons.remove_red_eye,
                          color: focusConfirmPass
                              ? MyConstant.themeApp
                              : Colors.grey)
                      : Icon(Icons.remove_red_eye_outlined,
                          color: focusConfirmPass
                              ? MyConstant.themeApp
                              : Colors.grey),
                  onPressed: () => setState(() {
                    eyesConfirm = !eyesConfirm;
                  }),
                ),
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: focusConfirmPass ? MyConstant.themeApp : Colors.grey,
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
                fontWeight:
                    focusConfirmPass ? FontWeight.w900 : FontWeight.normal),
          ),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: focusConfirmPass ? Colors.black26 : Colors.white,
                blurRadius: 15,
                offset: const Offset(0, 8))
          ]),
        )
      ],
    );
  }
}
