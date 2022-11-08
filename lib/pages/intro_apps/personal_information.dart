import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class PersonalInformation extends StatelessWidget {
  final Function onChange;
  final String selected;
  const PersonalInformation({
    Key? key,
    required this.onChange,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> choices = [
      {"title": "ชาย", "value": "male"},
      {"title": "หญิง", "value": "female"},
      {"title": "เพศทางเลือก (LGBTQ)", "value": 'lgbtq'},
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
                  'เพศ',
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
                            onChange("");
                          }
                        }
                      },
                      value: selected == choices[index]["value"],
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
