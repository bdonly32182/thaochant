import 'package:chanthaburi_app/models/question/answer.dart';
import 'package:chanthaburi_app/models/question/choice.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chanthaburi_app/models/question/question.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';

class SubmitForm extends StatefulWidget {
  Function onSkip;
  Function onSubmit;
  List<QueryDocumentSnapshot<QuestionModel>> questions;
  SubmitForm({
    Key? key,
    required this.onSkip,
    required this.onSubmit,
    required this.questions,
  }) : super(key: key);

  @override
  State<SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  List<AnswerModel> _selectAnswer = [];
  onChangeChoice(bool selected, AnswerModel choice,
      QueryDocumentSnapshot<QuestionModel> questionModel) {
    if (selected) {
      for (ChoiceModel item in questionModel.data().choice) {
        AnswerModel answerModel = AnswerModel.fromMap(
            {"docId": questionModel.id, "choice": item.toMap()});
        if (_selectAnswer.contains(answerModel)) {
          _selectAnswer
              .removeWhere((choiceRemove) => choiceRemove == answerModel);
        }
      }
      setState(() {
        _selectAnswer.add(choice);
      });
    } else {
      setState(() {
        _selectAnswer.removeWhere((choiceRemove) => choiceRemove == choice);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyConstant.themeApp,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 1,
            height: height * 0.16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "แบบประเมิณความพึงพอใจ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "By Thaochant",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    buildListQuestion(width, widget.questions),
                    buildButton(width),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView buildListQuestion(
      double width, List<QueryDocumentSnapshot<QuestionModel>> questions) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: questions.length,
        itemBuilder: (_, index) {
          questions[index].data().choice.sort(
                (a, b) => a.createAt.compareTo(b.createAt),
              );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                child: Text(
                  "${index + 1}.  ${questions[index].data().question}",
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              buildChoice(questions, index, width),
            ],
          );
        });
  }

  ListView buildChoice(List<QueryDocumentSnapshot<QuestionModel>> questions,
      int index, double width) {
    List<ChoiceModel> choices = questions[index].data().choice;
    choices.sort((a, b) => a.createAt.compareTo(b.createAt));
    return ListView.builder(
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
          child: CheckboxListTile(
            activeColor: MyConstant.themeApp,
            title: Text(choices[indexChoice].answer),
            onChanged: (bool? selected) => onChangeChoice(
              selected!,
              AnswerModel.fromMap(
                {
                  "docId": questions[index].id,
                  "choice": choices[indexChoice].toMap(),
                },
              ),
              questions[index],
            ),
            value: _selectAnswer.contains(
              AnswerModel.fromMap(
                {
                  "docId": questions[index].id,
                  "choice": choices[indexChoice].toMap(),
                },
              ),
            ),
          )),
    );
  }

  Row buildButton(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: width * 0.3,
          child: ElevatedButton(
            child: Text(
              "ข้าม >",
              style: TextStyle(
                color: MyConstant.themeApp,
              ),
            ),
            onPressed: () => widget.onSkip(),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              side: BorderSide(
                color: MyConstant.themeApp,
              ),
            ),
          ),
        ),
        SizedBox(
          width: width * 0.3,
          child: ElevatedButton(
            child: const Text("ส่งคำตอบ"),
            onPressed: widget.questions.isNotEmpty
                ? () {
                    if (_selectAnswer.length == widget.questions.length) {
                      widget.onSubmit(_selectAnswer);
                    } else {
                      dialogAlert(
                          context, "แจ้งเตือน", "กรุณาตอบคำถามให้ครบทุกข้อ");
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(primary: MyConstant.themeApp),
          ),
        ),
      ],
    );
  }
}
