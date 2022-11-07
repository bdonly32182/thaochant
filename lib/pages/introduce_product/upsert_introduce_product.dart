import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/business/introduce_business.dart';
import 'package:chanthaburi_app/resources/firestore/introduce_product_collection.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_permission.dart';
import 'package:chanthaburi_app/utils/map/geolocation.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:chanthaburi_app/widgets/text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UpsertIntroduceProduct extends StatefulWidget {
  final IntroduceProductModel? introduceProductModel;
  final String? docId;
  const UpsertIntroduceProduct({
    Key? key,
    this.introduceProductModel,
    this.docId,
  }) : super(key: key);

  @override
  State<UpsertIntroduceProduct> createState() => _UpsertIntroduceProductState();
}

class _UpsertIntroduceProductState extends State<UpsertIntroduceProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController sequenceController = TextEditingController();
  IntroduceProductModel introduceProductModel = IntroduceProductModel(
    name: '',
    sequence: 0,
    lat: 0,
    lng: 0,
    businessId: '',
    totalSelected: 0,
    typeBusiness: '',
  );
  // BusinessModel? selectedRestaurant;
  List<QueryDocumentSnapshot<BusinessModel>> restaurants = [];
  List<QueryDocumentSnapshot<BusinessModel>> otops = [];
  String selectBusinessId = '';
  // BusinessModel? businessOfProduct;
  @override
  void initState() {
    super.initState();
    checkPermission();
    fetchBusiness();
    if (widget.introduceProductModel != null) {
      initSetData();
    }
  }

  initSetData() async {
    // BusinessModel? restaurantById;
    // if (widget.introduceProductModel!.typeBusiness == "restaurant") {
    //   DocumentSnapshot<BusinessModel> restaurant =
    //       await RestaurantCollection.restaurantById(
    //           widget.introduceProductModel!.businessId);
    //   // restaurantById = restaurant.data();
    // }
    // if (widget.introduceProductModel!.typeBusiness == "otop") {
    //   DocumentSnapshot<BusinessModel> otop = await OtopCollection.otopById(
    //       widget.introduceProductModel!.businessId);
    //   business = otop.data();
    // }

    setState(() {
      nameController.text = widget.introduceProductModel!.name;
      sequenceController.text =
          widget.introduceProductModel!.sequence.toString();
      introduceProductModel = widget.introduceProductModel!;
      // businessOfProduct = business;
      // selectedRestaurant = restaurantById;
    });
  }

  fetchBusiness() async {
    List<QueryDocumentSnapshot<BusinessModel>> respRestaurants =
        await RestaurantCollection.restaurants();
    List<QueryDocumentSnapshot<BusinessModel>> respOtops =
        await OtopCollection.otops();
    // List<BusinessModel> convertRestaurants = [];
    // List<BusinessModel> convertOtops = [];
    // for (int i = 0; i < respRestaurants.length; i++) {
    //   BusinessModel restaurant = respRestaurants[i].data();
    //   convertRestaurants.add(restaurant);
    // }
    // for (int i = 0; i < respOtops.length; i++) {
    //   BusinessModel otop = respOtops[i].data();
    //   convertOtops.add(otop);
    // }
    setState(() {
      restaurants = respRestaurants;
      otops = respOtops;
    });
  }

  void checkPermission() async {
    try {
      Position positionBuyer = await determinePosition();
      setState(() {
        introduceProductModel.lat = positionBuyer.latitude;
        introduceProductModel.lng = positionBuyer.longitude;
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

  onSubmit() async {
    if (introduceProductModel.businessId.isEmpty) {
      dialogAlert(context, "แจ้งเตือน", "กรุณาเลือกธุรกิจ");
      return;
    }
    if (_formKey.currentState!.validate()) {
      introduceProductModel.name = nameController.text;
      introduceProductModel.sequence = int.parse(sequenceController.text);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic> response =
          await IntroduceProductCollection.upsertIntroduceProduct(
              introduceProductModel, widget.docId);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
    }
  }

  onDeleteIntroduceProduct(BuildContext dialogContext) async {
    if (widget.docId != null) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic> response =
          await IntroduceProductCollection.deleteIntroduceProduct(
              widget.docId!);
      Navigator.pop(dialogContext);
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการแนะนำสินค้า'),
        backgroundColor: MyConstant.themeApp,
        actions: widget.introduceProductModel != null
            ? [
                IconButton(
                  onPressed: () => dialogConfirm(
                    context,
                    'แจ้งเตือน',
                    'คุณแน่ใจที่จะลบการแนะนำสินค้ารายการนี้ใช่หรือไม่',
                    onDeleteIntroduceProduct,
                  ),
                  icon: const Icon(
                    Icons.delete_forever,
                  ),
                ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: width * 0.7,
                  child: TextFormFieldCustom(
                    color: MyConstant.themeApp,
                    controller: nameController,
                    invalidText: "กรุณากรอกชื่อสินค้า",
                    label: "ชื่อสินค้า",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: width * 0.7,
                  child: TextFormFieldCustom(
                    color: MyConstant.themeApp,
                    controller: sequenceController,
                    invalidText: "กรุณากรอกลำดับของสินค้า",
                    label: "ลำดับของสินค้า(รวมกับลำดับกิจกรรม)",
                  ),
                ),
                dropdownBusiness(width, restaurants, "ร้านอาหาร", "restaurant"),
                dropdownBusiness(width, otops, "ร้านผลิตภัณฑ์ชุมชน", "otop"),
                const Text(
                  '* จะเลือกธุรกิจอันล่าสุดเท่านั้น',
                  style: TextStyle(color: Colors.red),
                ),
                // Container(
                //   margin: const EdgeInsets.all(10),
                //   width: width * 0.7,
                //   child: DropdownButtonHideUnderline(
                //     child: DropdownButton<QueryDocumentSnapshot<BusinessModel>>(
                //       style: TextStyle(color: MyConstant.colorStore),
                //       value: selectedRestaurant,
                //       items: restaurants
                //           .map<DropdownMenuItem<QueryDocumentSnapshot<BusinessModel>>>((restaurant) {
                //             BusinessModel business = restaurant.data();
                //         return DropdownMenuItem(
                //           child: Container(
                //             margin: const EdgeInsets.all(8),
                //             child: Text(
                //               business.businessName,
                //               style: TextStyle(
                //                 color: MyConstant.themeApp,
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.w600,
                //               ),
                //             ),
                //           ),
                //         );
                //       }).toList(),
                //       onChanged: (value) {
                //         setState(() {
                //           selectedRestaurant = value!.data();
                //           // introduceProductModel.businessId = value!.id;
                //           // introduceProductModel.lat = value.data().latitude;
                //           // introduceProductModel.lng = value.data().longitude;
                //           // selectedRestaurant = value;
                //           // introduceProductModel.typeBusiness = "restaurant";
                //         });
                //       },
                //     ),
                //   ),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                // ),
                Container(
                  width: width * 0.7,
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    child: const Text("บันทึกสินค้า"),
                    onPressed: onSubmit,
                    style:
                        ElevatedButton.styleFrom(primary: MyConstant.themeApp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container dropdownBusiness(
      double width,
      List<QueryDocumentSnapshot<BusinessModel>> business,
      String type,
      String typeBusiness) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
      width: width * 0.7,
      child: buildDropdownSearch(business, type, typeBusiness),
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

  DropdownSearch<QueryDocumentSnapshot<BusinessModel>> buildDropdownSearch(
    List<QueryDocumentSnapshot<BusinessModel>> business,
    String type,
    String typeBusiness,
  ) {
    return DropdownSearch(
      mode: Mode.MENU,
      items: business,
      itemAsString: (QueryDocumentSnapshot<BusinessModel>? item) =>
          item!.data().businessName,
      maxHeight: 260,
      dropdownSearchDecoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: "เลือก$type (เลือกได้อย่างใดอย่างหนึ่ง)",
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
      onChanged: (QueryDocumentSnapshot<BusinessModel>? query) {
        introduceProductModel.businessId = query!.id;
        introduceProductModel.lat = query.data().latitude;
        introduceProductModel.lng = query.data().longitude;
        introduceProductModel.typeBusiness = typeBusiness;
      },
      loadingBuilder: (context, load) =>
          const Expanded(child: PouringHourGlass()),
      errorBuilder: (context, str, dy) =>
          const Text("ขออภัย ณ ขณะนี้เกิดเหตุขัดข้อง"),
      emptyBuilder: (context, searchEntry) => Text("ไม่มี$type"),
    );
  }
}
