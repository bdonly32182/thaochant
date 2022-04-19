import 'package:flutter/material.dart';
class EventList extends StatefulWidget {
  EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("events list"),);
  }
}