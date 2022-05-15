import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image.dart';
import 'package:flutter/material.dart';

class HeaderProfile extends StatelessWidget {
  String profileRef;
  HeaderProfile({Key? key, required this.profileRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: profileRef.isNotEmpty
                ? Image.network(
                    profileRef,
                    fit: BoxFit.cover,
                    width: width * 0.26,
                    height: 110.0,
                    errorBuilder:
                        (BuildContext buildImageError, object, stackthree) {
                      return Container(
                        width: width * 0.26,
                        height: 110.0,
                        child: ShowImage(
                          pathImage: MyConstant.iconUser,
                        ),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(0, 0.2),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(
                    width: width * 0.26,
                    height: 110.0,
                    child: ShowImage(
                      pathImage: MyConstant.iconUser,
                    ),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(0, 0.2),
                        ),
                      ],
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
