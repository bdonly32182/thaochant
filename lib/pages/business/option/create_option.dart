import 'package:chanthaburi_app/models/option/option.dart';
import 'package:chanthaburi_app/pages/business/option/condition.dart';
import 'package:chanthaburi_app/pages/business/option/create_option_menu.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CreateOptionFood extends StatefulWidget {
  final String businessId;
  CreateOptionFood({Key? key, required this.businessId}) : super(key: key);

  @override
  State<CreateOptionFood> createState() => _CreateOptionFoodState();
}

class _CreateOptionFoodState extends State<CreateOptionFood> {
  final TextEditingController _optionNameController = TextEditingController();
  final List<Map<String, dynamic>> options = [];
  final OptionModel _optionModel = OptionModel('', '', '', [], 0, 0);
  Map<String, dynamic>? selectCondition;

  _goCreateOptionMenu() async {
    Map<String, dynamic>? optionMenu = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateOptionMenu(),
      ),
    );
    if (optionMenu != null) {
      setState(() {
        options.add(optionMenu);
      });
    }
  }

  _goCondition() async {
    // Map<String, dynamic>? condition = await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (builder) => ConditionOption(
    //       maxOption: options.length,
    //     ),
    //   ),
    // );
    // if (condition != null) {
    //   setState(() {
    //     selectCondition = condition;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.colorStore,
        title: const Text('สร้างตัวเลือกเสริม'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              buildInputOptionName(),
              buildOption(),
              buildCondition(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildCondition() {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 12,
      ),
      height: 60,
      child: InkWell(
        onTap: _goCondition,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('ข้อจำกัดตัวเลือกเสริม'),
            Text(
              selectCondition!['conditionName'] ?? '',
              style: TextStyle(
                color: MyConstant.colorStore,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Container buildOption() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
        left: 8.0,
        right: 8.0,
        bottom: 10.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text(
                  'ตัวเลือกเสริม',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          buildListOptions(),
          buildTextButtonCreateOption(),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Row buildTextButtonCreateOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: _goCreateOptionMenu,
          child: Row(
            children: [
              Icon(
                Icons.add,
                color: Colors.amber[700],
              ),
              Text(
                'เพิ่มตัวเลือก',
                style: TextStyle(
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView buildListOptions() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (itemBuilder, index) {
        return Container(
          height: 60,
          margin: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          options[index]['optionMenuName'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        bottom: 10.0,
                      ),
                      child: Text(
                        options[index]['optionMenuPrice'].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ToggleSwitch(
                totalSwitches: 2,
                minWidth: 50.0,
                cornerRadius: 20.0,
                activeBgColors: [
                  [Colors.red.shade600],
                  [MyConstant.colorStore],
                ],
                labels: ['off', 'on'],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: options[index]['status'],
                radiusStyle: true,
                onToggle: (status) {
                  setState(() {
                    options[index]['status'] = status;
                  });
                },
              ),
            ],
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(0.2, 0.2),
              ),
            ],
          ),
        );
      },
    );
  }

  Container buildInputOptionName() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
        left: 8.0,
        right: 8.0,
        bottom: 10.0,
      ),
      child: TextFormField(
        controller: _optionNameController,
        validator: (value) {
          if (value!.isEmpty) return 'กรุณากรอกชื่อกลุ่มตัวเลือกเสริม';
          return null;
        },
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: 'ชื่อกลุ่มตัวเลือกเสริม :',
            // hintText: 'ตัวอย่างเช่น ความเผ็ด',
            labelStyle: TextStyle(color: Colors.grey[600]),
            prefix: Icon(
              Icons.category_outlined,
              color: MyConstant.colorStore,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            )),
        style: TextStyle(
          color: MyConstant.colorStore,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
