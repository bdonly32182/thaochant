import 'dart:io';

import 'package:chanthaburi_app/models/packagetour/package_tour.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference packageTourCollection =
    _firestore.collection(MyConstant.packageTourCollection);

class TourCollection {
  static Future<Map<String, dynamic>> createPackageTour(
    PackageTourModel tour,
    File? imageRef,
    File? pdfFile,
  ) async {
    try {
      if (imageRef != null) {
        String fileName = basename(imageRef.path);
        tour.imageRef = await StorageFirebase.uploadImage(
            "images/tour/$fileName", imageRef);
      }
      if (pdfFile != null) {
        String fileName = basename(pdfFile.path);
        tour.pdfRef =
            await StorageFirebase.uploadImage("pdf/$fileName", pdfFile);
      }
      await packageTourCollection.add(tour.toMap());
      return {"status": "400", "message": "แพ็คเกจทัวร์เรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แพ็คเกจทัวร์ล้มเหลว"};
    }
  }

  static Future<void> setPointLocation(String docId, num point) async {
    try {
      packageTourCollection.doc(docId).update({
        "point": FieldValue.increment(point),
        "ratingCount": FieldValue.increment(1),
      });
    } catch (e) {}
  }

  static Future<void> updateStatus(String docId, int status) async {
    await packageTourCollection.doc(docId).update({"status": status});
  }

  static Stream<QuerySnapshot<PackageTourModel>> tours() {
    Stream<QuerySnapshot<PackageTourModel>> _tours = packageTourCollection
        .where("status", isEqualTo: 1)
        .orderBy("ratingCount", descending: true)
        .withConverter<PackageTourModel>(
            fromFirestore: (snapshot, _) =>
                PackageTourModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .snapshots();
    return _tours;
  }

  static Future<DocumentSnapshot<PackageTourModel>> tourById(
      String docId) async {
    DocumentSnapshot<PackageTourModel> tour = await packageTourCollection
        .doc(docId)
        .withConverter<PackageTourModel>(
            fromFirestore: (snapshot, _) =>
                PackageTourModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    return tour;
  }

  static Future<Map<String, dynamic>> editTour(
    String docId,
    PackageTourModel tour,
    File? imageUpdate,
    File? pdfFile,
  ) async {
    try {
      if (imageUpdate != null) {
        if (tour.imageRef.isNotEmpty) {
          String imageURL = StorageFirebase.getReference(tour.imageRef);
          StorageFirebase.deleteFile(imageURL);
        }
        String fileName = basename(imageUpdate.path);
        tour.imageRef = await StorageFirebase.uploadImage(
            "images/tour/$fileName", imageUpdate);
      }
      if (pdfFile != null) {
        if (tour.pdfRef.isNotEmpty) {
          String pdfURL = StorageFirebase.getReference(tour.pdfRef);
          StorageFirebase.deleteFile(pdfURL);
        }
        String fileName = basename(pdfFile.path);
        tour.pdfRef =
            await StorageFirebase.uploadImage("pdf/$fileName", pdfFile);
      }
      await packageTourCollection.doc(docId).update(tour.toMap());
      return {"status": "200", "message": "แก้ไขข้อมูลแพ็คเกจทัวร์เรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขข้อมูลแพ็คเกจทัวร์เรียบร้อย"};
    }
  }
}
