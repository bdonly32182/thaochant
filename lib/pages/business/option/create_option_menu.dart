import 'package:chanthaburi_app/models/option/option.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateOptionMenu extends StatefulWidget {
  CreateOptionMenu({Key? key}) : super(key: key);

  @override
  State<CreateOptionMenu> createState() => _CreateOptionMenuState();
}

class _CreateOptionMenuState extends State<CreateOptionMenu> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.colorStore,
        title: const Text('สร้างตัวเลือกเสริม'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 20.0,
              left: 8.0,
              right: 8.0,
              bottom: 10.0,
            ),
            child: TextFormField(
              controller: _name,
              validator: (value) {
                if (value!.isEmpty) return 'กรุณากรอกชื่อตัวเลือกเสริม';
                return null;
              },
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'ชื่อตัวเลือกเสริม :',
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
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 10.0,
            ),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: _price,
              validator: (value) {
                if (value!.isEmpty) return 'กรุณากรอกราคา';
                return null;
              },
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'ราคา :',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  prefix: Icon(
                    Icons.attach_money,
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
          ),
          Container(
            width: double.maxFinite,
            child: ElevatedButton(
              child: const Text('สร้างตัวเลือกเสริม'),
              onPressed: () {
                Navigator.of(context).pop({
                  'optionMenuName': _name.text,
                  'optionMenuPrice': double.parse(_price.text),
                });
              },
              style: ElevatedButton.styleFrom(primary: MyConstant.colorStore),
            ),
          )
        ],
      ),
    );
  }
}
