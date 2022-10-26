import 'package:chanthaburi_app/models/program_travel/program_travel.dart';
import 'package:chanthaburi_app/pages/introduce_chan/admin/create_program_travel.dart';
import 'package:chanthaburi_app/resources/firestore/program_travel_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProgramList extends StatefulWidget {
  const ProgramList({Key? key}) : super(key: key);

  @override
  State<ProgramList> createState() => _ProgramListState();
}

class _ProgramListState extends State<ProgramList> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.colorGuide,
        title: const Text('โปรแกรมท่องเที่ยว'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateProgramTravel(),
                ),
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: ProgramTravelCollection.programTravels(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<ProgramTravelModel>> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PouringHourGlass();
          }
          List<QueryDocumentSnapshot<ProgramTravelModel>> programs =
              snapshot.data!.docs;
          return ListView.builder(
            itemCount: programs.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: height * .32,
                child: buildCardPackage(
                  size,
                  height,
                  programs[index].data(),
                  programs[index].id,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Container buildCardPackage(double width, double height,
      ProgramTravelModel program, String programId) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 17),
            blurRadius: 17,
            spreadRadius: -22,
            color: Colors.grey,
          ),
        ],
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreateProgramTravel(
                  programTravelModel: program,
                  docId: programId,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              SizedBox(
                width: width * 1,
                child: ShowImageNetwork(
                  pathImage: program.imageCover,
                  colorImageBlank: MyConstant.colorGuide,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: width * 1,
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 15, top: 5),
                          child: Text(
                            program.programName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
