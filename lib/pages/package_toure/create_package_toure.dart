import 'dart:io';

import 'package:chanthaburi_app/models/packagetour/id_name.dart';
import 'package:chanthaburi_app/models/packagetour/package_tour.dart';
import 'package:chanthaburi_app/pages/package_toure/select_guide.dart';
import 'package:chanthaburi_app/pages/package_toure/select_location.dart';
import 'package:chanthaburi_app/pages/package_toure/select_resort.dart';
import 'package:chanthaburi_app/resources/firestore/tour_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CreatePackageTour extends StatefulWidget {
  CreatePackageTour({Key? key}) : super(key: key);

  @override
  State<CreatePackageTour> createState() => _CreatePackageTourState();
}

class _CreatePackageTourState extends State<CreatePackageTour> {
  File? imageSelected;
  File? pdfSelected;
  String? pdfName;
  final formKey = GlobalKey<FormState>();
  final PackageTourModel _packageTourModel = PackageTourModel(
    packageName: "",
    priceAdult: 0,
    priceYouth: 0,
    priceOlder: 0,
    description: "",
    guides: [],
    locations: [],
    resorts: [],
    imageRef: "",
    pdfRef: "",
    point: 0,
    ratingCount: 0,
    status: 1,
    promptPay: "",
    ownerPromptPay: "",
  );

  void getImage() async {
    File? _imagePath = await PickerImage.getImage();
    if (_imagePath != null) {
      setState(() {
        imageSelected = _imagePath;
      });
    } else {
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (cameraStatus.isPermanentlyDenied) {
        alertService(
          context,
          'ไม่อนุญาติแชร์ Photo',
          'โปรดแชร์ Photo',
        );
      }
    }
  }

  takePhoto() async {
    File? takePhoto = await PickerImage.takePhoto();
    if (takePhoto != null) {
      setState(() {
        imageSelected = takePhoto;
      });
    } else {
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (cameraStatus.isPermanentlyDenied) {
        alertService(
          context,
          'ไม่อนุญาติแชร์ Camera',
          'โปรดแชร์ Camera',
        );
      }
    }
  }

  void getPdf() async {
    FilePickerResult? pdf = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (pdf != null) {
      setState(() {
        pdfSelected = File(pdf.files.single.path!);
        pdfName = pdf.names[0];
      });
    }
  }

  gotoSelectGuide() async {
    List<IdAndName> guideSelected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectGuide(guides: _packageTourModel.guides),
      ),
    );
    setState(() {
      _packageTourModel.guides = guideSelected;
    });
  }

  gotoSelectResort() async {
    List<IdAndName> resortSelected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectResort(resorts: _packageTourModel.resorts),
      ),
    );
    setState(() {
      _packageTourModel.resorts = resortSelected;
    });
  }

  gotoSelectLocation() async {
    List<IdAndName> locationSelected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            SelectLocationTour(locations: _packageTourModel.locations),
      ),
    );
    setState(() {
      _packageTourModel.locations = locationSelected;
    });
  }

  void createPackageTour() async {
    late BuildContext dialogContext;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (imageSelected != null &&
          pdfSelected != null &&
          _packageTourModel.guides.isNotEmpty &&
          _packageTourModel.locations.isNotEmpty &&
          _packageTourModel.resorts.isNotEmpty) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext showContext) {
            dialogContext = context;
            return const PouringHourGlass();
          },
        );
        Map<String, dynamic> response = await TourCollection.createPackageTour(
            _packageTourModel, imageSelected, pdfSelected);
        Navigator.pop(dialogContext);
        showDialog(
          context: context,
          builder: (BuildContext showContext) =>
              ResponseDialog(response: response),
        );

        formKey.currentState!.reset();
        setState(() {
          imageSelected = null;
          pdfName = null;
          pdfSelected = null;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext showContext) => const ResponseDialog(
              response: {"status": "199", "message": "กรุณาเลือกให้ครบ"}),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Text('สร้างแพ็คเกจทัวร์'),
        backgroundColor: MyConstant.colorGuide,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                fieldPackageName(width),
                fieldPriceAdult(width),
                fieldPriceSenior(width),
                fieldPriceYouth(width),
                fieldOwnerPromptPay(width),
                fieldPromptPay(width),
                fieldSearchGuide(width),
                fieldSearchLocation(width),
                fieldSearchResort(width),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10.0),
                  child: Center(
                    child: Text(
                      'รายละเอียดเพิ่มเติม',
                      style: TextStyle(
                        color: MyConstant.colorGuide,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                buildPickerImage(width),
                buildSelectPdf(width),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text("สร้างแพ็คเกจทัวร์"),
                    onPressed: createPackageTour,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row fieldOwnerPromptPay(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          child: TextFormField(
            onSaved: (ownerPromptPay) =>
                _packageTourModel.ownerPromptPay = ownerPromptPay!,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกชื่อเจ้าของบัญชีพร้อมเพย์';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ชื่อเจ้าของบัญชีพร้อมเพย์ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.person,
                  color: MyConstant.colorGuide,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                )),
            style: TextStyle(
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
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
        ),
      ],
    );
  }

  Row fieldPromptPay(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          child: TextFormField(
            onSaved: (promptpay) => _packageTourModel.promptPay = promptpay!,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกบัญชีพร้อมเพย์';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'บัญชีพร้อมเพย์ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.credit_card,
                  color: MyConstant.colorGuide,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                )),
            style: TextStyle(
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
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
        ),
      ],
    );
  }

  Row buildSelectPdf(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: getPdf,
          child: Container(
            width: width * 0.8,
            height: 100,
            margin: const EdgeInsets.only(top: 10),
            child: pdfSelected != null && pdfName != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_download_done,
                        color: MyConstant.colorTour,
                        size: 60,
                      ),
                      Text(
                        pdfName!,
                        style: TextStyle(
                          color: MyConstant.colorTour,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_download,
                        color: MyConstant.colorTour,
                        size: 60,
                      ),
                      Text(
                        'เลือกไฟล์ pdf',
                        style: TextStyle(
                          color: MyConstant.colorTour,
                        ),
                      ),
                    ],
                  ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InkWell buildPickerImage(double width) {
    return InkWell(
      onTap: () =>
          dialogCamera(context, getImage, takePhoto, MyConstant.colorGuide),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width * .8,
            height: 150,
            child: imageSelected != null
                ? Image.file(
                    imageSelected!,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: MyConstant.colorTour,
                        size: 60,
                      ),
                      Text(
                        'เลือกรูปภาพ',
                        style: TextStyle(
                          color: MyConstant.colorTour,
                        ),
                      ),
                    ],
                  ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell fieldSearchResort(double width) {
    return InkWell(
      onTap: gotoSelectResort,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: width * .8,
            height: 120,
            child: Column(
              children: [
                Text(
                  'เลือกบ้านพักสำหรับแพ็คเกจ',
                  style: TextStyle(color: MyConstant.colorTour),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: _packageTourModel.resorts.length,
                  itemBuilder: (context, index) => Center(
                    child: Text(
                      _packageTourModel.resorts[index].name,
                      style: TextStyle(
                        color: MyConstant.colorGuide,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell fieldSearchLocation(double width) {
    return InkWell(
      onTap: gotoSelectLocation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: width * .8,
            height: 120,
            child: Column(
              children: [
                Text(
                  'เลือกแหล่งท่องเที่ยวสำหรับแพ็คเกจ',
                  style: TextStyle(color: MyConstant.colorTour),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: _packageTourModel.locations.length,
                  itemBuilder: (context, index) => Center(
                    child: Text(
                      _packageTourModel.locations[index].name,
                      style: TextStyle(color: MyConstant.colorGuide),
                    ),
                  ),
                ),
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell fieldSearchGuide(double width) {
    return InkWell(
      onTap: gotoSelectGuide,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: width * .8,
            height: 120,
            child: Column(
              children: [
                Text(
                  'เลือกไกด์สำหรับแพ็คเกจ',
                  style: TextStyle(color: MyConstant.colorTour),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: _packageTourModel.guides.length,
                  itemBuilder: (context, index) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        _packageTourModel.guides[index].name,
                        style: TextStyle(color: MyConstant.colorGuide),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row fieldDrescription(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          child: TextFormField(
            maxLines: 5,
            onSaved: (description) =>
                _packageTourModel.description = description!,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกการแนะนำแพ็คเกจทัวร์';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'แนะนำแพ็คเกจทัวร์ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.description,
                  color: MyConstant.colorGuide,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                )),
            style: TextStyle(
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
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
        ),
      ],
    );
  }

  Row fieldPriceAdult(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          height: 60,
          child: TextFormField(
            onSaved: (adult) =>
                _packageTourModel.priceAdult = double.parse(adult!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ราคาแพ็คเกจทัวร์ของผู้ใหญ่ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(
                  Icons.paid_sharp,
                  color: MyConstant.colorGuide,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                )),
            style: TextStyle(
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
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
        ),
      ],
    );
  }

  Row fieldPriceSenior(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          height: 60,
          child: TextFormField(
            onSaved: (senior) =>
                _packageTourModel.priceOlder = double.parse(senior!),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ราคาแพ็คเกจทัวร์ของผู้สูงอายุ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(
                  Icons.paid_sharp,
                  color: MyConstant.colorGuide,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                )),
            style: TextStyle(
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
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
        ),
      ],
    );
  }

  Row fieldPriceYouth(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          height: 60,
          child: TextFormField(
            onSaved: (youth) =>
                _packageTourModel.priceYouth = double.parse(youth!),
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกราคาแพ็คเกจทัวร์';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ราคาแพ็คเกจทัวร์ของเด็ก :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(
                  Icons.paid_sharp,
                  color: MyConstant.colorGuide,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                )),
            style: TextStyle(
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
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
        ),
      ],
    );
  }

  Row fieldPackageName(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          height: 60,
          child: TextFormField(
            onSaved: (packageName) =>
                _packageTourModel.packageName = packageName!,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกชื่อแพ็คเกจทัวร์';
              return null;
            },
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ชื่อแพ็คเกจทัวร์ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.menu_book,
                  color: MyConstant.colorGuide,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                )),
            style: TextStyle(
                color: MyConstant.colorGuide, fontWeight: FontWeight.w700),
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
        ),
      ],
    );
  }
}
