import 'dart:developer';
import 'dart:io';

import 'package:chanthaburi_app/models/events/event_model.dart';
import 'package:chanthaburi_app/models/googlemap/google_map.dart';
import 'package:chanthaburi_app/resources/firestore/event_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/map/geolocation.dart';
import 'package:chanthaburi_app/utils/map/google_map_fluter.dart';
import 'package:chanthaburi_app/utils/map/show_map.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:chanthaburi_app/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateEvent extends StatefulWidget {
  final EventModel? eventModelForEdit;
  final String? eventId;
  const CreateEvent({
    Key? key,
    this.eventModelForEdit,
    this.eventId,
  }) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController sequenceController = TextEditingController();
  File? imageCover;
  EventModel eventModel = EventModel(
    url: '',
    usageTime: 0.5,
    lat: 0,
    lng: 0,
    sequence: 0,
    totalSelected: 0,
    eventName: '',
  );
  @override
  void initState() {
    super.initState();
    checkPermission();
    if (widget.eventModelForEdit != null) {
      setState(() {
        eventNameController.text = widget.eventModelForEdit!.eventName;
        sequenceController.text = widget.eventModelForEdit!.sequence.toString();
        eventModel = widget.eventModelForEdit!;
      });
    }
  }

  Map<String, num> usageTime = {
    "น้อยกว่า 1 ชั่วโมง": 0.5,
    '2 ชั่วโมง': 2,
    '3 ชั่วโมง': 3,
    'มากกว่า 3 ชั่วโมง': 4
  };

  void checkPermission() async {
    try {
      Position positionBuyer = await determinePosition();
      setState(() {
        eventModel.lat = positionBuyer.latitude;
        eventModel.lng = positionBuyer.longitude;
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
        imageCover = image;
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

  _navigationGoogleMap(BuildContext context) async {
    try {
      final GoogleMapModel _result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) => SelectLocation(
            initLat: eventModel.lat,
            initLng: eventModel.lng,
          ),
        ),
      );
      if (_result.latitude != null && _result.longitude != null) {
        setState(() {
          eventModel.lat = _result.latitude!;
          eventModel.lng = _result.longitude!;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  onSubmit() async {
    // if (widget.eventId == null && imageCover == null) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext showContext) => const ResponseDialog(
    //       response: {"status": "400", "message": "กรุณาแนบรูปหน้าปกกิจกรรม"},
    //     ),
    //   );
    //   return;
    // }
    if (_formKey.currentState!.validate()) {
      eventModel.eventName = eventNameController.text;
      eventModel.sequence = int.parse(sequenceController.text);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic> response = await EventCollection.upsertEvent(
        eventModel,
        imageCover,
        widget.eventId,
      );
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
    }
  }

  onDeleteEvent(
      BuildContext dialogContext, String docId, String imageURL) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> response =
        await EventCollection.deleteEvenet(docId, imageURL);
    Navigator.pop(dialogContext);
    Navigator.pop(context);
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext showContext) => ResponseDialog(response: response),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการกิจกรรม'),
        backgroundColor: MyConstant.themeApp,
        actions: widget.eventModelForEdit != null
            ? [
                IconButton(
                  onPressed: () => dialogDeleteEvent(
                    context,
                    widget.eventId!,
                    widget.eventModelForEdit!.url,
                    onDeleteEvent,
                  ),
                  icon: const Icon(
                    Icons.delete_forever,
                  ),
                ),
              ]
            : [],
      ),
      backgroundColor: MyConstant.backgroudApp,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InkWell(
                onTap: () => getImage(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 25.0, top: 10),
                      width: width * 0.6,
                      height: height * 0.16,
                      child: imageCover == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: eventModel.url.isEmpty
                                  ? [
                                      Icon(
                                        Icons.add_a_photo_outlined,
                                        color: MyConstant.themeApp,
                                        size: 60,
                                      ),
                                      const Text(
                                        "เพิ่มรูปหน้าปกกิจกรรม",
                                      ),
                                    ]
                                  : [
                                      SizedBox(
                                        width: width * 0.6,
                                        height: height * 0.16,
                                        child: ShowImageNetwork(
                                          pathImage: eventModel.url,
                                          colorImageBlank: MyConstant.themeApp,
                                          boxFit: BoxFit.fill,
                                        ),
                                      )
                                    ],
                            )
                          : Image.file(
                              imageCover!,
                              fit: BoxFit.fill,
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
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: width * 0.7,
                child: TextFormFieldCustom(
                  color: MyConstant.themeApp,
                  controller: eventNameController,
                  invalidText: "กรุณากรอกชื่อกิจกรรม",
                  label: "ชื่อกิจกรรม",
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: width * 0.7,
                child: TextFormFieldCustom(
                  color: MyConstant.themeApp,
                  controller: sequenceController,
                  invalidText: "กรุณากรอกลำดับของกิจกรรม",
                  label: "ลำดับของกิจกรรม(รวมกับลำดับสินค้าที่สนใจ)",
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: width * 0.7,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    style: TextStyle(color: MyConstant.colorStore),
                    value: eventModel.usageTime,
                    items: usageTime
                        .map((key, value) {
                          return MapEntry(
                            key,
                            DropdownMenuItem(
                              value: value,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                child: Text(
                                  key,
                                  style: TextStyle(
                                    color: MyConstant.themeApp,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                        .values
                        .toList(),
                    onChanged: (num? value) {
                      setState(() {
                        eventModel.usageTime = value!;
                      });
                    },
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(
                width: width * 1,
                height: height * 0.3,
                child: eventModel.lat == 0 || eventModel.lng == 0
                    ? const PouringHourGlass()
                    : InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _navigationGoogleMap(context);
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              width: width * 1,
                              height: height * 0.3,
                              child: ShowMap(
                                lat: eventModel.lat,
                                lng: eventModel.lng,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: width * 0.4,
                                  height: 40,
                                  child: const Text(
                                    "เลือกตำแหน่งธุรกิจ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: MyConstant.themeApp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
              Container(
                width: width * 0.7,
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  child: const Text("บันทึกกิจกรรม"),
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(primary: MyConstant.themeApp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
