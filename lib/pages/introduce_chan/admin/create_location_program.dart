import 'dart:io';

import 'package:chanthaburi_app/models/googlemap/google_map.dart';
import 'package:chanthaburi_app/models/program_travel/location_program.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/map/geolocation.dart';
import 'package:chanthaburi_app/utils/map/google_map_fluter.dart';
import 'package:chanthaburi_app/utils/map/show_map.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:chanthaburi_app/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateLocationProgram extends StatefulWidget {
  final String dayId;
  final LocationProgramModel? locationProgram;
  final Function? onDeletImage;
  const CreateLocationProgram({
    Key? key,
    required this.dayId,
    this.locationProgram,
    this.onDeletImage,
  }) : super(key: key);

  @override
  State<CreateLocationProgram> createState() => _CreateLocationProgramState();
}

class _CreateLocationProgramState extends State<CreateLocationProgram> {
  TextEditingController descriptionController = TextEditingController();
TextEditingController locationNameController = TextEditingController();
  LocationProgramModel locationProgram = LocationProgramModel(
    time: '',
    description: '',
    images: [],
    lat: 12.611249,
    lng: 102.103781,
    dayId: '',
    imagesFiles: [], locationName: '',
  );
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    checkPermission();
    if (widget.locationProgram != null) {
      setState(() {
        locationProgram = widget.locationProgram!;
        descriptionController.text = widget.locationProgram!.description;
  
      });
    } else {
      locationProgram.dayId = widget.dayId;
    }
  }

  void checkPermission() async {
    try {
      Position positionBuyer = await determinePosition();
      setState(() {
        locationProgram.lat = positionBuyer.latitude;
        locationProgram.lng = positionBuyer.longitude;
      });
    } catch (e) {
      PermissionStatus locationStatus = await Permission.location.status;
      if (locationStatus.isPermanentlyDenied || locationStatus.isDenied) {
        alertService(
          context,
          'ไม่อนุญาติแชร์ Location',
          'โปรดแชร์ Location',
        );
      }
    }
  }

  getImage() async {
    File? image = await PickerImage.getImage();
    if (image != null) {
      setState(() {
        locationProgram.imagesFiles!.add(image);
      });
    } else {
      PermissionStatus photoStatus = await Permission.photos.status;
      if (photoStatus.isPermanentlyDenied) {
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
        locationProgram.imagesFiles!.add(takePhoto);
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

  removeImage(int index) {
    setState(() {
      locationProgram.imagesFiles!.removeAt(index);
    });
  }

  navigationGoogleMap(BuildContext context) async {
    try {
      final GoogleMapModel _result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) => SelectLocation(
            initLat: locationProgram.lat,
            initLng: locationProgram.lng,
          ),
        ),
      );
      if (_result.latitude != null && _result.longitude != null) {
        setState(() {
          locationProgram.lat = _result.latitude!;
          locationProgram.lng = _result.longitude!;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  onSubmit() {
    if (_formKey.currentState!.validate()) {
      locationProgram.description = descriptionController.text;
      locationProgram.locationName = locationNameController.text;
      Navigator.of(context).pop(locationProgram);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Text('จัดการรอบโปรแกรมท่องเที่ยว'),
        backgroundColor: MyConstant.colorGuide,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('รอบ :'),
                      ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              locationProgram.time =
                                  '${time.hour}:${time.minute}';
                            });
                          }
                        },
                        child: Text(
                          locationProgram.time.isEmpty
                              ? 'เลือกเวลา'
                              : locationProgram.time,
                          style: TextStyle(color: MyConstant.colorGuide),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                buildTextFormField(
                  width,
                  locationNameController,
                  "กรุณากรอกชื่อสถานที่",
                  "ชื่อสถานที่",
                  1,
                ),
                buildTextFormField(
                  width,
                  descriptionController,
                  "กรุณากรอกรายละเอียดเกี่ยวกับรอบ",
                  "รายละเอียดเกี่ยวกับรอบ",
                  15,
                ),
                buildSelectImage(context, width),
                buildShowmap(width, height, context),
                SizedBox(
                  width: width * 0.6,
                  child: ElevatedButton(
                    onPressed: onSubmit,
                    child: const Text("บันทึก"),
                    style: ElevatedButton.styleFrom(
                        primary: MyConstant.colorGuide),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell buildSelectImage(BuildContext context, double width) {
    return InkWell(
      onTap: () =>
          dialogCamera(context, getImage, takePhoto, MyConstant.colorLocation),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        height: 150,
        child: locationProgram.imagesFiles!.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: locationProgram.imagesFiles!.length,
                itemBuilder: (itemBuilder, index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: width * 0.46,
                        child: Image.file(
                          locationProgram.imagesFiles![index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 40,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              locationProgram.imagesFiles!.removeAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                          iconSize: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                  );
                },
              )
            : locationProgram.images.isNotEmpty // for edit
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: locationProgram.images.length,
                    itemBuilder: (itemBuilder, index) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: width * 0.46,
                            child: ShowImageNetwork(
                              pathImage: locationProgram.images[index],
                              colorImageBlank: MyConstant.colorGuide,
                            ),
                          ),
                          Container(
                            height: 40,
                            child: IconButton(
                              onPressed: () {
                                // for remove image old
                                widget.onDeletImage!(
                                  locationProgram.images[index],
                                );
                                setState(() {
                                  locationProgram.images.removeAt(index);
                                });
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                              ),
                              iconSize: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: MyConstant.colorGuide,
                        size: 60,
                      ),
                    ],
                  ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black54,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildShowmap(double width, double height, BuildContext context) {
    return SizedBox(
      width: width * 1,
      height: height * 0.3,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          navigationGoogleMap(context);
        },
        child: Stack(
          children: [
            SizedBox(
              width: width * 1,
              height: height * 0.3,
              child: ShowMap(
                lat: locationProgram.lat,
                lng: locationProgram.lng,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.6,
                  height: 40,
                  child: const Text(
                    "เลือกตำแหน่งแหล่งท่องเที่ยว",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyConstant.colorGuide,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row buildTextFormField(double width, TextEditingController controller,
      String invalidText, String label, int maxline) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .9,
          child: TextFormFieldCustom(
            color: MyConstant.colorGuide,
            controller: controller,
            invalidText: invalidText,
            label: label,
            maxline: maxline,
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
