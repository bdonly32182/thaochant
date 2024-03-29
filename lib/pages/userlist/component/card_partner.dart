import 'package:chanthaburi_app/models/user/partner.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class CardPartner extends StatelessWidget {
  final String docId;
  PartnerModel partner;
  Function navigatePartnerDetail;
  CardPartner({
    Key? key,
    required this.partner,
    required this.docId,
    required this.navigatePartnerDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        width: width * 1,
        height: 128,
        child: InkWell(
          onTap: () => navigatePartnerDetail(partner,docId),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: width * 0.2,
                    height: 70,
                    child: Icon(
                      Icons.person_outline,
                      color: MyConstant.colorStore,
                      size: 50,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: MyConstant.colorStore, width: 3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: width * 0.7,
                      margin: EdgeInsets.only(left: width * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.library_books,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    partner.fullName,
                                    style: TextStyle(
                                      color: MyConstant.colorStore,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                partner.phoneNumber,
                                style: TextStyle(
                                  color: MyConstant.colorStore,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.category,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                partner.role,
                                style: TextStyle(
                                  color: MyConstant.colorStore,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      "ตรวจสอบข้อมูล",
                      style: TextStyle(
                        color: MyConstant.colorStore,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
