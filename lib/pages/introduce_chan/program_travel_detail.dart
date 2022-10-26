import 'package:card_swiper/card_swiper.dart';
import 'package:chanthaburi_app/models/program_travel/location_program.dart';
import 'package:chanthaburi_app/models/program_travel/program_travel.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:flutter/material.dart';

class ProgramTravelDetail extends StatefulWidget {
  final ProgramTravelModel programTravel;
  const ProgramTravelDetail({
    Key? key,
    required this.programTravel,
  }) : super(key: key);

  @override
  State<ProgramTravelDetail> createState() => _ProgramTravelDetailState();
}

class _ProgramTravelDetailState extends State<ProgramTravelDetail> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              width: width * 1,
              height: height * 0.28,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
                child: ShowImageNetwork(
                  pathImage: widget.programTravel.imageCover,
                  colorImageBlank: MyConstant.themeApp,
                ),
              ),
            ),
            SizedBox(
              height: height,
              child: Card(
                margin: const EdgeInsets.all(10),
                child: Swiper(
                  itemCount: widget.programTravel.dayIdList.length,
                  itemBuilder: (context, index) {
                    List<LocationProgramModel> locationsOfDays =
                        widget.programTravel.location
                            .where(
                              (element) =>
                                  element.dayId ==
                                  widget.programTravel.dayIdList[index],
                            )
                            .toList();
                    return Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 4,
                      ),
                      child: Column(
                        children: [
                          Text('วันที่ ${index + 1}'),
                          buildListLocation(
                            locationsOfDays,
                            width,
                            height,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(6),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.programTravel.introducePrice,
                      softWrap: true,
                    ),
                    Text(
                      widget.programTravel.rateDescription,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildListLocation(
      List<LocationProgramModel> locationsOfDays, double width, double height) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: locationsOfDays.length,
      itemBuilder: (context, lindex) {
        List<String> images = locationsOfDays[lindex].images;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("เวลา ${locationsOfDays[lindex].time}"),
            Text(
              locationsOfDays[lindex].description,
              softWrap: true,
            ),
            SizedBox(
              height: height * 0.2,
              child: buildListImage(
                images,
                width,
                height,
                locationsOfDays,
                lindex,
              ),
            ),
          ],
        );
      },
    );
  }

  ListView buildListImage(List<String> images, double width, double height,
      List<LocationProgramModel> locationsOfDays, int lindex) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (context, imindex) {
        return Container(
          margin: const EdgeInsets.all(6),
          width: width * 0.4,
          height: height * 0.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ShowImageNetwork(
              pathImage: images[imindex],
              colorImageBlank: MyConstant.themeApp,
            ),
          ),
        );
      },
    );
  }
}
