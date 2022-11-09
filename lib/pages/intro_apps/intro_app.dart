import 'package:chanthaburi_app/models/thaochan_about/about_thaochan.dart';
import 'package:chanthaburi_app/models/user/personal_information.dart';
import 'package:chanthaburi_app/pages/intro_apps/avg_salary.dart';
import 'package:chanthaburi_app/pages/intro_apps/between_age.dart';
import 'package:chanthaburi_app/pages/intro_apps/cost_pay.dart';
import 'package:chanthaburi_app/pages/intro_apps/member_question.dart';
import 'package:chanthaburi_app/pages/intro_apps/personal_information.dart';
import 'package:chanthaburi_app/pages/lets_travel/question_filter.dart';
import 'package:chanthaburi_app/resources/firestore/about_thaochan_collection.dart';
import 'package:chanthaburi_app/resources/firestore/personal_information_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/video/play_video_network.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroApp extends StatefulWidget {
  const IntroApp({Key? key}) : super(key: key);

  @override
  State<IntroApp> createState() => _IntroAppState();
}

class _IntroAppState extends State<IntroApp> {
  final PageController controller = PageController(initialPage: 0);
  AboutThaoChanModel? aboutThaoChanModel;
  String gender = "";
  String betweenAge = "";
  String salary = "";
  String costPay = "";
  int amountMember = 0;
  bool isLastPage = false;

  onChangeMember(int totalMember) {
    setState(() {
      amountMember = totalMember;
    });
  }

  onChangeBetweenAge(String age) {
    setState(() {
      betweenAge = age;
    });
  }

  onChangeSalary(String selectSalary) {
    setState(() {
      salary = selectSalary;
    });
  }

  onChangeCostPay(String cost) {
    setState(() {
      costPay = cost;
    });
  }

  onChangeGender(String selectGender) {
    setState(() {
      gender = selectGender;
    });
  }

  fetchData() async {
    QuerySnapshot<AboutThaoChanModel> data =
        await AboutThaochanCollection.fetchData();
    setState(() {
      aboutThaoChanModel = data.docs.first.data();
    });
  }
  @override
  void initState() {
    fetchData();
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: MyConstant.backgroudApp,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => const QuestionFilter(),
                  ),
                  (route) => false);
            },
            child: const Text('SKIP'),
            style: TextButton.styleFrom(primary: MyConstant.themeApp),
          ),
        ],
      ),
      backgroundColor: MyConstant.backgroudApp,
      body: aboutThaoChanModel == null
          ? const PouringHourGlass()
          : Container(
              padding: EdgeInsets.only(bottom: height * 0.1),
              child: PageView(
                onPageChanged: (value) =>
                    setState(() => isLastPage = value == 5),
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: [
                  PlayVideoNetwork(pathVideo: aboutThaoChanModel!.imageURL),
                  PersonalInformation(
                    selected: gender,
                    onChange: onChangeGender,
                  ),
                  BetweenAge(
                    selected: betweenAge,
                    onChange: onChangeBetweenAge,
                  ),
                  AvgSalary(
                    selected: salary,
                    onChange: onChangeSalary,
                  ),
                  CostPay(
                    onChange: onChangeCostPay,
                    selected: costPay,
                  ),
                  MemberQuestion(
                    selected: amountMember,
                    onChange: onChangeMember,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(MyConstant.fillForm),
                  fit: BoxFit.contain,
                ),
              ),
            ),
      bottomSheet: Container(
        height: height * 0.1,
        decoration: BoxDecoration(color: MyConstant.backgroudApp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                controller.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('PREVIOUS'),
              style: TextButton.styleFrom(primary: MyConstant.themeApp),
            ),
            SmoothPageIndicator(
              controller: controller,
              count: 6,
              effect: WormEffect(
                activeDotColor: MyConstant.themeApp,
              ),
            ),
            TextButton(
              onPressed: () async {
                double? pageNumber = controller.page;
                if (pageNumber == 1 && gender.isEmpty) {
                  dialogAlert(
                    context,
                    'แจ้งเตือน',
                    'กรุณาเลือก 1 ตัวเลือก',
                  );
                  return;
                }
                if (pageNumber == 2 && betweenAge.isEmpty) {
                  dialogAlert(
                    context,
                    'แจ้งเตือน',
                    'กรุณาเลือก 1 ตัวเลือก',
                  );
                  return;
                }
                if (pageNumber == 3 && salary.isEmpty) {
                  dialogAlert(
                    context,
                    'แจ้งเตือน',
                    'กรุณาเลือก 1 ตัวเลือก',
                  );
                  return;
                }
                if (pageNumber == 4 && costPay.isEmpty) {
                  dialogAlert(
                    context,
                    'แจ้งเตือน',
                    'กรุณาเลือก 1 ตัวเลือก',
                  );
                  return;
                }
                if (pageNumber == 5 && amountMember == 0) {
                  dialogAlert(
                    context,
                    'แจ้งเตือน',
                    'กรุณาเลือก 1 ตัวเลือก',
                  );
                  return;
                }
                if (isLastPage) {
                  PersonalInformationModel personData =
                      PersonalInformationModel(
                    gender: gender,
                    age: betweenAge,
                    avgSalary: salary,
                    payForTravel: costPay,
                    memberForTravel: amountMember,
                  );
                  await PersonalInformationCollection.savePersonalData(
                      personData);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => const QuestionFilter(),
                      ),
                      (route) => false);
                  return;
                }
                controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(isLastPage ? "GET STARTED" : 'NEXT'),
              style: TextButton.styleFrom(primary: MyConstant.themeApp),
            ),
          ],
        ),
      ),
    );
  }
}
