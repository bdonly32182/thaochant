import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';

class DetailStore extends StatefulWidget {
  DetailStore({Key? key}) : super(key: key);

  @override
  _DetailStoreState createState() => _DetailStoreState();
}

class _DetailStoreState extends State<DetailStore> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text('รายละเอียดร้าน'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  buildShowMap(width, height),
                  buildName(width),
                  buildRowRating(),
                  buildSection(width, 'ข้อมูลทีอยู่ร้าน',
                      '19/19 แขวง แสมดำ เขต บางขุนเทียน จังหวัด กรุงเทพมหานคร 10150'),
                  buildSection(width, 'เบอร์ติดต่อ', '0814206492'),
                  buildSection(width, 'เวลาทำการ', 'ทุกวัน 10:00 - 20:30'),
                  const SizedBox(
                    height: 15.0,
                  )
                ],
              ),
            ),
            buildCardImageAndReview(width, height)
          ],
        ),
      ),
    );
  }

  Card buildCardImageAndReview(double width, double height) {
    return Card(
      child: Column(
        children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 25, left: 10.0),
                child: Text(
                  'รูปภาพและรีวิว',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          buildShowImageReview(width, height),
          buildComment(width),
        ],
      ),
    );
  }

  Container buildShowImageReview(double width, double height) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: width * 1,
      height: height * 0.1,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(3.0),
            width: width * 0.17,
            height: 50,
            child: ShowImage(pathImage: MyConstant.delivery),
          );
        },
      ),
    );
  }

  InkWell buildComment(double width) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (builder) => ReviewList(),
        //   ),
        // );
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        width: width * 1,
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text('อ่านรีวิว (35)'),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 15,
            )
          ],
        ),
        decoration: BoxDecoration(
          boxShadow: const[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5,
              offset: Offset(0, 0.5),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  SizedBox buildSection(
    double width,
    String typeName,
    String text,
  ) {
    return SizedBox(
      width: width * 1,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  typeName,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildShowMap(double width, double height) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      width: width * 1,
      height: height * 0.24,
      child: ShowImage(pathImage: MyConstant.currentLocation),
    );
  }

  Container buildName(double width) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 15),
      width: width * 1,
      child: Text(
        'บ้านขนมโฮมเมด',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }

  Row buildRowRating() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.star,
            color: Colors.yellow[700],
          ),
        ),
        Text(
          '4.2 (32 รีวิว)',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
