import 'dart:io';

import 'package:chanthaburi_app/models/review/review.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/review_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class WriteReview extends StatefulWidget {
  String businessId, businessName, businessImage, type;
  Color theme;
  WriteReview({
    Key? key,
    required this.businessId,
    required this.businessName,
    required this.businessImage,
    required this.theme,
    required this.type,
  }) : super(key: key);

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  final _formKey = GlobalKey<FormState>();
  ReviewModel reviewModel = ReviewModel(
      userId: '',
      businessId: '',
      title: '',
      message: '',
      imageRef: '',
      dateTime: DateTime.now(),
      point: 0);
  File? selectedImage;
  getImage() async {
    File? image = await PickerImage.getImage();
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  takePhoto() async {
    File? photo = await PickerImage.takePhoto();
    if (photo != null) {
      setState(() {
        selectedImage = photo;
      });
    }
  }

  onSubmitReview() async {
    if (reviewModel.point > 0) {
      late BuildContext dialogContext;
      _formKey.currentState!.save();
      reviewModel.businessId = widget.businessId;
      reviewModel.userId = AuthMethods.currentUser();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          dialogContext = context;
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic> response = await ReviewCollection.writeReview(
          reviewModel, selectedImage, widget.type);
      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
      _formKey.currentState!.reset();
      setState(() {
        selectedImage = null;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext showContext) => const ResponseDialog(
          response: {"status": "199", "message": "กรุณาให้คะแนนด้วยครับ"},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: widget.theme,
        title: const Text('เขียนรีวิว'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildCardHeader(width),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFormFieldTitle(width),
                      buildFormFieldMessage(width),
                      buildRating(width),
                      // buildGetImage(width),
                      buildButtonSendReview(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildButtonSendReview() {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        child: const Text('ยืนยัน'),
        onPressed: onSubmitReview,
        style: ElevatedButton.styleFrom(primary: widget.theme),
      ),
    );
  }

  Card buildRating(double width) {
    return Card(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        width: width * 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ให้คะแนน',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            RatingBar.builder(
              allowHalfRating: true,
              itemSize: 30,
              itemBuilder: (BuildContext starContext, int index) {
                return Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                );
              },
              onRatingUpdate: (ratingUpdate) {
                reviewModel.point = ratingUpdate;
              },
            ),
          ],
        ),
      ),
    );
  }

  InkWell buildGetImage(double width) {
    return InkWell(
      onTap: () => dialogCamera(context, getImage, takePhoto, widget.theme),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: width * 1,
        height: 120,
        child: selectedImage != null
            ? Container(
                margin: const EdgeInsets.all(6.0),
                width: width * 0.2,
                child: Image.file(selectedImage!),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'อัปโหลดรูปภาพ',
                    style: TextStyle(color: widget.theme),
                  ),
                  Icon(
                    Icons.camera_alt,
                    color: widget.theme,
                  ),
                ],
              ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: MyConstant.backgroudApp,
        ),
      ),
    );
  }

  Container buildFormFieldTitle(double width) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: width * 1,
      child: TextFormField(
        maxLines: 2,
        onSaved: (title) => reviewModel.title = title!,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: 'หัวข้อ :',
            labelStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(
              Icons.description,
              color: widget.theme,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            )),
        style: TextStyle(color: widget.theme, fontWeight: FontWeight.w700),
      ),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
    );
  }

  Container buildFormFieldMessage(double width) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: width * 1,
      child: TextFormField(
        maxLines: 8,
        onSaved: (message) => reviewModel.message = message!,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: 'ข้อความรีวิว :',
            labelStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(
              Icons.title,
              color: widget.theme,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            )),
        style: TextStyle(color: widget.theme, fontWeight: FontWeight.w700),
      ),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
    );
  }

  Card buildCardHeader(double width) {
    return Card(
      child: Row(
        children: [
          Container(
            width: width * 0.2,
            child: ShowImageNetwork(
                pathImage: widget.businessImage, colorImageBlank: widget.theme),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 0.8),
                  blurRadius: 4,
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            width: width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.businessName,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Text(
                //   'ชื่อสินค้าชื่อสินค้าชื่อสินค้าชื่อสินค้าชื่อสินค้า',
                //   softWrap: true,
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
