import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';

class PartnerPolicy extends StatefulWidget {
  PartnerPolicy({Key? key}) : super(key: key);

  @override
  State<PartnerPolicy> createState() => _PartnerPolicyState();
}

class _PartnerPolicyState extends State<PartnerPolicy> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                width: width * 0.4,
                height: height * 0.2,
                child: const ShowImage(pathImage: 'images/icon.jpg'),
              ),
              const Center(
                child: Text(
                  "ข้อกำหนดและเงื่อนไข",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Text(
                  "1. ต้องเป็นคนที่อาศัยที่มีภูมิลำเนาอยู่ใน 3 ชุมชน ไม่น้อยกว่า 1 ปี และ/ หรือมีบุคคลรับรองผู้สมัครเข้าร่วม  เช่น ผู้นำชุมชน ผู้ใหญ่บ้าน เป็นต้น"),
              const Text(
                  "2. สมาชิกสามารถเป็นผู้ประกอบการได้มากกว่า 1 ประเภท  และจะต้องมีชื่อทำธุรกรรมการเงินเพียง1 บัญชีในทุกประเภท และให้ตรงกันกับชื่อสมาชิกที่ลงทะเบียน"),
              const Text(
                  "3. สินค้าและผลิดตภัณฑ์ชุมชนที่จะเข้าร่วม จะต้องได้รับการพิจารณาอนุมัติจาก คณะกรรมการชุมชน*** และจะต้องติดตราสัญลักษณ์ของทั้ง 3 ชุมชน"),
              const Text(
                "หมายเหตุ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                  "***คณะกรรมการชุมชน 3 ชุมชนประกอบไปด้วย ผู้แทนจาก 3 ชุมชน รวม 6 คน โดยเป็นตัวแทนชุมชนละ 2 คน และเป็นผู้แทนจากสภาวัด อีก 1 คน รวมทั้งหมด 7 คน"),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "ปฏิเสธ",
                        style: TextStyle(
                          color: MyConstant.themeApp,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          MyConstant.routeRegisterPartner,
                          (route) => false,
                        );
                      },
                      child: const Text("ยอมรับ"),
                      style: ElevatedButton.styleFrom(
                        primary: MyConstant.themeApp,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
