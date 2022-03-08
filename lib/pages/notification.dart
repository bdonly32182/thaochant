import 'package:chanthaburi_app/resources/firestore/notification_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';

class NotificationRecipient extends StatefulWidget {
  String recipientId;
  Color theme;
  NotificationRecipient(
      {Key? key, required this.recipientId, required this.theme})
      : super(key: key);

  @override
  State<NotificationRecipient> createState() => _NotificationRecipientState();
}

class _NotificationRecipientState extends State<NotificationRecipient> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: widget.theme,
        title: const Center(child: Text('ข้อความแจ้งเตือน')),
      ),
      body: StreamBuilder(
        stream: NotificationCollection.notifications(widget.recipientId),
        builder: (snapContext, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: ShowDataEmpty(),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext listContext, int index) {
                Timestamp timestamp = snapshot.data!.docs[index]['timeStamp'];
                DateTime dateTime = timestamp.toDate();
                return Container(
                  margin: const EdgeInsets.all(2.0),
                  width: width * 1,
                  height: height * 0.14,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        width: width * 0.25,
                        child: ShowImage(pathImage: MyConstant.appLogo),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width * 0.5,
                            child: Text(
                              snapshot.data!.docs[index]['title'],
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.5,
                            child: Text(
                              snapshot.data!.docs[index]['message'],
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4.0),
                            width: width * 0.5,
                            child: Text(
                              dateTime.toIso8601String(),
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: width * 0.2,
                        child: IconButton(
                          onPressed: () async {
                            Map<String, dynamic> response =
                                await NotificationCollection.deleteNotification(
                              snapshot.data!.docs[index].id,
                            );
                            showDialog(
                              context: context,
                              builder: (BuildContext showContext) =>
                                  ResponseDialog(response: response),
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: const BoxDecoration(color: Colors.white70),
                );
              },
            );
          }
          return const PouringHourGlass();
        },
      ),
    );
  }
}
