import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/models/resort/room.dart';
import 'package:chanthaburi_app/models/shipping/shipping.dart';
import 'package:chanthaburi_app/pages/detail_business/detail_business.dart';
import 'package:chanthaburi_app/pages/resort/checkout_booking.dart';
import 'package:chanthaburi_app/pages/shipping_address/address_info.dart';
import 'package:chanthaburi_app/pages/shipping_address/create_shipping_address.dart';
import 'package:chanthaburi_app/pages/shipping_address/shipping_adress.dart';
import 'package:chanthaburi_app/provider/address_provider.dart';
import 'package:chanthaburi_app/provider/participant_provider.dart';
import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sqlite/sql_address.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingResort extends StatefulWidget {
  BusinessModel resort;
  RoomModel room;
  String resortId;
  int totalRoom;
  String roomId;
  int providerSelectRoom;
  List<dynamic> policyDescription;
  List<dynamic> policyName;
  BookingResort({
    Key? key,
    required this.resort,
    required this.room,
    required this.resortId,
    required this.totalRoom,
    required this.roomId,
    required this.providerSelectRoom,
    required this.policyDescription,
    required this.policyName,
  }) : super(key: key);

  @override
  State<BookingResort> createState() => _BookingResortState();
}

class _BookingResortState extends State<BookingResort> {
  String userId = AuthMethods.currentUser();
  int reserveRoom = 1;
  fetchAddress() async {
    List<ShippingModel> addressList = await SQLAdress().myAddress(userId);
    if (addressList.isNotEmpty) {
      var addressProvider =
          Provider.of<AddressProvider>(context, listen: false);
      addressProvider.createAddress(addressList[0]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAddress();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(widget.policyDescription);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text('จองห้องพัก'),
      ),
      backgroundColor: MyConstant.backgroudApp,
      body: Form(
        child: Consumer<ParticipantProvider>(
          builder: (BuildContext context, ParticipantProvider provider,
              Widget? child) {
            return Consumer<AddressProvider>(
              builder: (BuildContext context, AddressProvider addressProvider,
                  Widget? child) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          buildCardDetailResort(width, height),
                          buildCardImage(
                              width, height, widget.room, reserveRoom),
                          Consumer<AddressProvider>(
                            builder: (BuildContext context,
                                AddressProvider addressProvider,
                                Widget? child) {
                              return AddressInfo(address: addressProvider.address, userId: userId);
                            },
                          ),
                        ],
                      ),
                    ),
                    buildPayment(height, context, addressProvider, provider)
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Container buildPayment(double height, BuildContext context,
      AddressProvider addressProvider, ParticipantProvider provider) {
    return Container(
      width: double.maxFinite,
      height: height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ยอดรวมทั้งหมด',
                style: TextStyle(
                  color: Colors.grey[100],
                  fontSize: 16,
                ),
              ),
              Text(
                (reserveRoom * widget.room.price).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            child: Text(
              'ชำระเงิน',
              style: TextStyle(fontSize: 16, color: MyConstant.themeApp),
            ),
            onPressed: widget.providerSelectRoom > 0 &&
                    widget.providerSelectRoom < reserveRoom
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => CheckoutBooking(
                          businessId: widget.resortId,
                          address: addressProvider.address[0],
                          totalPrice: reserveRoom * widget.room.price,
                          prepaidPrice: (reserveRoom * widget.room.price) / 2,
                          checkIn: provider.partipant.checkIn,
                          checkOut: provider.partipant.checkOut,
                          roomId: widget.roomId,
                          totalSelectRoom: reserveRoom,
                        ),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(primary: Colors.white),
          ),
        ],
      ),
      decoration: BoxDecoration(color: MyConstant.themeApp),
    );
  }


  Card buildCardDetailResort(double width, double height) {
    return Card(
      child: SizedBox(
        width: width * 1,
        height: height * 0.25,
        child: Column(
          children: [
            buildRowDetailResort(width, height, widget.resort),
            const Divider(
              height: 5,
              thickness: 0.2,
            ),
            Consumer<ParticipantProvider>(
              builder: (BuildContext context, ParticipantProvider provider,
                  Widget? child) {
                return buildRowCheckinAndCheckout(
                  DateTime.fromMillisecondsSinceEpoch(
                      provider.partipant.checkIn),
                  DateTime.fromMillisecondsSinceEpoch(
                    provider.partipant.checkOut,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Row buildRowCheckinAndCheckout(DateTime checkIn, checkOut) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${checkIn.day}-${checkIn.month}-${checkIn.year}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Row(
              children: const [
                Text('14:00'),
              ],
            )
          ],
        ),
        const Icon(Icons.arrow_forward),
        Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${checkOut.day}-${checkOut.month}-${checkOut.year}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Row(
              children: const [
                Text('12:00'),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.dark_mode),
            ),
            Text("${checkOut.difference(checkIn).inDays} คืน"),
          ],
        )
      ],
    );
  }

  Row buildRowDetailResort(double width, double height, BusinessModel resort) {
    return Row(
      children: [
        SizedBox(
          width: width * 0.3,
          height: height * 0.16,
          child: ShowImageNetwork(
            colorImageBlank: MyConstant.themeApp,
            pathImage: resort.imageRef,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      resort.businessName,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Text(
                        resort.address,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Card buildCardImage(
      double width, double height, RoomModel room, int reserveRoom) {
    return Card(
      child: SizedBox(
        width: width * 1,
        height: height * 0.3,
        child: Column(
          children: [
            buildRoomHeader(room.roomName),
            Row(
              children: [
                buildImageRoom(height, width, room),
                buildColumnDetailRoom(room)
              ],
            ),
            const Divider(
              thickness: 0.5,
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Container buildRoomHeader(String roomName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 50,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.bed,
              color: MyConstant.themeApp,
            ),
          ),
          Text(
            "$reserveRoom x $roomName",
            style: TextStyle(
              color: MyConstant.themeApp,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 0.5),
            blurRadius: 1,
          ),
        ],
      ),
    );
  }

  Column buildColumnDetailRoom(RoomModel room) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Icon(Icons.group),
            ),
            Text('จำนวนผู้เข้าพักผู้ใหญ่: ${room.totalGuest} คน')
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Icon(Icons.meeting_room),
            ),
            Text('ขนาดห้องพัก ${room.roomSize} ตารางเมตร'),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Icon(
                Icons.policy,
                color: MyConstant.themeApp,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => DetailBusiness(
                      address: widget.resort.address,
                      businessId: widget.resortId,
                      businessName: widget.resort.businessName,
                      lat: widget.resort.latitude,
                      lng: widget.resort.longitude,
                      phoneNumber: widget.resort.phoneNumber,
                      point: widget.resort.point,
                      ratingCount: widget.resort.ratingCount,
                      policyDescription: widget.policyDescription,
                      policyName: widget.policyName, imageRef: widget.resort.imageRef,
                    ),
                  ),
                );
              },
              child: Text(
                'เงื่อนไขการจอง',
                style: TextStyle(
                  color: MyConstant.themeApp,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text("เลือกจำนวนห้องพัก: "),
            DropdownButton(
              items: List.generate(widget.totalRoom, (index) => index + 1)
                  .map((int selectedRoom) {
                return DropdownMenuItem(
                  child: Text(
                    "$selectedRoom",
                    style: TextStyle(
                      color: MyConstant.themeApp,
                      fontSize: 18,
                    ),
                  ),
                  value: selectedRoom,
                );
              }).toList(),
              value: reserveRoom,
              onChanged: (int? value) {
                setState(() {
                  reserveRoom = value!;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Container buildImageRoom(double height, double width, RoomModel room) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: height * 0.2,
      width: width * 0.3,
      child: ShowImageNetwork(
        colorImageBlank: MyConstant.themeApp,
        pathImage: room.imageCover,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
