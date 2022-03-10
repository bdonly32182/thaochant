import 'dart:io';

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/location/google_map.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/resources/firestore/user_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/imagePicture/picker_image.dart';
import 'package:chanthaburi_app/utils/map/geolocation.dart';
import 'package:chanthaburi_app/utils/map/google_map_fluter.dart';
import 'package:chanthaburi_app/utils/map/show_map.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CreateStore extends StatefulWidget {
  String title;
  String typeBusiness;
  String? sellerId;
  CreateStore({
    Key? key,
    required this.title,
    required this.typeBusiness,
    this.sellerId,
  }) : super(key: key);

  @override
  _CreateStoreState createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  final BusinessModel _businessModel =
      BusinessModel('', '', 0, 0, [], [], '', '', 1, "0", "", "");
  final _formKey = GlobalKey<FormState>();
  double? latitude, longitude;
  List<QueryDocumentSnapshot> sellerList = [];
  final List<String> _categoryRestaurant = [
    'อาหารไทย',
    'อีสาน',
    'สตรีทฟู้ด/รถเข็น',
    'ของหวาน',
    'ก๋วยเตี๋ยว',
    'อาหารประเภทเส้น',
    'อาหารทะเล',
    'อาหารจานเดียว',
    'เบเกอรี่',
    'เครื่องดื่ม',
  ];
  @override
  void initState() {
    super.initState();
    checkPermission();
    if (widget.sellerId == null) {
      fetchSellers();
    }
  }

  void checkPermission() async {
    Position positionBuyer = await determinePosition();
    _businessModel.latitude = positionBuyer.latitude;
    _businessModel.longitude = positionBuyer.longitude;
    setState(() {
      latitude = positionBuyer.latitude;
      longitude = positionBuyer.longitude;
    });
  }

  void fetchSellers() async {
    try {
      QuerySnapshot<Object?> sellers = await UserCollection.dropdownSeller();
      setState(() {
        sellerList = sellers.docs;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  File? imageSelected;
  List<Map<String, dynamic>>? _valuePolicyName = [];
  List<Map<String, dynamic>>? _valuePolicyDescription = [];
  getImage() async {
     File? image = await PickerImage.getImage();
    if (image != null) {
      setState(() {
        imageSelected = image;
      });
    }
  }

  takePhoto() async {
    File? takePhoto = await PickerImage.takePhoto();
    if (takePhoto != null) {
      setState(() {
        imageSelected = takePhoto;
      });
    }
  }

  _addFieldPolicy(index) {
    Map<String, dynamic> jsonName = {
      "nameId": index,
      "value": '',
    };
    Map<String, dynamic> jsonDescription = {
      "descriptionPolicyId": index,
      "value": '',
    };
    setState(() {
      _valuePolicyDescription!.add(jsonDescription);
      _valuePolicyName!.add(jsonName);
    });
  }

  _updateNamePolicy(String index, String value) {
    for (var name in _valuePolicyName!) {
      if (name['nameId'] == index) {
        name['value'] = value;
      }
    }
  }

  _updateDescriptionPolicy(String index, String value) {
    for (var price in _valuePolicyDescription!) {
      if (price['descriptionPolicyId'] == index) {
        price['value'] = value;
      }
    }
  }

  _deletePolicy(index) {
    setState(() {
      _valuePolicyName!.removeAt(index);
      _valuePolicyDescription!.removeAt(index);
    });
  }

  void _onSubmit(String typeBusiness) async {
    late BuildContext dialogContext;
    if (widget.sellerId != null) {
      _businessModel.sellerId = widget.sellerId!;
    }
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
      if (typeBusiness == 'restaurant') {
        response = await RestaurantCollection.createRestaurant(
            _businessModel, imageSelected, widget.sellerId == null);
      }
      if (typeBusiness == 'otop') {
        response = await OtopCollection.createOtop(
            _businessModel, imageSelected, widget.sellerId == null);
      }
      if (typeBusiness == 'resort') {
        response = await ResortCollection.createResort(
            _businessModel, imageSelected, widget.sellerId == null);
      }

      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response!),
      );
      _formKey.currentState!.reset();
      setState(() {
        _valuePolicyName = [];
        _valuePolicyDescription = [];
        imageSelected = null;
      });
    }
  }

  _navigationGoogleMap(BuildContext context) async {
    try {
      final GoogleMapModel _result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (builder) => SelectLocation(
            initLat: latitude!,
            initLng: longitude!,
          ),
        ),
      );

      setState(() {
        latitude = _result.latitude;
        longitude = _result.longitude;
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
        title: Text(widget.title),
        backgroundColor: MyConstant.colorStore,
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
                  dropdownSeller(width),
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

  Container dropdownSeller(double width) {
    return Container(
      width: width * 0.8,
      child: widget.sellerId == null ? buildDropdownSearch() : null,
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

  DropdownSearch<QueryDocumentSnapshot<Object?>> buildDropdownSearch() {
    return DropdownSearch(
      mode: Mode.MENU,
      items: sellerList,
      itemAsString: (QueryDocumentSnapshot<Object?>? item) =>
          item!.get("fullName"),
      maxHeight: 260,
      dropdownSearchDecoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: "เลือกเจ้าของธุรกิจ",
        contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: TextStyle(
          color: MyConstant.colorStore,
          fontWeight: FontWeight.w700,
        ),
      ),
      validator: (QueryDocumentSnapshot<Object?>? valid) {
        if (!valid!.exists) {
          return "กรุณากรอกเลือกเจ้าของร้าน";
        }
        return null;
      },
      onChanged: (QueryDocumentSnapshot<Object?>? query) =>
          _businessModel.sellerId = query!.id,
      loadingBuilder: (context, load) =>
          const Expanded(child: PouringHourGlass()),
      errorBuilder: (context, str, dy) =>
          const Text("ขออภัย ณ ขณะนี้เกิดเหตุขัดข้อง"),
      emptyBuilder: (context, searchEntry) =>
          const Text("ไม่มีข้อมูลผู้ประกอบการ"),
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
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกพร้อมเพย์';
              return null;
            },
            onSaved: (promptpay) => _businessModel.promptPay = promptpay ?? '',
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
      height: height * 0.3,
      child: latitude != null && longitude != null
          ? InkWell(
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
                      lat: latitude!,
                      lng: longitude!,
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
                          color: MyConstant.colorStore,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : PouringHourGlass(),
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
          'สร้างธุรกิจ',
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
      child: _valuePolicyDescription!.isNotEmpty ? listViewPolicy(width) : null,
    );
  }

  ListView listViewPolicy(double width) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _valuePolicyDescription!.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDismissible(
              index,
              width,
              _valuePolicyDescription![index]['descriptionPolicyId'].toString(),
              _valuePolicyName![index]['value'],
              _valuePolicyDescription![index]['value'],
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
            onSaved: (policyName) => _businessModel.policyName.add({
              "nameId": keyField,
              "value": policyName,
            }),
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
            onSaved: (policyDescription) =>
                _businessModel.policyDescription.add({
              "descriptionPolicyId": keyField,
              "value": policyDescription,
            }),
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
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: MyConstant.colorStore,
                        size: 60,
                      ),
                    ],
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
        )
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
            maxLines: 3,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกรายละเอียดที่อยู่';
              return null;
            },
            onSaved: (address) => _businessModel.address = address ?? '',
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
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกเบอร์โทรศัพท์';
              return null;
            },
            onSaved: (phone) => _businessModel.phoneNumber = phone!,
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
            keyboardType: TextInputType.phone,
            onSaved: (link) => _businessModel.link = link ?? '',
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
            validator: (value) {
              if (value!.isEmpty) return 'กรุณากรอกชื่อธุรกิจ';
              return null;
            },
            onSaved: (businessName) =>
                _businessModel.businessName = businessName!,
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
