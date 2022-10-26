import 'dart:developer';
import 'dart:io';

import 'package:chanthaburi_app/models/program_travel/location_program.dart';
import 'package:chanthaburi_app/models/program_travel/program_travel.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference programTravelCollection =
    _firestore.collection(MyConstant.programTravelCollection);

class ProgramTravelCollection {
  static Future<Map<String, dynamic>> createProgramTravel(
      ProgramTravelModel program, File? coverImage) async {
    try {
      if (coverImage != null) {
        String fileName = basename(coverImage.path);
        String coverImageRef = await StorageFirebase.uploadImage(
            "images/program/$fileName", coverImage);
        program.imageCover = coverImageRef;
      }
      if (program.location.isNotEmpty) {
        for (int i = 0; i < program.location.length; i++) {
          LocationProgramModel locationProgramModel = program.location[i];
          for (int l = 0; l < locationProgramModel.imagesFiles!.length; l++) {
            File image = locationProgramModel.imagesFiles![l];
            String fileName = basename(image.path);
            String imageRef = await StorageFirebase.uploadImage(
                "images/program/$fileName", image);
            program.location[i].images.add(imageRef);
          }
        }
      }

      await programTravelCollection.add(program.toMap());
      return {"status": "400", "message": "สร้างโปรแกรมท่องเที่ยวเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างโปรแกรมท่องเที่ยวล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> editProgramTravel(
    ProgramTravelModel program,
    File? coverImage,
    List<String> imageRemove,
    String docId,
  ) async {
    try {
      if (coverImage != null) {
        String imageURL = StorageFirebase.getReference(program.imageCover);
        StorageFirebase.deleteFile(imageURL);
        String fileName = basename(coverImage.path);
        String coverImageRef = await StorageFirebase.uploadImage(
            "images/program/$fileName", coverImage);
        program.imageCover = coverImageRef;
      }
      if (imageRemove.isNotEmpty) {
        for (int r = 0; r < imageRemove.length; r++) {
          String removeURL = StorageFirebase.getReference(imageRemove[r]);
          StorageFirebase.deleteFile(removeURL);
        }
      }
      if (program.location.isNotEmpty) {
        for (int i = 0; i < program.location.length; i++) {
          LocationProgramModel locationProgramModel = program.location[i];
          if (locationProgramModel.imagesFiles != null) {
            for (int l = 0; l < locationProgramModel.imagesFiles!.length; l++) {
              File image = locationProgramModel.imagesFiles![l];
              String fileName = basename(image.path);
              String imageRef = await StorageFirebase.uploadImage(
                  "images/program/$fileName", image);
              program.location[i].images.add(imageRef);
            }
          }
        }
      }
      await programTravelCollection.doc(docId).update(program.toMap());
      return {"status": "200", "message": "แก้ไขโปรแกรมท่องเที่ยวเรียบร้อย"};
    } catch (e) {
      log(e.toString());
      return {"status": "400", "message": "แก้ไขโปรแกรมท่องเที่ยวล้มเหลว"};
    }
  }

  static Stream<QuerySnapshot<ProgramTravelModel>> programTravels() {
    Stream<QuerySnapshot<ProgramTravelModel>> programs = programTravelCollection
        .withConverter<ProgramTravelModel>(
          fromFirestore: (snapshot, options) =>
              ProgramTravelModel.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        )
        .snapshots();
    return programs;
  }

  static Stream<DocumentSnapshot<ProgramTravelModel>> programTravel(
      String docId) {
    Stream<DocumentSnapshot<ProgramTravelModel>> program =
        programTravelCollection
            .doc(docId)
            .withConverter<ProgramTravelModel>(
              fromFirestore: (snapshot, options) =>
                  ProgramTravelModel.fromMap(snapshot.data()!),
              toFirestore: (model, _) => model.toMap(),
            )
            .snapshots();
    return program;
  }

  static Future<Map<String, dynamic>> deleteProgramTravel(
    ProgramTravelModel program,
    String docId,
  ) async {
    try {
      if (program.imageCover.isNotEmpty) {
        String imageURL = StorageFirebase.getReference(program.imageCover);
        StorageFirebase.deleteFile(imageURL);
      }

      if (program.location.isNotEmpty) {
        for (int i = 0; i < program.location.length; i++) {
          LocationProgramModel locationProgramModel = program.location[i];
          for (int l = 0; l < locationProgramModel.images.length; l++) {
            String imageLocationURL =
                StorageFirebase.getReference(locationProgramModel.images[l]);
            StorageFirebase.deleteFile(imageLocationURL);
          }
        }
      }

      await programTravelCollection.doc(docId).delete();
      return {"status": "200", "message": "ลบโปรแกรมท่องเที่ยวเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบโปรแกรมท่องเที่ยวล้มเหลว"};
    }
  }
}
