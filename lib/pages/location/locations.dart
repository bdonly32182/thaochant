import 'package:chanthaburi_app/pages/location/component/card_location.dart';
import 'package:chanthaburi_app/pages/location/create_location.dart';
import 'package:chanthaburi_app/resources/firestore/location_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Locations extends StatefulWidget {
  bool isAdmin;
  Locations({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      appBar: AppBar(
        title: const Center(
          child: Text("แหล่งท่องเที่ยว"),
        ),
        actions: widget.isAdmin
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => CreateLocations(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    size: 30,
                  ),
                ),
              ]
            : [],
        backgroundColor: MyConstant.colorLocation,
      ),
      body: StreamBuilder(
        stream: LocationCollection.locations(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: ShowDataEmpty());
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    height: size.height * 1,
                    width: size.width * 1,
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: size.height > 730
                          ? size.width / size.height / .65
                          : size.width / size.height / 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      children: List.generate(
                        snapshot.data!.docs.length,
                        (index) => CardLocation(
                          locationId: snapshot.data!.docs[index].id,
                          listImage: List<String>.from(
                              snapshot.data!.docs[index]['imageList']),
                          locationName: snapshot.data!.docs[index]
                              ['locationName'],
                          point: snapshot.data!.docs[index]['point'],
                          ratingCount: snapshot.data!.docs[index]
                              ['ratingCount'],
                          address: snapshot.data!.docs[index]['address'],
                          description: snapshot.data!.docs[index]
                              ['description'],
                          videoRef: snapshot.data!.docs[index]['videoRef'],
                          isAdmin: widget.isAdmin,
                          lat: snapshot.data!.docs[index]['lat'],
                          lng: snapshot.data!.docs[index]['lng'],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const PouringHourGlass();
        },
      ),
    );
  }
}
