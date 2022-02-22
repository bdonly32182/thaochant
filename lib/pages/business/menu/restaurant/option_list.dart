import 'package:chanthaburi_app/pages/business/option/create_option.dart';
import 'package:flutter/material.dart';

class OptionList extends StatefulWidget {
  final String businessId;
  OptionList({Key? key,required this.businessId }) : super(key: key);

  @override
  State<OptionList> createState() => _OptionListState();
}

class _OptionListState extends State<OptionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => CreateOptionFood(businessId: widget.businessId,),
                  ),
                );
              },
              child: Row(
                children: [Icon(Icons.add), Text('เพิ่ม')],
              ),
            ),
            Text('option list'),
          ],
        ),
      ),
    );
  }
}
