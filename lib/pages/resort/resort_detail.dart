import 'package:chanthaburi_app/models/business/business.dart';
import 'package:chanthaburi_app/pages/resort/categort_resort.dart';
import 'package:chanthaburi_app/provider/participant_provider.dart';
import 'package:chanthaburi_app/resources/firestore/resort_collecttion.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResortDetail extends StatefulWidget {
  String resortId;
  ResortDetail({Key? key, required this.resortId}) : super(key: key);

  @override
  State<ResortDetail> createState() => _ResortDetailState();
}

class _ResortDetailState extends State<ResortDetail> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        backgroundColor: MyConstant.themeApp,
        title: const Text('บ้านพัก'),
      ),
      body: SafeArea(child: Consumer<ParticipantProvider>(
        builder: (context, ParticipantProvider participantProvider, child) {
          return FutureBuilder(
              future: ResortCollection.resortById(widget.resortId),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<BusinessModel>> snapshot) {
                if (snapshot.hasError) {
                  return const InternalError();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const PouringHourGlass();
                }
                BusinessModel? resort = snapshot.data!.data();
                return ListView(
                  children: [
                    buildDetailResort(width, height, resort!),
                    // const Padding(
                    //   padding: EdgeInsets.all(8.0),
                    //   child: Text(
                    //     'ประเภทห้องพัก',
                    //     style: TextStyle(fontSize: 18),
                    //   ),
                    // ),
                    CategoryResort(
                      resortId: widget.resortId,
                      resort: resort,
                      checkIn: participantProvider.partipant.checkIn,
                      checkOut: participantProvider.partipant.checkOut,
                      providerSelectRoom:
                          participantProvider.partipant.selectRoom,
                      totalRoom: participantProvider.partipant.totalRoom,
                    ),
                  ],
                );
              });
        },
      )),
    );
  }

  Container buildDetailResort(
      double width, double height, BusinessModel resort) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: width * 1,
      height: height * 0.32,
      child: Column(
        children: [
          SizedBox(
            width: width * 1,
            height: height * 0.2,
            child: ShowImageNetwork(
              pathImage: resort.imageRef,
              colorImageBlank: MyConstant.themeApp,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            child: Row(
              children: [
                Text(
                  resort.businessName,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, top: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey,
                ),
                Text(
                  resort.address,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
