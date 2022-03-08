import 'package:flutter/material.dart';

dialogAlert(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Row(
        children: [
          Icon(
            Icons.warning,
            color: Colors.amber[900],
          ),
          Text(title),
        ],
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(message)],
        ),
      ],
    ),
  );
}
