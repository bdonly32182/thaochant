import 'package:chanthaburi_app/pages/business/option/create_option_menu.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CreateOptionFood extends StatefulWidget {
  CreateOptionFood({Key? key}) : super(key: key);

  @override
  State<CreateOptionFood> createState() => _CreateOptionFoodState();
}

class _CreateOptionFoodState extends State<CreateOptionFood> {
  final TextEditingController _optionNameController = TextEditingController();
  final List<Map<String, dynamic>> options = [];

  _goCreateOptionMenu() async {
    Map<String, dynamic> optionMenu = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateOptionMenu(),
      ),
    );
    setState(() {
      options.add(optionMenu);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(options);
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
              Container(
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
                        children: const [Text('ตัวเลือกเสริม')],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: options.length,
                      itemBuilder: (itemBuilder, index) {
                        return Container(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                      bottom: 8.0,
                                    ),
                                    child:
                                        Text(options[index]['optionMenuName']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      options[index]['optionMenuPrice']
                                          .toString(),
                                    ),
                                  ),
                                ],
                              ),
                              ToggleSwitch(
                                totalSwitches: 2,
                                minWidth: 40.0,
                                cornerRadius: 20.0,
                                activeBgColors: [
                                  [Colors.white],
                                  [MyConstant.colorStore],
                                ],
                                // labels: ['off', 'on'],
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                initialLabelIndex: 1,
                                radiusStyle: true,
                                onToggle: (index) {
                                  print('switched to: $index');
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
                    ),
                    Row(
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
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              )
            ],
          ),
        ),
      ),
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
