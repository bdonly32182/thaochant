import 'dart:io';

import 'package:chanthaburi_app/resources/firestore/event_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EventList extends StatefulWidget {
  EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  getImage() async {
    File? image = await PickerImage.getImage();
    if (image != null) {
      late BuildContext dialogContext;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          dialogContext = context;
          return const PouringHourGlass();
        },
      );
      await EventCollection.createEvent(image);
      Navigator.pop(dialogContext);
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

  onDeleteEvent(
      BuildContext dialogContext, String docId, String imageURL) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    await EventCollection.deleteEvenet(docId, imageURL);
    Navigator.pop(dialogContext);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("กิจกรรมทั้งหมด"),
        backgroundColor: MyConstant.themeApp,
      ),
      body: StreamBuilder(
        stream: EventCollection.events(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PouringHourGlass();
          }
          if (snapshot.data!.docs.isEmpty) {
            return buildAddEvent(width, snapshot.data!.docs.length);
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          height: 160,
                          width: width * 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ShowImageNetwork(
                              pathImage: snapshot.data!.docs[index]["eventURL"],
                              colorImageBlank: MyConstant.themeApp,
                            ),
                          ),
                        ),
                        Container(
                          child: IconButton(
                            onPressed: () => dialogDeleteEvent(
                              context,
                              snapshot.data!.docs[index].id,
                              snapshot.data!.docs[index]["eventURL"],
                              onDeleteEvent,
                            ),
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                          ),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                buildAddEvent(width, snapshot.data!.docs.length),
              ],
            ),
          );
        },
      ),
    );
  }

  InkWell buildAddEvent(double width, int totalEvent) {
    return InkWell(
      onTap: () {
        if (totalEvent < 6) {
          getImage();
        } else {
          dialogAlert(context, "ประกาศ", "กิจกรรมเต็มแล้ว (6 กิจกรรม)");
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 25.0),
            width: width * 0.6,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  color: MyConstant.themeApp,
                  size: 60,
                ),
                const Text(
                  "เพิ่มกิจกรรม",
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black54,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
