import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class MemberQuestion extends StatelessWidget {
  final Function onChange;
  final num selected;
  const MemberQuestion({
    Key? key,
    required this.onChange,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> choicesMember = [
      {"title": "จำนวน 1 คน", "value": 1},
      {"title": "จำนวน 2 คน", "value": 2},
      {"title": "จำนวน 3 คน", "value": 3},
      {"title": "มากกว่า 3 คน", "value": 4},
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
                  'จำนวนผู้เดินทางในการท่องเที่ยวครั้งนี้ (รวมตัวท่าน)',
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
                  itemCount: choicesMember.length,
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
                      title: Text(choicesMember[index]["title"]),
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          if (checked) {
                            onChange(choicesMember[index]["value"]);
                          } else {
                            onChange(0);
                          }
                        }
                      },
                      value: selected == choicesMember[index]["value"],
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
