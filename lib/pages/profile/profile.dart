import 'dart:developer';

import 'package:chanthaburi_app/pages/profile/component/content_profile.dart';
import 'package:chanthaburi_app/pages/profile/component/footer_logout.dart';
import 'package:chanthaburi_app/pages/profile/component/header_profile.dart';
import 'package:chanthaburi_app/pages/profile/edit_profile.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/bad_request_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Color theme;
  Profile({Key? key, required this.theme}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userId = AuthMethods.currentUser();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: widget.theme,
          title: const Center(child: Text('บัญชีของฉัน')),
        ),
        backgroundColor: MyConstant.backgroudApp,
        body: userId.isEmpty
            ? login(width, context)
            : FutureBuilder<DocumentSnapshot?>(
                future: UserCollection.profile(),
                builder: (BuildContext profileBuilder,
                    AsyncSnapshot<DocumentSnapshot?> snapshortProfile) {
                  if (snapshortProfile.hasError) {
                    return const BadRequestError();
                  }

                  if (snapshortProfile.hasData &&
                      !snapshortProfile.data!.exists) {
                    return const ShowDataEmpty();
                  }
                  if (snapshortProfile.data == null) {
                    return login(width,context);
                  }
                  if (snapshortProfile.connectionState ==
                      ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshortProfile.data!.data() as Map<String, dynamic>;
                    return SafeArea(
                      child: Column(
                        children: [
                          HeaderProfile(
                            profileRef: data["profileRef"],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          ContentProfile(text: data["fullName"]),
                          ContentProfile(text: data["phoneNumber"]),
                          ContentProfile(text: data["email"]),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            width: width * 0.4,
                            child: ElevatedButton(
                              child: Row(
                                children: [
                                  Text(
                                    "แก้ไขข้อมูลส่วนตัว",
                                    style: TextStyle(color: widget.theme),
                                  ),
                                ],
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => EditProfile(
                                    fullName: data["fullName"],
                                    phoneNumber: data["phoneNumber"],
                                    profileRef: data["profileRef"],
                                    theme: widget.theme,
                                    docId: snapshortProfile.data!.id,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                side: BorderSide(
                                  color: widget.theme,
                                ),
                              ),
                            ),
                          ),
                          FooterLogout(theme: widget.theme),
                        ],
                      ),
                    );
                  }

                  return const PouringHourGlass();
                },
              ));
  }

  Column login(double width, BuildContext context) {
    return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: width * 0.26,
                    child: ElevatedButton(
                      child: Row(
                        children: [
                          Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(color: widget.theme),
                          ),
                        ],
                      ),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/authen', (route) => false),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        side: BorderSide(
                          color: widget.theme,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
  }
}
