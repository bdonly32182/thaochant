import 'dart:developer';

import 'package:chanthaburi_app/models/business/time_turn_on_of.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:flutter/material.dart';

class SettingTime extends StatefulWidget {
  final List<TimeTurnOnOfModel> times;
  final String businessId;
  final String typeBusiness;
  const SettingTime({
    Key? key,
    required this.times,
    required this.businessId,
    required this.typeBusiness,
  }) : super(key: key);

  @override
  State<SettingTime> createState() => _SettingTimeState();
}

class _SettingTimeState extends State<SettingTime> {
  List<TimeTurnOnOfModel> initTimes = [
    TimeTurnOnOfModel(
      day: "จ.",
      timeOn: "8:30",
      timeOf: "16:30",
    ),
    TimeTurnOnOfModel(
      day: "อ.",
      timeOn: "8:30",
      timeOf: "16:30",
    ),
    TimeTurnOnOfModel(
      day: "พ.",
      timeOn: "8:30",
      timeOf: "16:30",
    ),
    TimeTurnOnOfModel(
      day: "พฤ.",
      timeOn: "8:30",
      timeOf: "16:30",
    ),
    TimeTurnOnOfModel(
      day: "ศ.",
      timeOn: "8:30",
      timeOf: "16:30",
    ),
    TimeTurnOnOfModel(
      day: "ส.",
      timeOn: "8:30",
      timeOf: "16:30",
    ),
    TimeTurnOnOfModel(
      day: "อา.",
      timeOn: "8:30",
      timeOf: "16:30",
    ),
  ];
  @override
  void initState() {
    super.initState();
    if (widget.times.isNotEmpty) {
      setState(() {
        initTimes = widget.times;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  onChangeTimeOn(String time, index) {
    setState(() {
      initTimes[index].timeOn = time;
    });
  }

  onChangeTimeOf(String time, index) {
    setState(() {
      initTimes[index].timeOf = time;
    });
  }

  onSubmit(List<TimeTurnOnOfModel> times) async {
    List<Map<String, dynamic>> timesMap = [];
    for (var i = 0; i < times.length; i++) {
      timesMap.add(times[i].toMap());
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic>? response;
    if (widget.typeBusiness == MyConstant.foodCollection) {
      response = await RestaurantCollection.changeTimeRestaurant(
        timesMap,
        widget.businessId,
      );
    }
    if (widget.typeBusiness == MyConstant.productOtopCollection) {
      response = await OtopCollection.changeTimeOtop(
        timesMap,
        widget.businessId,
      );
    }
    if (widget.typeBusiness == MyConstant.roomCollection) {
      response = await ResortCollection.changeTimeResort(
        timesMap,
        widget.businessId,
      );
    }
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext showContext) =>
          ResponseDialog(response: response!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่าเวลาธุรกิจ'),
        backgroundColor: MyConstant.colorStore,
      ),
      backgroundColor: MyConstant.backgroudApp,
      body: SafeArea(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: initTimes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(initTimes[index].day),
                        ElevatedButton(
                          onPressed: () async {
                            List<String> splitTime =
                                initTimes[index].timeOn.split(':');
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: int.parse(splitTime[0]),
                                minute: int.parse(
                                  splitTime[1],
                                ),
                              ),
                            );
                            if (time != null) {
                              onChangeTimeOn(
                                  '${time.hour}:${time.minute}', index);
                              log(initTimes[index].timeOn);
                            }
                          },
                          child: Text(
                            initTimes[index].timeOn,
                            style: TextStyle(color: MyConstant.colorStore),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            List<String> splitTime =
                                initTimes[index].timeOf.split(':');
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: int.parse(splitTime[0]),
                                minute: int.parse(
                                  splitTime[1],
                                ),
                              ),
                            );
                            if (time != null) {
                              onChangeTimeOf(
                                  '${time.hour}:${time.minute}', index);
                              log(initTimes[index].timeOf);
                            }
                          },
                          child: Text(
                            initTimes[index].timeOf,
                            style: TextStyle(color: MyConstant.colorStore),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () => onSubmit(initTimes),
              child: const Text('บันทึก'),
              style: ElevatedButton.styleFrom(primary: MyConstant.colorStore),
            ),
          ],
        ),
      ),
    );
  }
}
