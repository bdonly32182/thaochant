import 'package:chanthaburi_app/models/resort/participant.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class Participant extends StatefulWidget {
  Participant({Key? key}) : super(key: key);

  @override
  State<Participant> createState() => _ParticipantState();
}

class _ParticipantState extends State<Participant> {
  int totalRoom = 1;
  int totalAdult = 0;
  int totalYouth = 0;

  _increaseAdult() {
    setState(() {
      totalAdult += 1;
    });
  }

  _decreaseAdult() {
    setState(() {
      totalAdult -= 1;
    });
  }

  _increaseYouth() {
    setState(() {
      totalYouth += 1;
    });
  }

  _decreaseYouth() {
    setState(() {
      totalYouth -= 1;
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Text('จำนวนห้องพักและผู้เข้าพัก'),
        backgroundColor: MyConstant.themeApp,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                buildTotalRoom(width),
                const Divider(),
                buildTotalCustom(
                  width,
                  totalAdult,
                  'ผู้ใหญ่',
                  _increaseAdult,
                  _decreaseAdult,
                ),
                const Divider(),
                buildTotalCustom(
                  width,
                  totalYouth,
                  'เด็ก (5-13 ปี)',
                  _increaseYouth,
                  _decreaseYouth,
                ),
                const Divider(),
              ],
            ),
          ),
          buildButtonOk()
        ],
      ),
    );
  }

  Container buildButtonOk() {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(10),
      height: 50,
      child: ElevatedButton(
        child: const Text(
          'ตกลง',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context).pop(ParticipantModel(totalRoom: totalRoom, totalAdult: totalAdult, totalYouth: totalYouth));
        },
        style: ElevatedButton.styleFrom(primary: MyConstant.themeApp),
      ),
    );
  }

  Row buildTotalCustom(double width, int totalEachType, String typeName,
      Function increaseTotal, Function decreaseTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: width * 0.1,
          child: Text(
            totalEachType.toString(),
            style: const TextStyle(fontSize: 24),
          ),
        ),
        SizedBox(
          width: width * 0.3,
          child: Text(
            typeName,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          width: width * 0.3,
          child: Row(
            children: [
              IconButton(
                onPressed: totalEachType <= 0 ? null : () => decreaseTotal(),
                icon: Icon(
                  Icons.remove_circle_outline_rounded,
                  color: totalEachType <= 0
                      ? Colors.grey[400]
                      : MyConstant.themeApp,
                ),
                iconSize: 40,
                disabledColor: Colors.grey[400],
              ),
              IconButton(
                onPressed: () => increaseTotal(),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: MyConstant.themeApp,
                ),
                iconSize: 40,
              )
            ],
          ),
        ),
      ],
    );
  }

  Row buildTotalRoom(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: width * 0.1,
          child: Text(
            totalRoom.toString(),
            style: const TextStyle(fontSize: 24),
          ),
        ),
        SizedBox(
          width: width * 0.3,
          child: const Text(
            'ห้อง',
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          width: width * 0.3,
          child: Row(
            children: [
              IconButton(
                onPressed: totalRoom <= 1
                    ? null
                    : () {
                        setState(() {
                          totalRoom -= 1;
                        });
                      },
                icon: Icon(
                  Icons.remove_circle_outline_rounded,
                  color:
                      totalRoom <= 1 ? Colors.grey[400] : MyConstant.themeApp,
                ),
                iconSize: 40,
                disabledColor: Colors.grey[400],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    totalRoom += 1;
                  });
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: MyConstant.themeApp,
                ),
                iconSize: 40,
              )
            ],
          ),
        ),
      ],
    );
  }
}
