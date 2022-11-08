import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class SequenceQuestion extends StatelessWidget {
  final Function onChange;
  final num selected;
  const SequenceQuestion(
      {Key? key, required this.onChange, required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> choices = [
      {"title": "น้อยกว่า 1 ชั่วโมง", "value": 0.5},
      {"title": "2 ชั่วโมง", "value": 2},
      {"title": "3 ชั่วโมง", "value": 3},
      {"title": "มากกว่า 3 ชั่วโมง", "value": 4},
    ];
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: height * 0.1),
          height: height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.white60,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ระยะเวลาที่ท่านใช้ในการเดินทางในครั้งนี้',
                  style: TextStyle(
                    color: MyConstant.themeApp,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: choices.length,
                  itemBuilder: (context, index) => Card(
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
                      title: Text(choices[index]["title"]),
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          if (checked) {
                            onChange(choices[index]["value"]);
                          } else {
                            onChange(0);
                          }
                        }
                      },
                      value: selected == choices[index]["value"],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
