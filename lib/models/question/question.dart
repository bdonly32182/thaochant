import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:chanthaburi_app/models/question/choice.dart';

class QuestionModel {
  String question;
  List<ChoiceModel> choice;
  bool isHide;
  int createAt;
  QuestionModel({
    required this.question,
    required this.choice,
    required this.isHide,
    required this.createAt,
  });
  

  QuestionModel copyWith({
    String? question,
    List<ChoiceModel>? choice,
    bool? isHide,
    int? createAt,
  }) {
    return QuestionModel(
      question: question ?? this.question,
      choice: choice ?? this.choice,
      isHide: isHide ?? this.isHide,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'choice': choice.map((x) => x.toMap()).toList(),
      'isHide': isHide,
      'createAt': createAt,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'] ?? '',
      choice: List<ChoiceModel>.from(map['choice']?.map((x) => ChoiceModel.fromMap(x))),
      isHide: map['isHide'] ?? false,
      createAt: map['createAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) => QuestionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuestionModel(question: $question, choice: $choice, isHide: $isHide, createAt: $createAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is QuestionModel &&
      other.question == question &&
      listEquals(other.choice, choice) &&
      other.isHide == isHide &&
      other.createAt == createAt;
  }

  @override
  int get hashCode {
    return question.hashCode ^
      choice.hashCode ^
      isHide.hashCode ^
      createAt.hashCode;
  }
}
