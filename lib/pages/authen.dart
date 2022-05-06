import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/map/disclosure_location.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:chanthaburi_app/widgets/partner_policy.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Authen extends StatefulWidget {
  Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool eyesPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _onError(response) {
    showDialog(
      context: context,
      builder: (BuildContext showContext) => ResponseDialog(response: response),
    );
    _formKey.currentState!.reset();
  }

  void _onLogin() async {
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
      Map<String, dynamic> response = await AuthMethods.login(
          _emailController.text, _passwordController.text);
      Navigator.pop(dialogContext);
      if (response["status"] == "200") {
        switch (response["role"]) {
          case "admin":
            Navigator.pushNamedAndRemoveUntil(
              context,
              MyConstant.routeAdminService,
              (route) => false,
            );
            break;
          case "seller":
            Navigator.pushNamedAndRemoveUntil(
              context,
              MyConstant.routeSellerService,
              (route) => false,
            );
            break;
          case "buyer":
            Navigator.pushNamedAndRemoveUntil(
              context,
              MyConstant.routeBuyerService,
              (route) => false,
            );
            break;
          case "guide":
            Navigator.pushNamedAndRemoveUntil(
              context,
              MyConstant.routeGuideService,
              (route) => false,
            );
            break;
          default:
            _onError({
              "status": "400",
              "message": "สิทธิ์ในการเข้าถึงไม่ถูกต้อง",
            });
        }
      } else {
        _onError(response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                buildImage(size),
                buildText(
                  "Let's Go Chan",
                  const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                  10,
                ),
                buildText(
                  'Sign to continue',
                  TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                  0,
                ),
                buildEmail(size),
                Stack(
                  children: [
                    buildPassword(size),
                  ],
                ),
                buildButton(size),
                buildCreateAccount(size),
                buildRegisterPartner(size),
                buildPolicyAccessed(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildPolicyAccessed(double size) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: size * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("การเข้าถึงตำแหน่ง ? "),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => DisclosureLocation(
                    goto: () => Navigator.pop(context),
                    message:
                        "แอพพลิเคชันนี้มีการขอเข้าถึงตำแหน่งปัจจุบันของท่าน เพื่อความสะดวก และสร้างความมั่นใจให้กับผู้ซื้อและผู้ขาย",
                  ),
                ),
              );
            },
            child: Text(
              ' คลิ๊ก',
              style: TextStyle(
                color: MyConstant.themeApp,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildRegisterPartner(double size) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: size * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("เข้าร่วมกับเรา ? "),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => PartnerPolicy(),
                ),
              );
            },
            child: Text(
              ' สมัครเป็นพาร์ทเนอร์',
              style: TextStyle(
                color: MyConstant.themeApp,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildCreateAccount(double size) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: size * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("ยังไม่มีบัญชีผู้ใช้งาน ? "),
          InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                MyConstant.routeCreateAccount,
                (route) => false,
              );
            },
            child: Text(
              ' สร้างบัญชีผู้ใช้งานใหม่',
              style: TextStyle(color: MyConstant.themeApp),
            ),
          )
        ],
      ),
    );
  }

  Row buildButton(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 40),
          width: size * 0.5,
          child: ElevatedButton(
            onPressed: _onLogin,
            child: const Text(
              'เข้าสู่ระบบ',
              style: TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(primary: MyConstant.themeApp),
          ),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: MyConstant.themeApp,
              blurRadius: 10,
              offset: const Offset(0.2, 0),
            ),
          ]),
        )
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: size * 0.7,
          child: TextFormField(
            controller: _passwordController,
            obscureText: eyesPassword,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกรหัสผ่าน';
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

  Row buildEmail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 40),
          width: size * 0.7,
          child: TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกอีเมล';
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
}

Row buildText(String title, TextStyle style, double margin) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: margin),
        child: Text(title, style: style),
      )
    ],
  );
}

Container buildImage(double size) {
  return Container(
    margin: const EdgeInsets.only(top: 90),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size * 0.3,
          child: ShowImage(
            pathImage: MyConstant.iconUser,
          ),
        )
      ],
    ),
  );
}
