import 'dart:io';

import 'package:chanthaburi_app/models/googlemap/google_map.dart';
import 'package:chanthaburi_app/models/location/location.dart';
import 'package:chanthaburi_app/resources/firestore/location_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/map/geolocation.dart';
import 'package:chanthaburi_app/utils/map/google_map_fluter.dart';
import 'package:chanthaburi_app/utils/map/show_map.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/video/play_video.dart';
import 'package:chanthaburi_app/utils/video/play_video_network.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EditLocation extends StatefulWidget {
  String locationId;
  LocationModel locationModel;
  EditLocation(
      {Key? key, required this.locationId, required this.locationModel})
      : super(key: key);

  @override
  State<EditLocation> createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  final _formKey = GlobalKey<FormState>();
  late VideoPlayerController _controller;
  List<File> listImageSelected = [];
  List<String> listImageDelete = [];
  LocationModel? _locationModel;
  File? fileVideo;

  @override
  void initState() {
    super.initState();
    checkPermission();
    onSetData();
  }
  void checkPermission() async {
    await determinePosition();
  }
  onSetData() async {
    try {
      setState(() {
        _locationModel = widget.locationModel;
      });
    } catch (e) {}
  }

  getImage() async {
    File? image = await PickerImage.getImage();
    if (image != null) {
      setState(() {
        listImageSelected.add(image);
      });
    }
  }

  takePhoto() async {
    File? takePhoto = await PickerImage.takePhoto();
    if (takePhoto != null) {
      setState(() {
        listImageSelected.add(takePhoto);
      });
    }
  }

  getVideo() async {
    File? video = await PickerImage.getVideo();
    if (video != null) {
      setState(() {
        fileVideo = video;
        _controller = VideoPlayerController.file(video);
      });
    } else {
      const ResponseDialog(
        response: {"status": "400", "message": "เลือกคลิปวิดิโอล้มเหลว"},
      );
    }
  }

  onSubmit() async {
    late BuildContext dialogContext;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          dialogContext = context;
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic> response = await LocationCollection.editLocation(
          _locationModel!,
          listImageSelected,
          listImageDelete,
          fileVideo,
          widget.locationId);
      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
      _formKey.currentState!.reset();
    }
  }

  _navigationGoogleMap(BuildContext context) async {
    try {
      final GoogleMapModel _result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) => SelectLocation(
            initLat: _locationModel!.lat,
            initLng: _locationModel!.lng,
          ),
        ),
      );
      if (_result.latitude != null && _result.longitude != null) {
        setState(() {
          _locationModel!.lat = _result.latitude!;
          _locationModel!.lng = _result.longitude!;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.colorLocation,
        title: const Text('สร้างข้อมูลแหล่งท่องเที่ยว'),
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Column(
              children: [
                fieldPlaceName(width),
                fieldAddress(width),
                fieldDescription(width),
                const SizedBox(
                  height: 30,
                ),
                buildShowmap(width, height, context),
                buildText('วิดิโอของแหล่งท่องเที่ยว(ขนาดไม่เกิน 500 MB)'),
                buildGetVideo(width, height),
                buildText('รูปภาพของแหล่งท่องเที่ยว'),
                buildListImage(context, width),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('แก้ไขแหล่งท่องเที่ยว'),
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                        primary: MyConstant.colorLocation),
                  ),
                ),
              ],
            ),
          ),
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
          _navigationGoogleMap(context);
        },
        child: Stack(
          children: [
            SizedBox(
              width: width * 1,
              height: height * 0.3,
              child: ShowMap(
                lat: _locationModel!.lat,
                lng: _locationModel!.lng,
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
                    color: MyConstant.colorLocation,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell buildGetVideo(double width, double height) {
    return InkWell(
      onTap: getVideo,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        width: width * 0.7,
        height: height * 0.24,
        child: fileVideo != null
            ? PlayVideo(fileVideo: fileVideo!)
            : _locationModel!.videoRef.isNotEmpty ? PlayVideoNetwork(pathVideo: _locationModel!.videoRef) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.video_collection,
                    color: Color.fromRGBO(159, 156, 213, 0.7),
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

  Row buildText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: MyConstant.colorLocation,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  InkWell buildListImage(BuildContext context, double width) {
    return InkWell(
      onTap: () =>
          dialogCamera(context, getImage, takePhoto, MyConstant.colorLocation),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        height: 150,
        child: listImageSelected.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: listImageSelected.length,
                itemBuilder: (itemBuilder, index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: width * 0.46,
                        child: Image.file(
                          listImageSelected[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 40,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              listImageSelected.removeAt(index);
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
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: _locationModel!.imageList.length,
                itemBuilder: (itemBuilder, index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: width * 0.46,
                        child: Image.network(
                          _locationModel!.imageList[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 40,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              listImageDelete
                                  .add(_locationModel!.imageList[index]);
                              _locationModel!.imageList.removeAt(index);
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

  Row fieldAddress(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          child: TextFormField(
            initialValue: _locationModel!.address,
            maxLines: 3,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกที่อยู่แหล่งท่องเที่ยว';
              return null;
            },
            onSaved: (address) => _locationModel!.address = address!,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'รายละเอียดที่อยู่:',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(
                  Icons.location_pin,
                  color: MyConstant.colorLocation,
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
              color: MyConstant.colorLocation,
              fontWeight: FontWeight.w700,
            ),
          ),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              )
            ],
          ),
        ),
      ],
    );
  }

  Row fieldDescription(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: const EdgeInsets.only(top: 20),
            width: width * .8,
            child: TextFormField(
              initialValue: _locationModel!.description,
              maxLines: 12,
              validator: (value) {
                if (value!.isEmpty) return 'กรุณากรอกรายละเอียดแหล่งท่องเที่ยว';
                return null;
              },
              onSaved: (description) =>
                  _locationModel!.description = description!,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'รายละเอียดสถานที่ท่องเที่ยว :',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(
                    Icons.description,
                    color: MyConstant.colorLocation,
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
                color: MyConstant.colorLocation,
                fontWeight: FontWeight.w700,
              ),
            ),
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 5))
            ])),
      ],
    );
  }

  Row fieldPlaceName(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: const EdgeInsets.only(top: 20),
            width: width * .8,
            height: 60,
            child: TextFormField(
              initialValue: _locationModel!.locationName,
              validator: (value) {
                if (value!.isEmpty) return 'กรุณากรอกชื่อสถานที่ท่องเที่ยว';
                return null;
              },
              onSaved: (locationName) =>
                  _locationModel!.locationName = locationName!,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'ชื่อสถานที่ท่องเที่ยว :',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(
                    Icons.edit_location_sharp,
                    color: MyConstant.colorLocation,
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
                  color: MyConstant.colorLocation, fontWeight: FontWeight.w700),
            ),
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
            ])),
      ],
    );
  }
}
