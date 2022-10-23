import 'package:chanthaburi_app/models/history/history.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference historyClickOtopCollection =
    _firestore.collection(MyConstant.historyClickOtopCollection);
final CollectionReference historyClickRestaurantCollection =
    _firestore.collection(MyConstant.historyClickRestaurantCollection);

class HistoryCollection {
  Future<void> saveHistoryOtop(HistoryBusinessModel history) async {
    try {
      await historyClickOtopCollection.add(history.toMap());
    } catch (e) {
      print('e $e');
    }
  }

  Future<void> saveHistoryRestaurant(HistoryBusinessModel history) async {
    try {
      await historyClickRestaurantCollection.add(history.toMap());
    } catch (e) {
      print('e $e');
    }
  }
}
