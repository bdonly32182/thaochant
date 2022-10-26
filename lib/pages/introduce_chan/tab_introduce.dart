import 'package:chanthaburi_app/models/program_travel/program_travel.dart';
import 'package:chanthaburi_app/pages/introduce_chan/map_program_travel.dart';
import 'package:chanthaburi_app/pages/introduce_chan/map_shim_shop_shea.dart';
import 'package:chanthaburi_app/pages/introduce_chan/program_travel_detail.dart';
import 'package:chanthaburi_app/resources/firestore/program_travel_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TabIntroduce extends StatefulWidget {
  final String docId;
  const TabIntroduce({
    Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  State<TabIntroduce> createState() => _TabIntroduceState();
}

class _TabIntroduceState extends State<TabIntroduce> {
  void onTap(int tabNumber) {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: StreamBuilder(
        stream: ProgramTravelCollection.programTravel(widget.docId),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<ProgramTravelModel>> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PouringHourGlass();
          }
          ProgramTravelModel? programTravel = snapshot.data!.data();
          if (programTravel == null) {
            return const InternalError();
          }
          final TabController tabController = DefaultTabController.of(context)!;
          return Scaffold(
            appBar: AppBar(
              title: Text(programTravel.programName),
              backgroundColor: MyConstant.themeApp,
              bottom: TabBar(
                controller: tabController,
                labelColor: Colors.white,
                onTap: (int tabNumber) => onTap(tabNumber),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.list_alt_outlined),
                    // text: "ชิม/ช็อป/แชะ",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.location_on_outlined,
                    ),
                    // text: "อนุมัติพาร์ทเนอร์",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ProgramTravelDetail(programTravel: programTravel),
                MapProgramTravel(programTravel: programTravel)
              ],
            ),
          );
        },
      ),
    );
  }
}
