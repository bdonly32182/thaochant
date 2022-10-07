import 'package:chanthaburi_app/pages/authen.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: MyConstant.backgroudApp,
      // ),
      backgroundColor: MyConstant.backgroudApp,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  width: width * 1,
                  height: height * 0.45,
                  child: ShowImage(pathImage: MyConstant.resetPasswordImage),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Forgot",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Password ?",
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "don't worry! it happens.  Please enter your email",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: width * 0.9,
                    child: TextFormField(
                      controller: emailController,
                      validator: (String? value) {
                        RegExp regEmail =
                            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
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
                          color: MyConstant.themeApp,
                          fontWeight: FontWeight.w700),
                    ),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0.2, 0.2),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 14.0),
                    width: width * 0.9,
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.security),
                          Text("  Reset Password"),
                        ],
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await AuthMethods.resetPassword(
                                emailController.text);
                            dialogAlert(
                              context,
                              "แจ้งเตือน",
                              "รีเซ็ทรหัสผ่านเรียบร้อยกรุณาเช็คอีเมลของท่าน",
                            );
                          } on FirebaseAuthException catch (e) {
                            dialogAlert(context, "แจ้งเตือน", e.code);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: MyConstant.themeApp),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "กลับสู่หน้าเข้าสู่ระบบ ? ",
                        style: TextStyle(
                          color: MyConstant.themeApp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
