import 'package:flutter/material.dart';

class ContentProfile extends StatelessWidget {
  String text;
  ContentProfile({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: width * 0.86,
      height: 40,
      child: Center(child: Text(text)),
      decoration: const BoxDecoration(color: Colors.white60),
    );
  }
}
