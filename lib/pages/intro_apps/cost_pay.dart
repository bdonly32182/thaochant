import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class CostPay extends StatelessWidget {
  final Function onChange;
  final String selected;
  const CostPay({
    Key? key,
    required this.onChange,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> choicesCostPay = [
      {"title": "น้อยกว่า 1,000 บาท", "value": "น้อยกว่า 1,000 บาท"},
      {"title": "1,001 -2,000 บาท", "value": "1,001 -2,000 บาท"},
      {"title": "2,001 บาทขึ้นไป", "value": "2,001 บาทขึ้นไป"},
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
                  'ท่านคาดว่าจะใช้จ่ายเงินในการท่องเที่ยวที่นี้ ประมาณเท่าใด',
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
                  itemCount: choicesCostPay.length,
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
                      title: Text(choicesCostPay[index]["title"]),
                      onChanged: (bool? checked) {
                        if (checked != null) {
                          if (checked) {
                            onChange(choicesCostPay[index]["value"]);
                          } else {
                            onChange("");
                          }
                        }
                      },
                      value: selected == choicesCostPay[index]["value"],
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
