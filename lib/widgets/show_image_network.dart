import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/image_blank.dart';
import 'package:flutter/material.dart';

class ShowImageNetwork extends StatelessWidget {
  final String pathImage;
  final Color colorImageBlank;
  final BoxFit? boxFit;
  const ShowImageNetwork({
    Key? key,
    required this.pathImage,
    required this.colorImageBlank,
    this.boxFit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return pathImage.isNotEmpty
        ? Image.network(
            pathImage,
            fit: boxFit ?? BoxFit.fitWidth,
            width: width * 0.99,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgess) {
              if (loadingProgess == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  color: MyConstant.themeApp,
                  value: loadingProgess.expectedTotalBytes != null
                      ? loadingProgess.cumulativeBytesLoaded /
                          loadingProgess.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (BuildContext buildImageError, object, stackthree) {
              return ImageBlank(imageColor: colorImageBlank);
            },
          )
        : Center(child: ImageBlank(imageColor: colorImageBlank));
  }
}
