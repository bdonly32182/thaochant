import 'dart:convert';

class ChoiceModel {
  String answer;
  int count;
  String choiceId;
  int createAt;
  ChoiceModel({
    required this.answer,
    required this.count,
    required this.choiceId,
    required this.createAt,
  });
  

  ChoiceModel copyWith({
    String? answer,
    int? count,
    String? choiceId,
    int? createAt,
  }) {
    return ChoiceModel(
      answer: answer ?? this.answer,
      count: count ?? this.count,
      choiceId: choiceId ?? this.choiceId,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'count': count,
      'choiceId': choiceId,
      'createAt': createAt,
    };
  }

  factory ChoiceModel.fromMap(Map<String, dynamic> map) {
    return ChoiceModel(
      answer: map['answer'] ?? '',
      count: map['count']?.toInt() ?? 0,
      choiceId: map['choiceId'] ?? '',
      createAt: map['createAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChoiceModel.fromJson(String source) => ChoiceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChoiceModel(answer: $answer, count: $count, choiceId: $choiceId, createAt: $createAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChoiceModel &&
      other.answer == answer &&
      other.count == count &&
      other.choiceId == choiceId &&
      other.createAt == createAt;
  }

  @override
  int get hashCode {
    return answer.hashCode ^
      count.hashCode ^
      choiceId.hashCode ^
      createAt.hashCode;
  }
}
