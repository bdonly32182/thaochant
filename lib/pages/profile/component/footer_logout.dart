import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class FooterLogout extends StatelessWidget {
  Color theme;
  FooterLogout({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: width * 0.36,
      child: ElevatedButton(
        child: Row(
          children: const [
            Text("ออกจากระบบ"),
            Icon(Icons.logout),
          ],
        ),
        onPressed: () async {
          await AuthMethods.logout();
          Navigator.pushNamedAndRemoveUntil(
            context,
            MyConstant.routeAuthen,
            (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(primary: theme),
      ),
    );
  }
}
