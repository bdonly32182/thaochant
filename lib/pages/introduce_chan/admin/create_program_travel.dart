import 'dart:io';

import 'package:chanthaburi_app/models/program_travel/location_program.dart';
import 'package:chanthaburi_app/models/program_travel/program_travel.dart';
import 'package:chanthaburi_app/pages/introduce_chan/admin/create_location_program.dart';
import 'package:chanthaburi_app/resources/firestore/program_travel_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:chanthaburi_app/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateProgramTravel extends StatefulWidget {
  final ProgramTravelModel? programTravelModel;
  final String? docId;
  const CreateProgramTravel({
    Key? key,
    this.programTravelModel,
    this.docId,
  }) : super(key: key);

  @override
  State<CreateProgramTravel> createState() => _CreateProgramTravelState();
}

class _CreateProgramTravelState extends State<CreateProgramTravel> {
  TextEditingController programNameController = TextEditingController();
  TextEditingController rateDescriptionController = TextEditingController();
  TextEditingController introducePriceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  File? cover;
  List<String> imageLocationRemove = []; // for edit remove image in location
  ProgramTravelModel program = ProgramTravelModel(
    programName: '',
    dayIdList: [],
    rateDescription: '',
    introducePrice: '',
    price: 0,
    location: [],
    imageCover: '',
  );
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.programTravelModel != null) {
      setState(() {
        program = widget.programTravelModel!;
        programNameController.text = widget.programTravelModel!.programName;
        rateDescriptionController.text =
            widget.programTravelModel!.rateDescription;
        introducePriceController.text =
            widget.programTravelModel!.introducePrice;
        priceController.text = widget.programTravelModel!.price.toString();
      });
    }
  }

  createLocationProgram(BuildContext context, String dayId,
      LocationProgramModel? locationProgramModel) async {
    try {
      final LocationProgramModel? location = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => CreateLocationProgram(
            dayId: dayId,
            locationProgram: locationProgramModel,
            onDeletImage: addRemoveImage,
          ),
        ),
      );
      if (location != null) {
        setState(() {
          if (locationProgramModel != null) {
            program.location.remove(locationProgramModel);
          }
          program.location.add(location);
        });
      }
    } catch (e) {
      alertService(context, 'แจ้งเตือน', 'เกิดเหตุขัดข้องขออภัยในความไม่สะดวก');
    }
  }

  deleteLocationProgram(LocationProgramModel location) {
    setState(() {
      program.location.remove(location);
      imageLocationRemove.addAll(location.images);
    });
  }

  getImage() async {
    File? image = await PickerImage.getImage();
    if (image != null) {
      setState(() {
        cover = image;
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

  addRemoveImage(String imageRef) {
    setState(() {
      imageLocationRemove.add(imageRef);
    });
  }

  deleteDay(String dayId) {
    List<LocationProgramModel> locationById =
        program.location.where((element) => element.dayId == dayId).toList();
    for (var i = 0; i < locationById.length; i++) {
      deleteLocationProgram(locationById[i]);
    }
    setState(() {
      program.dayIdList.remove(dayId);
    });
  }

  onDeleteProgram() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> response =
        await ProgramTravelCollection.deleteProgramTravel(
            program, widget.docId!);
    Navigator.pop(context);
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext showContext) => ResponseDialog(response: response),
    );
  }

  onSubmit() async {
    if (program.location.isEmpty && widget.programTravelModel == null) {
      showDialog(
        context: context,
        builder: (BuildContext showContext) => const ResponseDialog(response: {
          "status": "400",
          "message": "กรุณาสร้างตำแหน่งสำหรับท่องเที่ยว"
        }),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          return const PouringHourGlass();
        },
      );

      program.programName = programNameController.text;
      program.introducePrice = introducePriceController.text;
      program.rateDescription = rateDescriptionController.text;
      program.price = double.parse(priceController.text);
      Map<String, dynamic>? response;
      if (widget.programTravelModel == null && widget.docId == null) {
        response =
            await ProgramTravelCollection.createProgramTravel(program, cover);
        _formKey.currentState!.reset();
      } else {
        response = await ProgramTravelCollection.editProgramTravel(
            program, cover, imageLocationRemove, widget.docId!);
      }
      // fix bug: เมื่อแก้ไขรูปโลเคชั่นอันแรก และ แก้ไขอันสอง อันแรกจะบันทึกรูปซ้ำเลยต้องเคลียร์ออก
      List<LocationProgramModel> newLocationProgram = [];
      for (var i = 0; i < program.location.length; i++) {
        LocationProgramModel oldLocation = program.location[i];
        newLocationProgram.add(
          LocationProgramModel(
            time: oldLocation.time,
            description: oldLocation.description,
            images: oldLocation.images,
            lat: oldLocation.lat,
            lng: oldLocation.lng,
            dayId: oldLocation.dayId,
            imagesFiles: [],
            locationName: oldLocation.locationName,
          ),
        );
      }
      setState(() {
        program.location = newLocationProgram;
      });
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response!),
      );
    }
  }

  takePhoto() async {
    File? takePhoto = await PickerImage.takePhoto();
    if (takePhoto != null) {
      setState(() {
        cover = takePhoto;
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Text('จัดการโปรแกรมท่องเที่ยว'),
        backgroundColor: MyConstant.colorGuide,
        actions: widget.docId != null
            ? [
                IconButton(
                  onPressed: onDeleteProgram,
                  icon: const Icon(Icons.delete),
                ),
              ]
            : [],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextFormField(
                  width,
                  programNameController,
                  "กรุณากรอกชื่อโปรแกรมท่องเที่ยว",
                  "ชื่อโปรแกรมท่องเที่ยว",
                  1,
                ),
                buildTextFormField(
                  width,
                  priceController,
                  "กรุณากรอกราคารวมทั้งหมด",
                  "ราคารวมทั้งหมด",
                  1,
                ),
                buildTextFormField(
                  width,
                  introducePriceController,
                  "กรุณากรอกแนะนำแพ็คเกจ + ราคา",
                  "แนะนำแพ็คเกจ + ราคา",
                  1,
                ),
                buildTextFormField(
                  width,
                  rateDescriptionController,
                  "กรุณากรอกอธิบายอัตตรารวมค่าบริการ",
                  "อธิบายอัตตรารวมค่าบริการ",
                  10,
                ),
                buildSelectCover(context, width),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      program.dayIdList.add(UniqueKey().toString());
                    });
                  },
                  child: Row(
                    children: const [
                      Text('จำนวนวันท่องเที่ยว'),
                      Icon(Icons.add),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: MyConstant.colorGuide,
                  ),
                ),
                buildSectionLocation(height, width),
                ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text("บันทึกข้อมูล"),
                  style: ElevatedButton.styleFrom(
                    primary: MyConstant.colorGuide,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildSectionLocation(double height, double width) {
    return SizedBox(
      height: height * 0.4,
      width: width * 1,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: program.dayIdList.length,
        itemBuilder: (context, index) {
          List<LocationProgramModel> locations = program.location
              .where(
                (element) => element.dayId == program.dayIdList[index],
              )
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('รอบและสถานที่ (วันที่ ${index + 1})'),
                  ),
                  ElevatedButton(
                    onPressed: () => createLocationProgram(
                        context, program.dayIdList[index], null),
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: MyConstant.colorGuide,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => deleteDay(program.dayIdList[index]),
                    child: Row(
                      children: const [
                        Icon(Icons.delete),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.3,
                width: width * 1,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: locations.length,
                  itemBuilder: (context, indexLocation) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'รอบ: ${locations[indexLocation].time} น. ',
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => createLocationProgram(
                                    context,
                                    program.dayIdList[index],
                                    locations[indexLocation],
                                  ),
                                  icon: Icon(
                                    Icons.edit,
                                    color: MyConstant.colorGuide,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => deleteLocationProgram(
                                    locations[indexLocation],
                                  ),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  InkWell buildSelectCover(BuildContext context, double width) {
    return InkWell(
      onTap: () {
        dialogCamera(context, getImage, takePhoto, MyConstant.colorGuide);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        width: width * .8,
        height: 150,
        child: cover != null
            ? Image.file(
                cover!,
                fit: BoxFit.cover,
              )
            : widget.programTravelModel != null
                ? ShowImageNetwork(
                    pathImage: widget.programTravelModel!.imageCover,
                    colorImageBlank: MyConstant.colorGuide,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: MyConstant.colorGuide,
                        size: 60,
                      ),
                      const Text('รูปภาพหน้าปก'),
                    ],
                  ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cover != null ? Colors.black54 : Colors.white,
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

  Row buildTextFormField(double width, TextEditingController controller,
      String invalidText, String label, int maxline) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
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
