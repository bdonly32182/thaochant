import 'package:chanthaburi_app/models/googlemap/google_map.dart';
import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/provider/address_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/shipping_address_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/map/google_map_fluter.dart';
import 'package:chanthaburi_app/utils/map/show_map.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_address.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class EditShippingAddress extends StatefulWidget {
  ShippingModel address;
  String docId;
  bool isCurrent;
  EditShippingAddress(
      {Key? key,
      required this.address,
      required this.docId,
      required this.isCurrent})
      : super(key: key);

  @override
  State<EditShippingAddress> createState() => _EditShippingAddressState();
}

class _EditShippingAddressState extends State<EditShippingAddress> {
  String userId = AuthMethods.currentUser();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  double? latitude, longitude;
  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = widget.address.fullName;
      _phoneController.text = widget.address.phoneNumber;
      _addressController.text = widget.address.address;
      latitude = widget.address.lat;
      longitude = widget.address.lng;
    });
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

  onDeleteAddress(BuildContext buildContext) async {
    if (!widget.isCurrent) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic>? response =
          await ShippingAddressCollection.deleteAddress(
        widget.docId,
      );
      Navigator.pop(buildContext); // close alert
      Navigator.pop(context); // close show dialog
      Navigator.pop(context); // pop to address
      Navigator.pop(context); // close bottomsheet
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext showContext) => const ResponseDialog(response: {
          "status": "199",
          "message": "ไม่สามารถลบที่อยู่ปัจจุบันได้"
        }),
      );
    }
  }

  onUpdateAddress() async {
    late BuildContext dialogContext;

    if (_formKey.currentState!.validate() &&
        latitude != null &&
        longitude != null) {
      _formKey.currentState!.save();
      ShippingModel address = ShippingModel(
        userId: userId,
        fullName: _nameController.text,
        address: _addressController.text,
        phoneNumber: _phoneController.text,
        lat: latitude!,
        lng: longitude!,
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          dialogContext = context;
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic>? response =
          await ShippingAddressCollection.editAddress(widget.docId, address);
      await SQLAdress().editAddress(userId, address);
      var addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      addressProvider.updateAddress(address);

      Navigator.pop(dialogContext);
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
      _formKey.currentState!.reset();
      setState(() {
        _nameController.clear();
        _phoneController.clear();
        _addressController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext showContext) => const ResponseDialog(
            response: {"status": "199", "message": "กรุณากรอกข้อมูลให้ครบ"}),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Text('แก้ไขที่อยู่'),
        backgroundColor: MyConstant.themeApp,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Text('ช่องทางติดต่อ'),
                      ],
                    ),
                  ),
                  buildFormField(
                    _nameController,
                    'ชื่อ นามสกุล',
                    Icons.person,
                  ),
                  buildFormField(
                    _phoneController,
                    'เบอร์โทรศัพท์',
                    Icons.phone_callback,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Text('ที่อยู่'),
                      ],
                    ),
                  ),
                  buildFormAddress(),
                  buildShowmap(width, height, context),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: double.maxFinite,
                    child: ElevatedButton(
                      child: const Text(
                        'ลบที่อยู่',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                      onPressed: () => dialogConfirm(
                        context,
                        "แจ้งเตือน",
                        "คุณแน่ใจแล้วที่จะลบที่อยู่รายการนี้ใช่หรือไม่",
                        onDeleteAddress,
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    width: double.maxFinite,
                    child: ElevatedButton(
                      child: const Text(
                        'ส่ง',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: onUpdateAddress,
                      style: ElevatedButton.styleFrom(
                          primary: MyConstant.themeApp),
                    ),
                  ),
                ],
              ),
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
                          "เลือกตำแหน่งที่อยู่",
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

  Container buildFormAddress() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _addressController,
        maxLines: 3,
        validator: (text) {
          if (text!.isEmpty) {
            return "กรุณากรอกรายละเอียดที่อยู่";
          }
          return null;
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: 'รายละเอียดที่อยู่',
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefix: Icon(Icons.location_pin, color: MyConstant.themeApp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Container buildFormField(TextEditingController textController,
      String labelText, IconData iconField) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: TextFormField(
        inputFormatters: labelText == "เบอร์โทรศัพท์" ? [phoneMask] : [],
        controller: textController,
        validator: (text) {
          if (text!.isEmpty) {
            return "กรุณากรอก$labelText";
          }
          return null;
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefix: Icon(iconField, color: MyConstant.themeApp),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
