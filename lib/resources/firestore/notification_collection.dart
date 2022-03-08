import 'package:chanthaburi_app/models/notification/notification.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference notificationCollection =
    _firestore.collection(MyConstant.notificationCollection);

class NotificationCollection {
  static Future<void> createNotification(NotificationModel noti) async {
    try {
      await notificationCollection.add({
        "recipientId": noti.recipientId,
        "title": noti.title,
        "message": noti.message,
        "readingStatus": noti.readingStatus,
        "timeStamp": DateTime.now(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static Stream<QuerySnapshot<Object?>> notifications(String recipientId) {
    Stream<QuerySnapshot<Object?>> _notifications = notificationCollection
        .where('recipientId', isEqualTo: recipientId)
        .snapshots();
    return _notifications;
  }

  static Future<Map<String,dynamic>> deleteNotification(String docId) async {
    try {
      await notificationCollection.doc(docId).delete();
      return  {"status": "200", "message": "ลบการแจ้งเตือนเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบการแจ้งเตือนล้มเหลว"};
    }
  }
}
