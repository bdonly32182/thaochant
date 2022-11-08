import 'package:flutter/material.dart';


class PersonalInformation extends StatelessWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [Text('ข้อมูลส่วนบุคคล'),Text('เพศ')],
          ),
        ),
      ),
    );
  }
}
