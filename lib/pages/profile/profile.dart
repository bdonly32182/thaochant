import 'package:chanthaburi_app/pages/profile/component/content_profile.dart';
import 'package:chanthaburi_app/pages/profile/component/footer_logout.dart';
import 'package:chanthaburi_app/pages/profile/component/header_profile.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: widget.theme,
          title: const Center(child: Text('บัญชีของฉัน')),
        ),
        backgroundColor: MyConstant.backgroudApp,
        body: FutureBuilder<DocumentSnapshot>(
          future: UserCollection.profile(),
          builder: (BuildContext profileBuilder,
              AsyncSnapshot<DocumentSnapshot> snapshortProfile) {
            if (snapshortProfile.hasError) {
              return const BadRequestError();
            }

            if (snapshortProfile.hasData && !snapshortProfile.data!.exists) {
              return const ShowDataEmpty();
            }

            if (snapshortProfile.connectionState == ConnectionState.done) {
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
                    FooterLogout(theme: widget.theme),
                  ],
                ),
              );
            }

            return const PouringHourGlass();
          },
        ));
  }
}
