import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class BetweenAge extends StatelessWidget {
  final Function onChange;
  final String selected;
  const BetweenAge({
    Key? key,
    required this.onChange,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> choicesAge = [
      {
        "title": "ต่ำกว่าหรือเท่ากับ 20 ปี",
        "value": "ต่ำกว่าหรือเท่ากับ 20 ปี"
      },
      {"title": "21-30 ปี", "value": "21-30 ปี"},
      {"title": "31-40 ปี", "value": "31-40 ปี"},
      {"title": "41-50 ปี", "value": "41-50 ปี"},
      {"title": "มากกว่า 50 ปี", "value": "มากกว่า 50 ปี"},
    ];

    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: height * 0.1),
          decoration: const BoxDecoration(
            color: Colors.white60,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ช่วงอายุ',
                  style: TextStyle(
                    color: MyConstant.themeApp,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  softWrap: true,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: choicesAge.length,
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
                      title: Text(choicesAge[index]["title"]),
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          if (checked) {
                            onChange(choicesAge[index]["value"]);
                          } else {
                            onChange("");
                          }
                        }
                      },
                      value: selected == choicesAge[index]["value"],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
