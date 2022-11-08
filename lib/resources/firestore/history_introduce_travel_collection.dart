import 'package:chanthaburi_app/models/lets_travel/history_introduce_travel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference historyIntroduceTravelCollection =
    _firestore.collection("historyIntroduceTravelCollection");
class HistoryIntroduceTravelCollection {
  static Future<void> saveHistory(HistoryIntroduceTravelModel history) async {
    await historyIntroduceTravelCollection.add(history.toMap());
  }
}