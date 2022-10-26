import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/business/time_turn_on_of.dart';
import 'package:chanthaburi_app/pages/business/setting/setting_time.dart';
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
  final String businessId, typeBusiness;
  const SettingBusiness({
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
    typePayment: '',
    times: [],
    visitType: '',
  );

  @override
  void initState() {
    super.initState();
    onFetchBusiness();
  }

  onFetchBusiness() async {
    if (widget.typeBusiness == MyConstant.foodCollection) {
      DocumentSnapshot<BusinessModel> _restaurant =
          await RestaurantCollection.restaurantById(widget.businessId);
      onSetBusiness(_restaurant);
    }
    if (widget.typeBusiness == MyConstant.productOtopCollection) {
      DocumentSnapshot<BusinessModel> _otop =
          await OtopCollection.otopById(widget.businessId);
      onSetBusiness(_otop);
    }
    if (widget.typeBusiness == MyConstant.roomCollection) {
      DocumentSnapshot<BusinessModel> _resort =
          await ResortCollection.resortById(widget.businessId);
      onSetBusiness(_resort);
    }
  }

  onSetBusiness(DocumentSnapshot<BusinessModel> business) {
    setState(() {
      _businessModel.address = business.data()!.address;
      _businessModel.businessName = business.data()!.businessName;
      _businessModel.imageRef = business.data()!.imageRef;
      _businessModel.latitude = business.data()!.latitude;
      _businessModel.longitude = business.data()!.longitude;
      _businessModel.link = business.data()!.link;
      _businessModel.sellerId = business.data()!.sellerId;
      _businessModel.phoneNumber = business.data()!.phoneNumber;
      _businessModel.policyName = business.data()!.policyName;
      _businessModel.policyDescription = business.data()!.policyDescription;
      _businessModel.paymentNumber = business.data()!.paymentNumber;
      _businessModel.statusOpen = business.data()!.statusOpen;
      _businessModel.qrcodeRef = business.data()!.qrcodeRef;
      _businessModel.typePayment = business.data()!.typePayment;
      _businessModel.times = business.data()!.times;
      _businessModel.visitType = business.data()!.visitType;
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
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 2,
              ),
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
            buildSettingTime(
              size,
              _businessModel.times,
              widget.businessId,
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

  Container buildSettingTime(
      Size size, List<TimeTurnOnOfModel> times, String businessId) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      width: size.width * 1,
      height: 60,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => SettingTime(
              times: times,
              businessId: businessId,
              typeBusiness: widget.typeBusiness,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'เวลาให้บริการของธุรกิจ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text('สามารถตั้งเวลาเปิด-ปิด ธุระกิจของท่านได้ที่นี่')
                ],
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
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
