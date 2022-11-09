import 'package:chanthaburi_app/models/events/event_model.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventQuestion extends StatelessWidget {
  final List<EventModel> selects;
  final Function onSelected;
  final Function onRemove;
  final QuerySnapshot<EventModel> events;
  final num usageTime;
  const EventQuestion({
    Key? key,
    required this.events,
    required this.onRemove,
    required this.onSelected,
    required this.selects,
    required this.usageTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    List<QueryDocumentSnapshot<EventModel>> filterEvents = events.docs
        .where(
          (element) => element.data().usageTime <= usageTime,
        )
        .toList();
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: height * 0.1),
          decoration: const BoxDecoration(
            color: Colors.white60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'ท่านสนใจซื้อสินค้าอะไรจากชุมชนหลังวัดโรมัน บ้านท่าเรือจ้าง และริมน้ำจันทบูร นี้',
                  style: TextStyle(
                    color: MyConstant.themeApp,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  softWrap: true,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '* เลือกได้มากกว่า 1 ข้อ',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: filterEvents.length,
                itemBuilder: (context, index) {
                  EventModel event = filterEvents[index].data();
                  String id = filterEvents[index].id;
                  bool isSelected = selects
                      .where((select) =>
                          select.url == event.url &&
                          select.eventName == event.eventName)
                      .isNotEmpty;
                  return Card(
                    margin: const EdgeInsets.only(
                      left: 18.0,
                      right: 18.0,
                      top: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CheckboxListTile(
                      activeColor: MyConstant.themeApp,
                      title: Text(event.eventName),
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          if (checked) {
                            onSelected(event, id);
                          } else {
                            onRemove(event, id);
                          }
                        }
                      },
                      value: isSelected,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
