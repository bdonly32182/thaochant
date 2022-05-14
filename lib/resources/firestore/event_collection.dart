import 'dart:io';

import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference eventCollection =
    _firestore.collection(MyConstant.eventCollection);

class EventCollection {
  static Stream<QuerySnapshot> events() {
    Stream<QuerySnapshot> _events = eventCollection.snapshots();
    return _events;
  }

  static Future<Map<String, dynamic>> createEvent(File eventRef) async {
    try {
      String fileName = basename(eventRef.path);
      String imageURL =
          await StorageFirebase.uploadImage("images/event/$fileName", eventRef);
      await eventCollection.add({"eventURL": imageURL});
      return {"status": "200", "message": "สร้างกิจกรรมเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างกิจกรรมล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteEvenet(
      String eventId, String imageUrl) async {
    try {
      String referenceImage = StorageFirebase.getReference(imageUrl);
      StorageFirebase.deleteFile(referenceImage);
      await eventCollection.doc(eventId).delete();
      return {"status": "200", "message": "ลบกิจกรรมเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบกิจกรรมล้มเหลว"};
    }
  }
}
