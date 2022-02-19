import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:flutter/material.dart';

class CardPartner extends StatelessWidget {
  final String email;
  final String profileRef;
  final String docId;
  final String fullName;
  final String role;
  final String phoneNumber;
  final Function onApprove;
  final Function onUnApprove;
  const CardPartner({
    Key? key,
    required this.role,
    required this.fullName,
    required this.phoneNumber,
    required this.onApprove,
    required this.onUnApprove,
    required this.docId,
    required this.email,
    required this.profileRef,
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
        height: 160,
        child: InkWell(
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
                                    fullName,
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
                                phoneNumber,
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
                                role,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => onApprove(docId, fullName, role,
                          phoneNumber, profileRef, email),
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
                      onPressed: () => onUnApprove(docId),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
