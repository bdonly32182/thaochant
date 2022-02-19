import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  Widget? gotoWidget;
  String imageUrl;
  String? title;
  Color titleColor;
  MenuCard({
    Key? key,
    this.gotoWidget,
    required this.imageUrl,
    required this.title,
    required this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          if (gotoWidget != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => gotoWidget!,
              ),
            );
          }
          print("go to ...");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: width * 0.4,
              child: Image.asset(imageUrl),
            ),
            SizedBox(
              width: width * .5,
              child: Center(
                child: Text(
                  title!,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        color: Colors.grey,
                        offset: Offset(0, 2.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
