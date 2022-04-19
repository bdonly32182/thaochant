import 'package:chanthaburi_app/models/user/partner.dart';
import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:chanthaburi_app/widgets/url_luncher_map.dart';
import 'package:flutter/material.dart';

class PartnerDetail extends StatefulWidget {
  PartnerModel partner;
  String docId;
  PartnerDetail({Key? key, required this.partner, required this.docId})
      : super(key: key);

  @override
  State<PartnerDetail> createState() => _PartnerDetailState();
}

class _PartnerDetailState extends State<PartnerDetail> {
  onApprove(BuildContext contextConfirm) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> _response = await UserCollection.onApprove(
      widget.docId,
      widget.partner,
    );
    Navigator.pop(contextConfirm);
    Navigator.pop(context);
    if (_response["status"] == "200") {
      Navigator.pop(context);
    }
    showDialog(
      context: context,
      builder: (BuildContext showContext) {
        return ResponseDialog(response: _response);
      },
    );
  }

  onUnApprove(BuildContext contextConfirm) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> _response = await UserCollection.unApprove(
      widget.docId,
      widget.partner.profileRef,
      widget.partner.verifyRef,
    );
    Navigator.pop(contextConfirm);
    Navigator.pop(context);
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext showContext) {
        return ResponseDialog(response: _response);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.colorStore,
        title: const Text("รายละเอียดพาร์ทเนอร์"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: width * 0.8,
              height: height * 0.2,
              child: ShowImageNetwork(
                pathImage: widget.partner.verifyRef,
                colorImageBlank: MyConstant.themeApp,
              ),
            ),
            buildField(width, "ชื่อ - นามสกุล", widget.partner.fullName),
            buildField(width, "อีเมล", widget.partner.email),
            buildField(width, "เบอร์ติดต่อ", widget.partner.phoneNumber),
            buildField(width, "ที่อยู่อาศัย", widget.partner.address),
            SizedBox(
              width: width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UrlLuncherMap(
                    lat: widget.partner.lat,
                    lng: widget.partner.lng,
                    businessName: widget.partner.address,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      dialogConfirm(
                        context,
                        "แจ้งเตือน",
                        "ยืนยันที่จะปฏิเสธพาร์ทเนอร์ใช่หรือไม่",
                        onApprove,
                      );
                    },
                    child: Text(
                      "อนุมัติ",
                      style: TextStyle(color: MyConstant.themeApp),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shadowColor: MyConstant.backgroudApp,
                      side: BorderSide(
                        color: MyConstant.themeApp,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      dialogConfirm(
                        context,
                        "แจ้งเตือน",
                        "ยืนยันที่จะปฏิเสธพาร์ทเนอร์ใช่หรือไม่",
                        onUnApprove,
                      );
                    },
                    child: const Text(
                      "ไม่อนุมัติ",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shadowColor: MyConstant.backgroudApp,
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column buildField(double width, String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: width * 0.7,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 14.0, left: 10.0),
            child: Text(
              data,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 1,
                offset: Offset(0.1, 0.1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
