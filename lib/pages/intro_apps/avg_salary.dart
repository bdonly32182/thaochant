import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class AvgSalary extends StatelessWidget {
  final Function onChange;
  final String selected;
  const AvgSalary({
    Key? key,
    required this.onChange,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> choicesAvgSalary = [
      {
        "title": "ต่ำกว่าหรือเท่ากับ 10,000 บาท",
        "value": "ต่ำกว่าหรือเท่ากับ 10,000 บาท"
      },
      {"title": "10,001-30,000 บาท", "value": "10,001-30,000 บาท"},
      {"title": "30,001-50,000 บาท", "value": "30,001-50,000 บาท"},
      {"title": "มากกว่า 50,000 บาท", "value": "มากกว่า 50,000 บาท"},
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
                  'รายได้เฉลี่ยต่อเดือน',
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
                  itemCount: choicesAvgSalary.length,
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
                      title: Text(choicesAvgSalary[index]["title"]),
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          if (checked) {
                            onChange(choicesAvgSalary[index]["value"]);
                          } else {
                            onChange("");
                          }
                        }
                      },
                      value: selected == choicesAvgSalary[index]["value"],
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
