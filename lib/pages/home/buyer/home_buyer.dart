import 'package:chanthaburi_app/models/question/answer.dart';
import 'package:chanthaburi_app/pages/introduce_chan/map_shim_shop_shea.dart';
import 'package:chanthaburi_app/pages/lets_travel/question_filter.dart';
import 'package:chanthaburi_app/pages/location/locations.dart';
import 'package:chanthaburi_app/pages/otop/home_otop.dart';
import 'package:chanthaburi_app/pages/package_toure/buyer_home_tour.dart';
import 'package:chanthaburi_app/pages/resort/home_resort.dart';
import 'package:chanthaburi_app/pages/restaurant/home_restaurant.dart';
import 'package:chanthaburi_app/resources/firestore/event_collection.dart';
import 'package:chanthaburi_app/resources/firestore/question_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sharePreferrence/share_referrence.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:chanthaburi_app/widgets/show_image_network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeBuyer extends StatefulWidget {
  const HomeBuyer({Key? key}) : super(key: key);

  @override
  State<HomeBuyer> createState() => _HomeBuyerState();
}

class _HomeBuyerState extends State<HomeBuyer> {
  int dateTimeNow = DateTime.now().millisecondsSinceEpoch;
  bool fillQuestion = false;

  List<Map<String, dynamic>> menuCards = [
    {
      "title": 'ร้านอาหาร',
      "pathImage": MyConstant.thaiFood,
      "goWidget": HomeRestaurant(),
    },
    {
      "title": 'ผลิตภัณฑ์ชุมชน',
      "pathImage": MyConstant.otopPicture,
      "goWidget": HomeOtop(),
    },
    {
      "title": 'บ้านพัก',
      "pathImage": MyConstant.resortPicture,
      "goWidget": HomeResort(),
    },
    {
      "title": 'แหล่งท่องเที่ยว',
      "pathImage": MyConstant.locationPicture,
      "goWidget": Locations(isAdmin: false),
    },
    {
      "title": 'แพ็คเกจท่องเที่ยว',
      "pathImage": MyConstant.packagePicture,
      "goWidget": BuyerHomeTour(),
    },
    {
      "title": 'แนะนำโปรแกรมท่องเที่ยว',
      "pathImage": MyConstant.introduceTravel,
      "goWidget": const MapShimShopShea(),
    },
  ];

  onCheckTimeQuestion() async {
    int? nextTimeQuestion = await ShareRefferrence.getTimeQuestion();
    if (nextTimeQuestion != null && nextTimeQuestion <= dateTimeNow) {
      setState(() {
        fillQuestion = true;
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // onCheckTimeQuestion();
  // }

  onSkipForm() async {
    int dateTime =
        DateTime.now().add(const Duration(days: 14)).millisecondsSinceEpoch;
    await ShareRefferrence.setTimeQuestion(dateTime);
    setState(() {
      fillQuestion = false;
    });
  }

  onSubmitForm(List<AnswerModel> _selectChoice) async {
    late BuildContext dialogContext;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        dialogContext = context;
        return const PouringHourGlass();
      },
    );
    try {
      Map<String, dynamic> response =
          await QuestionCollection.submitQuestion(_selectChoice);
      DateTime dateNow = DateTime.now();
      int dateTime = DateTime(dateNow.year, dateNow.month + 3, dateNow.day)
          .millisecondsSinceEpoch;
      await ShareRefferrence.setTimeQuestion(dateTime);
      Navigator.pop(dialogContext);
      setState(() {
        fillQuestion = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext showContext) =>
            ResponseDialog(response: response),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => const QuestionFilter(),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ไม่รู้จะไปเที่ยวไหน?',
                                style: TextStyle(
                                  color: MyConstant.themeApp,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'ให้เราช่วยแนะนำไหม',
                                style: TextStyle(
                                  color: MyConstant.themeApp,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.map_outlined,
                          color: MyConstant.themeApp,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    height: height * 0.55,
                    width: width * 1,
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: height > 730
                          ? width / height / 0.36
                          : width / height / 1,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      children: List.generate(
                        menuCards.length,
                        (index) => menuCard(
                          context,
                          width,
                          menuCards[index]["goWidget"],
                          menuCards[index]["pathImage"],
                          menuCards[index]["title"],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "กิจกรรมที่น่าสนใจ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  buildEvent(width, height)
                ],
              ),
            ),
      // fillQuestion
      //     ? FutureBuilder(
      //         future: QuestionCollection.questionsAsync(),
      //         builder: (context,
      //             AsyncSnapshot<QuerySnapshot<QuestionModel>> snapshot) {
      //           if (snapshot.hasError) {
      //             return const InternalError();
      //           }
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return const PouringHourGlass();
      //           }
      //           List<QueryDocumentSnapshot<QuestionModel>> questions =
      //               snapshot.data!.docs;
      //           questions.sort(
      //             (a, b) => a.data().createAt.compareTo(b.data().createAt),
      //           );
      //           return SubmitForm(
      //             onSkip: onSkipForm,
      //             onSubmit: onSubmitForm,
      //             questions: questions,
      //           );
      //         })
          
          
    );
  }

  StreamBuilder buildEvent(double width, double height) {
    return StreamBuilder<QuerySnapshot>(
        stream: EventCollection.events(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const InternalError();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PouringHourGlass();
          }
          if (snapshot.data!.docs.isEmpty) {
            return buildEventEmpty(width, height);
          }
          return SizedBox(
            width: width * 1,
            height: height * 0.22,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (itemBuilder, index) => Container(
                margin: const EdgeInsets.all(10.0),
                width: width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ShowImageNetwork(
                    pathImage: snapshot.data!.docs[index]["url"],
                    colorImageBlank: MyConstant.themeApp,
                  ),
                ),
              ),
            ),
          );
        });
  }

  Container buildEventEmpty(double width, double height) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: width * 0.93,
      height: height * 0.2,
      child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "จะมีกิจกรรมเร็วๆ นี้",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.grey,
                      offset: Offset(0, 2.2),
                      blurRadius: 6,
                    )
                  ],
                ),
              ),
              Text(
                "ติดตามได้ที่นี่",
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.grey,
                      offset: Offset(0, 2.2),
                      blurRadius: 6,
                    )
                  ],
                ),
              )
            ],
          ),
          decoration: const BoxDecoration(
            color: Colors.black45,
          )),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(MyConstant.commingSoon),
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
    );
  }

  Card menuCard(BuildContext context, double width, Widget gotoWidget,
      String imageUrl, String? title) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => gotoWidget)),
        child: Stack(
          children: [
            SizedBox(
              width: width * 1,
              height: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: width * 1,
              child: Center(
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.grey,
                        offset: Offset(0, 2.2),
                        blurRadius: 6,
                      )
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
