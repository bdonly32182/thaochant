import 'dart:io';

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/location/google_map.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/map/google_map_fluter.dart';
import 'package:chanthaburi_app/utils/map/show_map.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditBusiness extends StatefulWidget {
  String typeBusiness;
  BusinessModel businessModel;
  String businessId;

  EditBusiness({
    Key? key,
    required this.typeBusiness,
    required this.businessModel,
    required this.businessId,
  }) : super(key: key);

  @override
  State<EditBusiness> createState() => _EditBusinessState();
}

class _EditBusinessState extends State<EditBusiness> {
  BusinessModel? _businessModel;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? imageSelected;

  @override
  void initState() {
    super.initState();
    setState(() {
      _businessModel = widget.businessModel;
    });
  }

  getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageSelected = File(image.path);
      });
    }
  }

  takePhoto() async {
    final XFile? takePhoto = await _picker.pickImage(
        source: ImageSource.camera, maxWidth: 800, maxHeight: 500);
    if (takePhoto != null) {
      setState(() {
        imageSelected = File(takePhoto.path);
      });
    }
  }

  _addFieldPolicy(index) {
    Map<String, dynamic> jsonName = {
      "nameId": index,
      "value": '',
    };
    Map<String, dynamic> jsonPrice = {
      "descriptionPolicyId": index,
      "value": '',
    };
    setState(() {
      _businessModel!.policyDescription.add(jsonPrice);
      _businessModel!.policyName.add(jsonName);
    });
  }

  _updateNamePolicy(String index, String value) {
    for (var name in _businessModel!.policyName) {
      if (name['nameId'] == index) {
        name['value'] = value;
      }
    }
  }

  _updateDescriptionPolicy(String index, String value) {
    for (var description in _businessModel!.policyDescription) {
      if (description['descriptionPolicyId'] == index) {
        description['value'] = value;
      }
    }
  }

  _deletePolicy(index) {
    setState(() {
      _businessModel!.policyName.removeAt(index);
      _businessModel!.policyDescription.removeAt(index);
    });
  }

  _onSubmit(String typeBusiness) async {
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
      Map<String, dynamic>? response;
      if (typeBusiness == MyConstant.foodCollection) {
        response = await RestaurantCollection.editRestaurant(
            widget.businessId, _businessModel!, imageSelected);
      }
      if (typeBusiness == MyConstant.productOtopCollection) {
        response = await OtopCollection.editOtop(
            widget.businessId, _businessModel!, imageSelected);
      }
      if (typeBusiness == MyConstant.roomCollection) {
        response = await ResortCollection.editResort(
            widget.businessId, _businessModel!, imageSelected);
      }
      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response!),
      );
      _formKey.currentState!.reset();
    }
  }

  onDeleteBusiness(BuildContext context, String typeBusiness) async {
    Map<String, dynamic>? response;
    if (typeBusiness == MyConstant.foodCollection) {
      response = await RestaurantCollection.deleteRestaurant(
          widget.businessId, _businessModel!.imageRef);
    }
    if (typeBusiness == MyConstant.productOtopCollection) {
      response = await OtopCollection.deleteOtop(
          widget.businessId, _businessModel!.imageRef);
    }
    if (typeBusiness == MyConstant.roomCollection) {
      response = await ResortCollection.deleteResort(
          widget.businessId, _businessModel!.imageRef);
    }
    Navigator.pop(context);
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext showContext) =>
          ResponseDialog(response: response!),
    );
  }

  _navigationGoogleMap(BuildContext context) async {
    try {
      final GoogleMapModel _result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) => SelectLocation(
            initLat: _businessModel!.latitude,
            initLng: _businessModel!.longitude,
          ),
        ),
      );

      setState(() {
        _businessModel!.latitude = _result.latitude!;
        _businessModel!.longitude = _result.longitude!;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลธุรกิจ'),
        backgroundColor: MyConstant.colorStore,
        actions: [
          IconButton(
            onPressed: () {
              onDeleteBusiness(context, widget.typeBusiness);
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  inputName(width),
                  const SizedBox(height: 20),
                  inputPhone(width),
                  inputLink(width),
                  inputPrompPay(width),
                  inputAddress(width),
                  const SizedBox(height: 25),
                  buildShowmap(width, height, context),
                  buildTextSelectImage(),
                  buildPhoto(width),
                  const SizedBox(height: 20),
                  buildCreateOption(
                    'เพิ่มนโยบายของธุรกิจ',
                    _addFieldPolicy,
                  ),
                  buildPolicyForm(width, height),
                  buildCreateShopButton(width),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row inputPrompPay(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          child: TextFormField(
            initialValue: _businessModel!.promptPay,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกพร้อมเพย์';
              return null;
            },
            onSaved: (promptpay) => _businessModel!.promptPay = promptpay ?? '',
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'พร้อมเพย์ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.account_balance,
                  color: MyConstant.colorStore,
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
              color: MyConstant.colorStore,
              fontWeight: FontWeight.w700,
            ),
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

  SizedBox buildShowmap(double width, double height, BuildContext context) {
    return SizedBox(
      width: width * 1,
      height: height * 0.36,
      child: !_businessModel!.latitude.isNaN && !_businessModel!.longitude.isNaN
          ? InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _navigationGoogleMap(context);
              },
              child: Stack(
                children: [
                  SizedBox(
                    width: width * 1,
                    height: 200,
                    child: ShowMap(
                      lat: _businessModel!.latitude,
                      lng: _businessModel!.longitude,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width * 0.4,
                        height: 40,
                        child: const Text(
                          "เปลี่ยนตำแหน่งธุรกิจ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyConstant.colorStore,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const PouringHourGlass(),
    );
  }

  Row buildTextSelectImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'เลือกรูปภาพสำหรับธุรกิจ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: MyConstant.colorStore,
            ),
          ),
        )
      ],
    );
  }

  SizedBox buildCreateShopButton(double width) {
    return SizedBox(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        child: const Text(
          'แก้ไขธุรกิจ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => _onSubmit(widget.typeBusiness),
        style: ElevatedButton.styleFrom(
          primary: MyConstant.colorStore,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Container buildPolicyForm(double width, double height) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: width * .8,
      height: height * .45,
      child: _businessModel!.policyDescription.isNotEmpty
          ? listViewPolicy(width)
          : null,
    );
  }

  ListView listViewPolicy(double width) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _businessModel!.policyDescription.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDismissible(
              index,
              width,
              _businessModel!.policyDescription[index]['descriptionPolicyId']
                  .toString(),
              _businessModel!.policyName[index]['value'],
              _businessModel!.policyDescription[index]['value'],
            ),
          ],
        );
      },
    );
  }

  Dismissible buildDismissible(int index, double width, String idField,
      String valueNamePolicy, String descriptionPolicy) {
    return Dismissible(
      key: Key(idField),
      direction: DismissDirection.endToStart,
      child: fieldOption(width, idField, valueNamePolicy, descriptionPolicy),
      onDismissed: (_) {
        _deletePolicy(index);
      },
      background: Container(
        color: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    );
  }

  SizedBox fieldOption(double width, String keyField, String valueNamePolicy,
      String descriptionPolicy) {
    return SizedBox(
      width: width * 0.8,
      child: Column(
        children: [
          TextFormField(
            initialValue: valueNamePolicy,
            onChanged: (value) {
              _updateNamePolicy(keyField, value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "กรุณากรอกหัวข้อนโยบาย";
              }
              return null;
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: 'หัวข้อนโยบาย :',
              labelStyle: TextStyle(color: Colors.grey[600]),
              prefix: Icon(Icons.book, color: MyConstant.colorStore),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(
              color: MyConstant.colorStore,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextFormField(
            maxLines: 10,
            initialValue: descriptionPolicy,
            onChanged: (value) {
              _updateDescriptionPolicy(keyField, value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "กรุณากรอกคำอธิบายนโยบาย";
              }
              return null;
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: 'อธิบายนโยบาย :',
              labelStyle: TextStyle(color: Colors.grey[600]),
              prefix: Icon(Icons.policy_rounded, color: MyConstant.colorStore),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(
              color: MyConstant.colorStore,
              fontWeight: FontWeight.w700,
            ),
          ),
          Divider(
            color: MyConstant.colorStore,
            height: 20,
            thickness: 3.0,
          )
        ],
      ),
    );
  }

  Container buildCreateOption(String titleOption, Function addFieldOption) {
    return Container(
      margin: const EdgeInsets.only(left: 35),
      child: Row(
        children: [
          Text(
            titleOption,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: MyConstant.colorStore,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: ElevatedButton(
              onPressed: () {
                addFieldOption(UniqueKey().toString());
              },
              child: const Icon(
                Icons.add,
              ),
              style: ElevatedButton.styleFrom(
                primary: MyConstant.colorStore,
              ),
            ),
          )
        ],
      ),
    );
  }

  Row buildPhoto(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            dialogCamera(context, getImage, takePhoto);
          },
          child: Container(
            width: width * .6,
            height: 150,
            child: imageSelected != null
                ? Image.file(
                    imageSelected!,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    _businessModel!.imageRef,
                    fit: BoxFit.fitWidth,
                    width: width * 0.26,
                    height: 110.0,
                    errorBuilder:
                        (BuildContext buildImageError, object, stackthree) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: MyConstant.colorStore,
                            size: 60,
                          ),
                        ],
                      );
                    },
                  ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: imageSelected != null ? Colors.black54 : Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black54,
                  offset: Offset(0, 5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row inputAddress(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          child: TextFormField(
            initialValue: _businessModel!.address,
            maxLines: 3,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกรายละเอียดที่อยู่';
              return null;
            },
            onSaved: (address) => _businessModel!.address = address ?? '',
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'รายละเอียดที่อยู่:',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.location_on,
                  color: MyConstant.colorStore,
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
              color: MyConstant.colorStore,
              fontWeight: FontWeight.w700,
            ),
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

  Row inputPhone(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          child: TextFormField(
            initialValue: _businessModel!.phoneNumber,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกเบอร์โทรศัพท์';
              return null;
            },
            onSaved: (phone) => _businessModel!.phoneNumber = phone!,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'เบอร์โทรศัพท์ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.phone_in_talk_sharp,
                  color: MyConstant.colorStore,
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
              color: MyConstant.colorStore,
              fontWeight: FontWeight.w700,
            ),
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

  Row inputLink(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * .8,
          child: TextFormField(
            initialValue: _businessModel!.link,
            keyboardType: TextInputType.phone,
            onSaved: (link) => _businessModel!.link = link ?? '',
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ลิ้งค์แนะนำธุรกิจ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.link,
                  color: MyConstant.colorStore,
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
              color: MyConstant.colorStore,
              fontWeight: FontWeight.w700,
            ),
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

  Row inputName(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: width * .8,
          child: TextFormField(
            initialValue: _businessModel!.businessName,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกชื่อธุรกิจ';
              return null;
            },
            onSaved: (businessName) =>
                _businessModel!.businessName = businessName!,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                labelText: 'ชื่อธุรกิจ :',
                labelStyle: TextStyle(color: Colors.grey[600]),
                prefix: Icon(
                  Icons.store_outlined,
                  color: MyConstant.colorStore,
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
              color: MyConstant.colorStore,
              fontWeight: FontWeight.w700,
            ),
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
