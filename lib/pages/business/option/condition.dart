import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class ConditionOption extends StatefulWidget {
  int maxOption;
  bool infinity, max, force;
  ConditionOption({
    Key? key,
    required this.maxOption,
    required this.force,
    required this.max,
    required this.infinity,
  }) : super(key: key);

  @override
  State<ConditionOption> createState() => _ConditionOptionState();
}

class _ConditionOptionState extends State<ConditionOption> {
  bool isInfinity = false;
  bool isMax = false;
  bool isForce = false;
  int max = 0;
  int maxForce = 0;
  List<String> dropdownCondition = [];
  Map<String, dynamic>? selectCondition;
  menuNumber(int numberGenerate) {
    List<String> _menuGen =
        List.generate(numberGenerate, (index) => (index + 1).toString());
    setState(() {
      dropdownCondition.addAll(_menuGen);
    });
  }

  setStatus() {
    setState(() {
      isForce = widget.force;
      isMax = widget.max;
      isInfinity = widget.infinity;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setStatus();
    menuNumber(widget.maxOption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.colorStore,
        title: const Text('ข้อจำกัดตัวเลือกเสริม'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: MyConstant.colorStore,
                  value: isInfinity,
                  onChanged: (bool? value) {
                    if (value == true) {
                      setState(() {
                        isInfinity = true;
                        isMax = false;
                        isForce = false;
                        selectCondition = {
                          'conditionName': 'ไม่บังคับ, เลือกได้ไม่จำกัด',
                          'min': 0,
                          'max': widget.maxOption,
                        };
                      });
                    } else {
                      setState(() {
                        max = 0;
                        isInfinity = false;
                        selectCondition = {};
                      });
                    }
                  },
                ),
                const Text(
                  'ไม่บังคับ, เลือกได้ไม่จำกัด',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Checkbox(
                  activeColor: MyConstant.colorStore,
                  value: isMax,
                  onChanged: (bool? value) {
                    if (value == true) {
                      setState(() {
                        isMax = true;
                        isForce = false;
                        isInfinity = false;
                        selectCondition = {
                          'conditionName': 'ไม่บังคับ, เลือกสูงสุด',
                          'min': 0,
                          'max': widget.maxOption,
                        };
                      });
                    } else {
                      isMax = true;
                      selectCondition = {};
                    }
                  },
                ),
                const Text(
                  'ไม่บังคับ, เลือกสูงสุด',
                ),
                Container(
                  width: 100,
                  child: DropdownSearch(
                    mode: Mode.MENU,
                    // enabled: false,
                    maxHeight: 20,
                    items: dropdownCondition,
                    itemAsString: (String? index) => index!,
                    dropdownSearchDecoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      labelText: "เลือก",
                      contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: MyConstant.colorStore,
                  value: isForce,
                  onChanged: (bool? value) {
                    if (value == true) {
                      setState(() {
                        isForce = true;
                        isMax = false;
                        isInfinity = false;
                        selectCondition = {
                          'conditionName': 'บังคับเลือก',
                          'min': 0,
                          'max': widget.maxOption,
                        };
                      });
                    } else {
                      setState(() {
                        isForce = false;
                        selectCondition = {};
                      });
                    }
                  },
                ),
                const Text(
                  'บังคับเลือก',
                ),
              ],
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                child: const Text('ส่ง'),
                onPressed: () {
                  Navigator.of(context).pop(selectCondition);
                },
                style: ElevatedButton.styleFrom(primary: MyConstant.colorStore),
              ),
            )
          ],
        ),
      ),
    );
  }
}
