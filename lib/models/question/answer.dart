import 'dart:convert';

import 'package:chanthaburi_app/models/question/choice.dart';

class AnswerModel {
  String docId;
  ChoiceModel choice;
  AnswerModel({
    required this.docId,
    required this.choice,
  });

  AnswerModel copyWith({
    String? docId,
    ChoiceModel? choice,
  }) {
    return AnswerModel(
      docId: docId ?? this.docId,
      choice: choice ?? this.choice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'choice': choice.toMap(),
    };
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      docId: map['docId'] ?? '',
      choice: ChoiceModel.fromMap(map['choice']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AnswerModel.fromJson(String source) => AnswerModel.fromMap(json.decode(source));

  @override
  String toString() => 'AnswerModel(docId: $docId, choice: $choice)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AnswerModel &&
      other.docId == docId &&
      other.choice == choice;
  }

  @override
  int get hashCode => docId.hashCode ^ choice.hashCode;
}
