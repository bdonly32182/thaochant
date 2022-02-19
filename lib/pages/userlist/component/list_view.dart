import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';

class ListViewComponent extends StatelessWidget {
  String fullName;
  String role;
  String phoneNumber;
  ListViewComponent({
    Key? key,
    required this.role,
    required this.fullName,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          width: width * 1,
          height: 120,
          child: InkWell(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: width * 0.2,
                  height: 70,
                  child: Icon(
                    Icons.person_outline,
                    color: MyConstant.themeApp,
                    size: 50,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: MyConstant.themeApp, width: 3),
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
                                    color: MyConstant.themeApp,
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
                                color: MyConstant.themeApp,
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
                                color: MyConstant.themeApp,
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
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
