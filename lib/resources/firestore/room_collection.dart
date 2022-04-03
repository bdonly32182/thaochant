import 'dart:io';
import 'package:chanthaburi_app/models/resort/room.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference roomCollection =
    _firestore.collection(MyConstant.roomCollection);

class RoomCollection {
  static Stream<QuerySnapshot<RoomModel>> rooms(
      String resortId, String categoryId) {
    Stream<QuerySnapshot<RoomModel>> _resorts = roomCollection
        .where('resortId', isEqualTo: resortId)
        .where('categoryId', isEqualTo: categoryId)
        .withConverter<RoomModel>(fromFirestore: (snapshot,_) => RoomModel.fromMap(snapshot.data()!), toFirestore: (model,_) => model.toMap())
        .snapshots();
    return _resorts;
  }

  static Future<QuerySnapshot<RoomModel>> roomsByUser(String resortId) async {
    QuerySnapshot<RoomModel> _resorts = await roomCollection
        .where('resortId', isEqualTo: resortId)
        .withConverter<RoomModel>(
          fromFirestore: (data, _) => RoomModel.fromMap(data.data()!),
          toFirestore: (room, _) => room.toMap(),
        )
        .get();
    return _resorts;
  }

  static Future<int> checkRoom(String categoryId) async {
    QuerySnapshot _products =
        await roomCollection.where('categoryId', isEqualTo: categoryId).get();
    return _products.size;
  }

  static Future<Map<String, dynamic>> createRoom(
      RoomModel room, File? imageCoverFile, List<File>? listImageFile) async {
    try {
      List<String> listImageDetail = <String>[];
      String imageCover = '';
      if (imageCoverFile != null) {
        String fileName = basename(imageCoverFile.path);
        imageCover = await StorageFirebase.uploadImage(
            "images/room/$fileName", imageCoverFile);
      }
      if (listImageFile != null) {
        for (File file in listImageFile) {
          String fileName = basename(file.path);
          String imageUrl =
              await StorageFirebase.uploadImage("images/room/$fileName", file);
          listImageDetail.add(imageUrl);
        }
      }
      await roomCollection.add({
        'roomName': room.roomName,
        'price': room.price,
        'imageCover': imageCover,
        'listImageDetail': listImageDetail,
        'resortId': room.resortId,
        'categoryId': room.categoryId,
        'descriptionRoom': room.descriptionRoom,
        'totalRoom': room.totalRoom,
        'roomSize': room.roomSize,
        'totalGuest': room.totalGuest,
      });

      return {"status": "200", "message": "สร้างข้อมูลห้องพักเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างข้อมูลห้องพักล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> editProduct(
      String roomId,
      RoomModel room,
      File? newImageCover,
      List<File> listFileAdd,
      List<String> listImageDelete) async {
    try {
      String imageCover = room.imageCover;
      if (newImageCover != null) {
        if (room.imageCover.isNotEmpty) {
          String imageURL = StorageFirebase.getReference(room.imageCover);
          StorageFirebase.deleteFile(imageURL);
        }
        String fileName = basename(newImageCover.path);
        imageCover = await StorageFirebase.uploadImage(
            "images/room/$fileName", newImageCover);
      }
      if (listFileAdd.isNotEmpty) {
        for (File file in listFileAdd) {
          String fileName = basename(file.path);
          String imageRef =
              await StorageFirebase.uploadImage("images/room/$fileName", file);
          room.listImageDetail.add(imageRef);
        }
      }
      if (listImageDelete.isNotEmpty) {
        for (String imageUrl in listImageDelete) {
          String referenceImage = StorageFirebase.getReference(imageUrl);
          StorageFirebase.deleteFile(referenceImage);
        }
      }
      await roomCollection.doc(roomId).update({
        'roomName': room.roomName,
        'price': room.price,
        'imageCover': imageCover,
        'listImageDetail': room.listImageDetail,
        'categoryId': room.categoryId,
        'descriptionRoom': room.descriptionRoom,
        'totalRoom': room.totalRoom,
        'roomSize': room.roomSize,
        'totalGuest': room.totalGuest,
      });
      return {"status": "200", "message": "แก้ไขข้อมูลห้องพักเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขข้อมูลห้องพักล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteRoom(
      String roomId, String imageCover, List<dynamic> listImageUrl) async {
    try {
      await roomCollection.doc(roomId).delete();
      if (imageCover.isNotEmpty) {
        String imageCoverRef = StorageFirebase.getReference(imageCover);
        StorageFirebase.deleteFile(imageCoverRef);
      }
      if (listImageUrl.isNotEmpty) {
        for (String imageUrl in listImageUrl) {
          String referenceImage = StorageFirebase.getReference(imageUrl);
          StorageFirebase.deleteFile(referenceImage);
        }
      }
      return {"status": "200", "message": "ลบข้อมูลสินค้าเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบข้อมูลสินค้าล้มเหลว"};
    }
  }

  static Future<DocumentSnapshot> roomById(String roomId) async {
    DocumentSnapshot _room = await roomCollection.doc(roomId).get();
    return _room;
  }

  static Future<QuerySnapshot> deleteRoomInResort(String resortId) async {
    QuerySnapshot rooms =
        await roomCollection.where('resortId', isEqualTo: resortId).get();
    return rooms;
  }
}
