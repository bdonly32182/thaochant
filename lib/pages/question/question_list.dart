import 'package:chanthaburi_app/models/question/question.dart';
import 'package:chanthaburi_app/resources/firestore/question_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/fetch/show_data_empty.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionList extends StatefulWidget {
  List<QueryDocumentSnapshot<QuestionModel>> questions;
  QuestionList({Key? key, required this.questions}) : super(key: key);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  onHideQuestion(BuildContext buildContext, String docId, bool isHide) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> response =
        await QuestionCollection.updateQuestion(docId, isHide);
    Navigator.pop(buildContext);
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext showContext) => ResponseDialog(response: response),
    );
  }

  onDeleteQuestion(BuildContext buildContext, String docId, bool isHide) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    Map<String, dynamic> response =
        await QuestionCollection.deleteQuestion(docId);
    Navigator.pop(buildContext);
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext showContext) => ResponseDialog(response: response),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.backgroudApp,
      body: widget.questions.isEmpty
          ? const Center(child: ShowDataEmpty())
          : ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: widget.questions.length,
              itemBuilder: (_, index) {
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              width: width * 0.76,
                              child: Text(
                                widget.questions[index].data().question,
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: width * 0.1,
                              child: IconButton(
                                icon: widget.questions[index].data().isHide
                                    ? const Icon(
                                        Icons.remove_red_eye_rounded,
                                      )
                                    : const Icon(
                                        Icons.remove_red_eye_outlined,
                                      ),
                                onPressed: () => dialogDeleteQuestion(
                                  context,
                                  widget.questions[index].id,
                                  "ท่านแน่ใจที่จะเปลี่ยนสถานะการโชว์คำถามใช่หรือไม่",
                                  !widget.questions[index].data().isHide,
                                  onHideQuestion,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.1,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                                onPressed: () => dialogDeleteQuestion(
                                  context,
                                  widget.questions[index].id,
                                  "ท่านแน่ใจที่ลบคำถามใช่หรือไม่",
                                  !widget.questions[index].data().isHide,
                                  onDeleteQuestion,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
