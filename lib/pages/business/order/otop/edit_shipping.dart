import 'package:chanthaburi_app/models/otop/shipping_product.dart';
import 'package:chanthaburi_app/resources/firestore/shipping_product_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:flutter/material.dart';

class EditShippingProduct extends StatefulWidget {
  final ShippingProductModel shipping;
  final String docId;
  const EditShippingProduct({
    Key? key,
    required this.shipping,
    required this.docId,
  }) : super(key: key);

  @override
  State<EditShippingProduct> createState() => _EditShippingProductState();
}

class _EditShippingProductState extends State<EditShippingProduct> {
  TextEditingController shippingNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ShippingProductModel _shippingProductModel = ShippingProductModel(
    orderId: '',
    shippingDate: DateTime.now(),
    shippingNo: '',
    typeShipping: 'ไปรษณีย์ไทย',
  );
  List<DropdownMenuItem<String>> shippingItems = [
    'ไปรษณีย์ไทย',
    'Kerry Express',
    'Flash Express',
    'J&T Express',
    'DHL Express',
    'SCG EXPRESS'
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Text(
          value,
          style: TextStyle(
            color: MyConstant.colorStore,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }).toList();
  @override
  void initState() {
    super.initState();
    setState(() {
      _shippingProductModel = widget.shipping;
      shippingNoController.text = widget.shipping.shippingNo;
    });
  }

  onSubmit(ShippingProductModel shipping) async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext showContext) {
          return const PouringHourGlass();
        },
      );
      Map<String, dynamic> response =
          await ShippingProductColletion.editShippingProduct(
              shipping, widget.docId);
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
        title: const Text('จัดส่งสินค้า'),
        backgroundColor: MyConstant.colorStore,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          style: TextStyle(color: MyConstant.colorStore),
                          value: _shippingProductModel.typeShipping,
                          items: shippingItems,
                          onChanged: (String? value) {
                            if (value != null) {
                              _shippingProductModel.typeShipping = value;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: width * 0.7,
                    child: TextFormField(
                      controller: shippingNoController,
                      validator: (String? value) {
                        if (value == null) return 'กรุณากรอกหมายเลขการจัดส่ง';
                        return null;
                      },
                      onChanged: (String? value) =>
                          _shippingProductModel.shippingNo = value!,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'หมายเลขการจัดส่ง :',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(
                          Icons.delivery_dining,
                          color: MyConstant.colorStore,
                        ),
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
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0.2, 0.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10),
                width: double.maxFinite,
                child: ElevatedButton(
                  child: const Text('บันทึก'),
                  onPressed: () => onSubmit(_shippingProductModel),
                  style:
                      ElevatedButton.styleFrom(primary: MyConstant.colorStore),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
