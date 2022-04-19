import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/pages/create_business/edit_business.dart';
import 'package:chanthaburi_app/pages/profile/profile.dart';
import 'package:chanthaburi_app/resources/firestore/otop_collection.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/resources/firestore/restaurant_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingBusiness extends StatefulWidget {
  String businessId, typeBusiness;
  SettingBusiness({
    Key? key,
    required this.businessId,
    required this.typeBusiness,
  }) : super(key: key);

  @override
  State<SettingBusiness> createState() => _SettingBusinessState();
}

class _SettingBusinessState extends State<SettingBusiness> {
  final BusinessModel _businessModel = BusinessModel(
    address: '',
    businessName: '',
    imageRef: '',
    latitude: 0,
    link: '',
    longitude: 0,
    phoneNumber: '',
    point: 0,
    policyDescription: [],
    policyName: [],
    paymentNumber: '',
    qrcodeRef: '',
    ratingCount: 0,
    sellerId: '',
    statusOpen: 1,
    startPrice: 0,
  );

  @override
  void initState() {
    super.initState();
    onFetchBusiness();
  }

  onFetchBusiness() async {
    if (widget.typeBusiness == MyConstant.foodCollection) {
      DocumentSnapshot _restaurant =
          await RestaurantCollection.restaurantById(widget.businessId);
      onSetBusiness(_restaurant);
    }
    if (widget.typeBusiness == MyConstant.productOtopCollection) {
      DocumentSnapshot _otop = await OtopCollection.otopById(widget.businessId);
      onSetBusiness(_otop);
    }
    if (widget.typeBusiness == MyConstant.roomCollection) {
      DocumentSnapshot _resort =
          await ResortCollection.resortById(widget.businessId);
      onSetBusiness(_resort);
    }
  }

  onSetBusiness(DocumentSnapshot business) {
    setState(() {
      _businessModel.address = business.get('address');
      _businessModel.businessName = business.get('businessName');
      _businessModel.imageRef = business.get('imageRef');
      _businessModel.latitude = business.get('latitude');
      _businessModel.longitude = business.get('longitude');
      _businessModel.link = business.get('link');
      _businessModel.sellerId = business.get('sellerId');
      _businessModel.phoneNumber = business.get('phoneNumber');
      _businessModel.policyName = business.get('policyName');
      _businessModel.policyDescription = business.get('policyDescription');
      _businessModel.paymentNumber = business.get('paymentNumber');
      _businessModel.statusOpen = business.get('statusOpen');
      _businessModel.qrcodeRef = business.get("qrcodeRef");
      if (widget.typeBusiness == MyConstant.roomCollection) {
        _businessModel.startPrice = business.get('startPrice') ?? 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.colorStore,
        toolbarHeight: size.height * 0.13,
        automaticallyImplyLeading: false,
        title: buildHeader(size, context),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              width: size.width * 1,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'สถานะธุรกิจ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text('สามารถเปิด-ปิด ธุระกิจของท่านได้ที่นี่')
                      ],
                    ),
                    ToggleSwitch(
                      totalSwitches: 2,
                      minWidth: 50.0,
                      cornerRadius: 20.0,
                      activeBgColors: [
                        [Colors.red.shade600],
                        [MyConstant.colorStore],
                      ],
                      labels: const ['ปิด', 'เปิด'],
                      activeFgColor: Colors.white,
                      inactiveBgColor: MyConstant.backgroudApp,
                      inactiveFgColor: Colors.grey,
                      initialLabelIndex: _businessModel.statusOpen,
                      radiusStyle: true,
                      onToggle: (index) async {
                        if (widget.typeBusiness == MyConstant.foodCollection &&
                            _businessModel.statusOpen != index) {
                          await RestaurantCollection.changeStatus(
                              widget.businessId, index);
                        }
                        if (widget.typeBusiness ==
                                MyConstant.productOtopCollection &&
                            _businessModel.statusOpen != index) {
                          await OtopCollection.changeStatus(
                              widget.businessId, index);
                        }
                        if (widget.typeBusiness == MyConstant.roomCollection &&
                            _businessModel.statusOpen != index) {
                          ResortCollection.changeStatus(
                              widget.businessId, index);
                        }
                      },
                    ),
                  ],
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'ตั้งค่าธุรกิจ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            buildCardSetting(context),
            buildRowChangeBusiness(size, context),
          ],
        ),
      ),
    );
  }

  Row buildRowChangeBusiness(Size size, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size.width * 0.6,
          margin: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  'เปลี่ยนธุรกิจ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              ],
            ),
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(primary: MyConstant.colorStore),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ],
    );
  }

  Card buildCardSetting(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => EditBusiness(
                  typeBusiness: widget.typeBusiness,
                  businessModel: _businessModel,
                  businessId: widget.businessId,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('แก้ไขข้อมูล'),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => Profile(theme: MyConstant.colorStore),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('บัญชีของฉัน'),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row buildHeader(Size size, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.9,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 5.0, right: 10.0),
                height: 80,
                width: size.width * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 4),
                  color: MyConstant.colorStore,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: size.width * 0.16,
                  child: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _businessModel.businessName,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
