import 'package:chanthaburi_app/models/question/answer.dart';
import 'package:chanthaburi_app/models/question/choice.dart';
import 'package:chanthaburi_app/models/question/question.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference questionCollection =
    _firestore.collection(MyConstant.questionCollection);

class QuestionCollection {
  static Stream<QuerySnapshot<QuestionModel>> questions() {
    Stream<QuerySnapshot<QuestionModel>> _questions = questionCollection
        .withConverter<QuestionModel>(
            fromFirestore: (_firestore, _) =>
                QuestionModel.fromMap(_firestore.data()!),
            toFirestore: (model, _) => model.toMap())
        .snapshots();
    return _questions;
  }

  static Future<QuerySnapshot<QuestionModel>> questionsAsync() async {
    QuerySnapshot<QuestionModel> _questions = await questionCollection
        .where("isHide", isEqualTo: false)
        .withConverter<QuestionModel>(
            fromFirestore: (_firestore, _) =>
                QuestionModel.fromMap(_firestore.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    return _questions;
  }

  static Stream<DocumentSnapshot<QuestionModel>> questionById(String docId) {
    Stream<DocumentSnapshot<QuestionModel>> _question = questionCollection
        .doc(docId)
        .withConverter<QuestionModel>(
            fromFirestore: (_firestore, _) =>
                QuestionModel.fromMap(_firestore.data()!),
            toFirestore: (model, _) => model.toMap())
        .snapshots();
    return _question;
  }

  static Future<Map<String, dynamic>> createQuestion(
      QuestionModel questionModel) async {
    try {
      print(questionModel.toMap());
      await questionCollection.add(questionModel.toMap());
      return {"status": "200", "message": "สร้างคำถามเรียบร้อย"};
    } catch (e) {
      print(e.toString());
      return {"status": "400", "message": "สร้างคำถามล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> submitQuestion(
      List<AnswerModel> answers) async {
    try {
      for (AnswerModel answer in answers) {
        Stream<DocumentSnapshot<QuestionModel>> _questionStream =
            questionById(answer.docId);
        DocumentSnapshot<QuestionModel> _question = await _questionStream.first;
        for (ChoiceModel choice in _question.data()!.choice) {
          if (choice.choiceId == answer.choice.choiceId) {
            await questionCollection.doc(answer.docId).update({
              "choice": FieldValue.arrayRemove([answer.choice.toMap()]),
            });
            await questionCollection.doc(answer.docId).update({
              "choice": FieldValue.arrayUnion([
                ChoiceModel.fromMap({
                  "answer": answer.choice.answer,
                  "choiceId": answer.choice.choiceId,
                  "count": choice.count + 1,
                  "createAt": answer.choice.createAt,
                }).toMap()
              ]),
            });
          }
        }
      }
      return {"status": "200", "message": "ขอบคุณสำหรับการตอบคำถามครับ"};
    } catch (e) {
      print(e.toString());
      return {"status": "400", "message": "ตอบคำถามล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> updateQuestion(
    String docId,
    bool isHide,
  ) async {
    try {
      await questionCollection.doc(docId).update({"isHide": isHide});
      return {"status": "200", "message": "แก้ไขสถานะคำถามเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขสถานะคำถามล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteQuestion(String docId) async {
    try {
      await questionCollection.doc(docId).delete();
      return {"status": "200", "message": "ลบคำถามเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบคำถามล้มเหลว"};
    }
  }
}
