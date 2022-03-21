import 'package:chanthaburi_app/pages/profile/skeleton/skeleton_image_profile.dart';
import 'package:chanthaburi_app/widgets/image_blank.dart';
import 'package:flutter/material.dart';

class ShowImageNetwork extends StatelessWidget {
  String pathImage;
  Color colorImageBlank;
  ShowImageNetwork(
      {Key? key, required this.pathImage, required this.colorImageBlank})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Image.network(
      pathImage,
      fit: BoxFit.fitWidth,
      width: width * 0.99,
      errorBuilder: (BuildContext buildImageError, object, stackthree) {
        return ImageBlank(imageColor: colorImageBlank);
      },
      // loadingBuilder: (c, w, ch) {
      //   if (ch == null) {
      //     return w;
      //   }
      //   return CircularProgressIndicator();
      // },
    );
  }
}
