import 'package:chanthaburi_app/models/resort/participant.dart';
import 'package:chanthaburi_app/pages/resort/participant.dart';
import 'package:chanthaburi_app/pages/resort/shopping_resort.dart';
import 'package:chanthaburi_app/provider/participant_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/booking_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterRoom extends StatefulWidget {
  FilterRoom({Key? key}) : super(key: key);

  @override
  State<FilterRoom> createState() => _FilterRoomState();
}

class _FilterRoomState extends State<FilterRoom> {
  int? checkInDate;
  int? checkoutDate;
  int totalRoom = 0;
  int totalAdult = 0;
  int totalYouth = 0;
  selectParticipant() async {
    ParticipantModel participatn = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Participant(),
      ),
    );
    setState(() {
      totalAdult = participatn.totalAdult;
      totalRoom = participatn.totalRoom;
      totalYouth = participatn.totalYouth;
    });
  }

  onSearch() async {
    if (checkInDate != null &&
        checkoutDate != null &&
        totalAdult != 0 &&
        totalRoom != 0) {
      QuerySnapshot<Object?> checkBooking =
          await BookingCollection.checkBookingUser(
              AuthMethods.currentUser(), checkInDate!, checkoutDate!);
      if (checkBooking.docs.isEmpty) {
        var participantProvider =
            Provider.of<ParticipantProvider>(context, listen: false);
        participantProvider.setPartipant(
          totalAdult,
          totalRoom,
          totalYouth,
          checkInDate!,
          checkoutDate!,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => ShoppingResort(
              checkIn: checkInDate!,
              checkOut: checkoutDate!,
              totalParticipant: totalAdult + totalYouth,
              totalRoom: totalRoom,
            ),
          ),
        );
      } else {
        dialogAlert(context, "แจ้งเตือน", "คุณมีออร์เดอร์วันที่นี้แล้ว");
      }
    } else {
      dialogAlert(context, "แจ้งเตือน", "กรุณาเลือกข้อมูลให้ครบ");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text('ที่พักทั้งหมด'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildDatePicker(width),
            Container(
              width: width * 0.85,
              height: 50,
              margin: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: selectParticipant,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.person_outline),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        totalRoom.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyConstant.themeApp,
                        ),
                      ),
                    ),
                    const Text('ห้อง'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        totalAdult.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyConstant.themeApp,
                        ),
                      ),
                    ),
                    const Text('ผู้ใหญ่'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        totalYouth.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyConstant.themeApp,
                        ),
                      ),
                    ),
                    const Text('เด็ก'),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            buildButtonSearch(context)
          ],
        ),
      ),
    );
  }

  Container buildButtonSearch(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(15),
      child: ElevatedButton(
        child: const Text(
          'ค้นหาที่พัก',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: onSearch,
        style: ElevatedButton.styleFrom(primary: MyConstant.themeApp),
      ),
    );
  }

  Row buildDatePicker(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, right: 10),
          width: width * .4,
          child: DateTimePicker(
            dateHintText: 'วันที่เช็คอิน',
            firstDate: DateTime(2022),
            lastDate: DateTime(2100),
            onChanged: (val) {
              setState(() {
                checkInDate = DateTime.parse(val).millisecondsSinceEpoch;
              });
            },
            style: TextStyle(
              color: MyConstant.themeApp,
              fontWeight: FontWeight.w700,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, left: 10),
          width: width * .4,
          child: DateTimePicker(
            dateHintText: 'วันที่เช็คเอาท์',
            firstDate: DateTime(2022),
            lastDate: DateTime(2100),
            onChanged: (val) {
              setState(() {
                checkoutDate = DateTime.parse(val).millisecondsSinceEpoch;
              });
            },
            style: TextStyle(
              color: MyConstant.themeApp,
              fontWeight: FontWeight.w700,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}
