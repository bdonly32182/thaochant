import 'package:chanthaburi_app/models/events/event_model.dart';
import 'package:chanthaburi_app/pages/events/create_event.dart';
import 'package:chanthaburi_app/resources/firestore/event_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
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
        builder: (context, AsyncSnapshot<QuerySnapshot<EventModel>> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PouringHourGlass();
          }
          if (snapshot.data!.docs.isEmpty) {
            return buildAddEvent(width);
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    EventModel eventData = snapshot.data!.docs[index].data();
                    String eventId = snapshot.data!.docs[index].id;
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => CreateEvent(
                            eventModelForEdit: eventData,
                            eventId: eventId,
                          ),
                        ),
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            height: 160,
                            width: width * 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ShowImageNetwork(
                                pathImage: eventData.url,
                                colorImageBlank: MyConstant.themeApp,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.all(5),
                            width: width * 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                eventData.eventName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                buildAddEvent(width),
              ],
            ),
          );
        },
      ),
    );
  }

  InkWell buildAddEvent(double width) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => const CreateEvent(),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 25.0, top: 10),
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
