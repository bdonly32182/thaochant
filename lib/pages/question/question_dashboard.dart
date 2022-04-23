import 'package:chanthaburi_app/models/question/choice.dart';
import 'package:chanthaburi_app/models/question/question.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardQuestion extends StatelessWidget {
  List<QueryDocumentSnapshot<QuestionModel>> questions;
  DashboardQuestion({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: questions.isEmpty
          ? const Center(child: ShowDataEmpty())
          : ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (_, index) {
                List<ChoiceModel> choices = questions[index].data().choice;
                choices.sort((a, b) => a.createAt.compareTo(b.createAt));
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      child: Text(
                        questions[index].data().question,
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: choices.length,
                      itemBuilder: (itemBuilder, indexChoice) => Card(
                        margin: const EdgeInsets.only(
                          left: 18.0,
                          right: 18.0,
                          top: 10.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: width * 0.8,
                                  child: Text(
                                    choices[indexChoice].answer,
                                    softWrap: true,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "จำนวน : ${choices[indexChoice].count}  คน"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
    );
  }
}
