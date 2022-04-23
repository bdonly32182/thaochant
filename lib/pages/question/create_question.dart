import 'package:chanthaburi_app/models/question/choice.dart';
import 'package:chanthaburi_app/models/question/question.dart';
import 'package:chanthaburi_app/resources/firestore/question_collection.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_alert.dart';
import 'package:chanthaburi_app/utils/dialog/dialog_confirm.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/widgets/loading/pouring_hour_glass.dart';
import 'package:chanthaburi_app/widgets/loading/response_dialog.dart';
import 'package:flutter/material.dart';

class CreateQuestion extends StatefulWidget {
  CreateQuestion({Key? key}) : super(key: key);

  @override
  State<CreateQuestion> createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  QuestionModel questionModel = QuestionModel(
    question: '',
    choice: [],
    isHide: false,
    createAt: DateTime.now().millisecondsSinceEpoch,
  );
  final _formKey = GlobalKey<FormState>();
  _addFieldChoice(index) {
    ChoiceModel jsonChoice = ChoiceModel(
      answer: '',
      choiceId: index,
      count: 0,
      createAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      questionModel.choice.add(jsonChoice);
    });
  }

  _updateNameChoice(String index, String value) {
    for (ChoiceModel choice in questionModel.choice) {
      if (choice.choiceId == index) {
        choice.answer = value;
      }
    }
  }

  _deleteChoice(index) {
    setState(() {
      questionModel.choice.removeAt(index);
    });
  }

  onCreateQuestion(BuildContext buildContext) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext showContext) {
        return const PouringHourGlass();
      },
    );
    questionModel.createAt = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> response =
        await QuestionCollection.createQuestion(questionModel);
    Navigator.pop(buildContext);
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext showContext) => ResponseDialog(response: response),
    );
    _formKey.currentState!.reset();
    setState(() {
      questionModel.choice = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("สร้างแบบสอบถาม"),
        backgroundColor: MyConstant.themeApp,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildFieldQuestion(width, _addFieldChoice),
                buildChoiceForm(width, height),
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    top: 15,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (questionModel.choice.isNotEmpty) {
                          dialogConfirm(
                            context,
                            "แจ้งเตือน",
                            "ท่านไม่สามารถแก้ไขคำถามนี้ได้หลังจากที่ท่านสร้างไปแล้ว ท่านยืนยันที่จะสร้างคำถามนี้ใช่หรือไม่",
                            onCreateQuestion,
                          );
                        } else {
                          dialogAlert(
                            context,
                            "แจ้งเตือน",
                            "กรุณาสร้างตัวเลือกคำตอบ",
                          );
                        }
                      }
                    },
                    child: const Text("สร้างคำถาม"),
                    style: ElevatedButton.styleFrom(
                      primary: MyConstant.themeApp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildFieldQuestion(double width, Function addFieldChoice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width * 0.7,
          child: TextFormField(
            maxLines: 3,
            validator: (String? value) {
              if (value!.isEmpty) return 'กรุณากรอกคำถาม';
              return null;
            },
            onSaved: (newValue) => questionModel.question = newValue!,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: 'คำถาม :',
              labelStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(
                Icons.question_answer,
                color: MyConstant.themeApp,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(
                color: MyConstant.themeApp, fontWeight: FontWeight.w700),
          ),
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0.2, 0.2),
            ),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            top: 15,
          ),
          child: ElevatedButton(
            onPressed: () {
              addFieldChoice(UniqueKey().toString());
            },
            child: Column(
              children: const [
                Icon(
                  Icons.add,
                ),
                Text("คำตอบ")
              ],
            ),
            style: ElevatedButton.styleFrom(
              primary: MyConstant.themeApp,
            ),
          ),
        ),
      ],
    );
  }

  ListView listViewPolicy(double width) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: questionModel.choice.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDismissible(
              index,
              width,
              questionModel.choice[index].choiceId.toString(),
              questionModel.choice[index].answer,
            ),
          ],
        );
      },
    );
  }

  Container buildChoiceForm(double width, double height) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: width * .8,
      height: height * .6,
      child: questionModel.choice.isNotEmpty ? listViewPolicy(width) : null,
    );
  }

  Dismissible buildDismissible(
      int index, double width, String idField, String valueChoice) {
    return Dismissible(
      key: Key(idField),
      direction: DismissDirection.endToStart,
      child: fieldOption(width, idField, valueChoice),
      onDismissed: (_) {
        _deleteChoice(index);
      },
      background: Container(
        color: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    );
  }

  SizedBox fieldOption(double width, String keyField, String valueNameChoice) {
    return SizedBox(
      width: width * 0.8,
      child: Column(
        children: [
          TextFormField(
            maxLines: 2,
            initialValue: valueNameChoice,
            onChanged: (value) {
              _updateNameChoice(keyField, value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return "กรุณากรอกตัวเลือกคำตอบ";
              }
              return null;
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: 'ตัวเลือกคำตอบ :',
              labelStyle: TextStyle(color: Colors.grey[600]),
              prefix: Icon(Icons.edit, color: MyConstant.themeApp),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(
              color: MyConstant.themeApp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Divider(
            color: MyConstant.themeApp,
            height: 20,
            thickness: 3.0,
          )
        ],
      ),
    );
  }
}
