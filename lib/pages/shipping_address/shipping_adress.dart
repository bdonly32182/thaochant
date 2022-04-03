import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/pages/shipping_address/create_shipping_address.dart';
import 'package:chanthaburi_app/pages/shipping_address/edit_shipping_address.dart';
import 'package:chanthaburi_app/provider/address_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/resources/firestore/shipping_address_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/map/show_map.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_address.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingAddress extends StatefulWidget {
  ShippingAddress({Key? key}) : super(key: key);

  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  String userId = AuthMethods.currentUser();
 
  onChangeAddress(ShippingModel address) async {
    await SQLAdress().editAddress(userId, address);
    var addressProvider = Provider.of<AddressProvider>(context, listen: false);
    addressProvider.updateAddress(address);
    Navigator.pop(context);
  }

  goBack() {
    Navigator.pop(context);
  }

  goEdit(BuildContext contextEdit, ShippingModel address, String docId, bool isCurrent) {
    Navigator.push(
      contextEdit,
      MaterialPageRoute(
        builder: (builder) => EditShippingAddress(address: address, docId: docId, isCurrent: isCurrent,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text('ที่อยู่ในการจัดส่ง'),
      ),
      body: 
      Consumer<AddressProvider>(builder: (BuildContext context,AddressProvider provider, Widget? child) {
          return 
          ListView(
        children: [
          
          
           buildShowmap(width, height, context,provider.address[0].lat,provider.address[0].lng),
              buildAddress(
                width,
                height,
                'ที่อยู่ปัจจุบัน',
                Icons.location_on_rounded,
                Colors.red.shade400,
                provider.address[0],
              ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('ที่อยู่ที่บันทึก'),
          ),
          buildCardNewAddress('เพิ่มที่อยู่ใหม่'),
          const Divider(
            height: 5,
          ),
          StreamBuilder(
            stream: ShippingAddressCollection.myAddress(userId),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<ShippingModel>> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('เกิดเหตุขัดข้อง'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const PouringHourGlass();
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext addressContext, int indexAddress) {
                  bool isCurrent = provider.address[0].lat ==
                          snapshot.data!.docs[indexAddress]["lat"] &&
                      provider.address[0].lng ==
                          snapshot.data!.docs[indexAddress]["lng"];
                  return InkWell(
                    onTap: () {
                      dialogAddress(
                        context,
                        isCurrent ? goBack : onChangeAddress,
                        goEdit,
                        snapshot.data!.docs[indexAddress].data(),
                        snapshot.data!.docs[indexAddress].id,
                        isCurrent,
                        MyConstant.themeApp,
                      );
                    },
                    child: buildAddress(
                      width,
                      height,
                      isCurrent ? 'ที่อยู่ปัจจุบัน' : 'อื่นๆ',
                      isCurrent ? Icons.location_pin : Icons.home_outlined,
                      isCurrent ? Colors.red : Colors.black,
                      snapshot.data!.docs[indexAddress].data(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      );
            },),
      
    );
  }

  SizedBox buildShowmap(double width, double height, BuildContext context, double? lat,lng) {
    return SizedBox(
      width: width * 1,
      height: height * 0.2,
      child: lat != null && lng != null
          ? Stack(
              children: [
                SizedBox(
                  width: width * 1,
                  height: height * 0.3,
                  child: ShowMap(
                    lat: lat,
                    lng: lng,
                  ),
                ),
              ],
            )
          : const PouringHourGlass(),
    );
  }

  Container buildCardNewAddress(String text) {
    return Container(
      height: 50,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => CreateShippingAddress(
                isNewAddress: false,
              ),
            ),
          );
        },
        child: Row(
          children: [
            const Icon(Icons.add),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      decoration: const BoxDecoration(color: Colors.white),
    );
  }

  Card buildAddress(double width, double height, String text, IconData icon,
      Color colorIcon, ShippingModel address) {
    return Card(
      child: Column(
        children: [
          Container(
            width: width * 0.9,
            margin: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: colorIcon,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width * 0.7,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    address.address,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: width * 0.7,
            margin: const EdgeInsets.only(
              top: 8.0,
              bottom: 10.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${address.fullName} | ${address.phoneNumber}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
