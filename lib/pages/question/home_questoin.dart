import 'package:chanthaburi_app/models/question/question.dart';
import 'package:chanthaburi_app/pages/question/create_question.dart';
import 'package:chanthaburi_app/pages/question/question_dashboard.dart';
import 'package:chanthaburi_app/pages/question/question_list.dart';
import 'package:chanthaburi_app/resources/firestore/question_collection.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/error/internal_error.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeQuestion extends StatefulWidget {
  HomeQuestion({Key? key}) : super(key: key);

  @override
  State<HomeQuestion> createState() => _HomeQuestionState();
}

class _HomeQuestionState extends State<HomeQuestion> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyConstant.themeApp,
          title: const Text("แบบสอบถาม"),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => CreateQuestion(),
                ),
              ),
              icon: const Icon(Icons.add),
            )
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.question_answer),
                text: "แบบสอบถาม",
              ),
              Tab(
                icon: Icon(
                  Icons.dashboard,
                ),
                text: "สถิติ",
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot<QuestionModel>>(
            stream: QuestionCollection.questions(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<QuestionModel>> snapshot) {
              if (snapshot.hasError) {
                return const InternalError();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const PouringHourGlass();
              }
              List<QueryDocumentSnapshot<QuestionModel>> _questions =
                  snapshot.data!.docs;
              _questions.sort(
                (a, b) => a.data().createAt.compareTo(b.data().createAt),
              );
              return TabBarView(
                children: [
                  QuestionList(
                    questions: _questions,
                  ),
                  DashboardQuestion(
                    questions: _questions,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
