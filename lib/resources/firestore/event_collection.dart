import 'dart:io';

import 'package:chanthaburi_app/models/events/event_model.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference eventCollection =
    _firestore.collection(MyConstant.eventCollection);

class EventCollection {
  static Stream<QuerySnapshot<EventModel>> events() {
    Stream<QuerySnapshot<EventModel>> _events = eventCollection
        .withConverter<EventModel>(
            fromFirestore: (snapshot, _) =>
                EventModel.fromMap(snapshot.data()!),
            toFirestore: (map, _) => map.toMap())
        .snapshots();
    return _events;
  }

  static Future<Map<String, dynamic>> upsertEvent(
      EventModel eventModel, File? eventRef, String? docId) async {
    try {
      if (eventRef != null) {
        if (eventModel.url.isNotEmpty) {
          String referenceImage = StorageFirebase.getReference(eventModel.url);
          StorageFirebase.deleteFile(referenceImage);
        }
        String fileName = basename(eventRef.path);
        String imageURL = await StorageFirebase.uploadImage(
            "images/event/$fileName", eventRef);
        eventModel.url = imageURL;
      }
      if (docId == null) {
        await eventCollection.add(eventModel.toMap());
      } else {
        await eventCollection.doc(docId).update(eventModel.toMap());
      }

      return {"status": "200", "message": "จัดการกิจกรรมเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "จัดการกิจกรรมล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteEvenet(
      String eventId, String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        String referenceImage = StorageFirebase.getReference(imageUrl);
        StorageFirebase.deleteFile(referenceImage);
      }

      await eventCollection.doc(eventId).delete();
      return {"status": "200", "message": "ลบกิจกรรมเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบกิจกรรมล้มเหลว"};
    }
  }
}
