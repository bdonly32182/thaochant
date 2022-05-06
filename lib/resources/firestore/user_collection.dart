import 'dart:io';

import 'package:chanthaburi_app/models/user/partner.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sharePreferrence/share_referrence.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final CollectionReference _userCollection =
    _firestore.collection(MyConstant.userCollection);
final CollectionReference _approvePartner =
    _firestore.collection(MyConstant.approvePartnerCollection);
final CollectionReference _restaurant =
    _firestore.collection(MyConstant.restaurantCollection);
final CollectionReference _otop =
    _firestore.collection(MyConstant.otopCollection);
final CollectionReference _resort =
    _firestore.collection(MyConstant.resortCollection);

class UserCollection {
  static DocumentSnapshot? lastBuyerDocument;
  static Future<DocumentSnapshot<Object?>> profile() async {
    String uid = await ShareRefferrence.getUserId();
    DocumentSnapshot _user = await _userCollection.doc(uid).get();
    return _user;
  }

  static Future<Map<String, dynamic>> changeProfile(
    String docId,
    String fullName,
    String phone,
    String profileRef,
    File? changeProfile,
  ) async {
    try {
      String? newProfileRef;
      if (changeProfile != null) {
        if (profileRef.isNotEmpty) {
          String imageURL = StorageFirebase.getReference(profileRef);
          StorageFirebase.deleteFile(imageURL);
        }
        String fileName = basename(changeProfile.path);
        newProfileRef = await StorageFirebase.uploadImage(
            "images/register/$fileName", changeProfile);
      }
      await _userCollection.doc(docId).update({
        "fullName": fullName,
        "phoneNumber": phone,
        "profileRef": changeProfile != null ? newProfileRef : profileRef,
      });

      return {"status": "200", "message": "แก้ไขข้อมูลเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขข้อมูลล้มเหลว"};
    }
  }

  static Future<DocumentSnapshot<Object?>> userById(String userId) async {
    DocumentSnapshot _user = await _userCollection.doc(userId).get();
    return _user;
  }

  static Future<QuerySnapshot> searchUser(String search, String role) async {
    QuerySnapshot _resultUser = await _userCollection
        .where("role", isEqualTo: role)
        .orderBy("fullName")
        .startAt([search]).endAt([search + '\uf8ff']).get();
    return _resultUser;
  }

  static Future<QuerySnapshot<PartnerModel>> searchApprovePartner(
      String search) async {
    QuerySnapshot<PartnerModel> _resultApprovePartner = await _approvePartner
        .where("isAccept", isEqualTo: false)
        .orderBy("fullName")
        .startAt([search])
        .endAt([search + '\uf8ff'])
        .withConverter<PartnerModel>(
            fromFirestore: (snapshot, _) =>
                PartnerModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    return _resultApprovePartner;
  }

  static Future<QuerySnapshot<Object?>> userRoleList(
      DocumentSnapshot? lastDocument, String status) async {
    if (lastDocument != null) {
      QuerySnapshot _nextDocumentPagination = await _userCollection
          .where("role", isEqualTo: status)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
      return _nextDocumentPagination;
    }
    QuerySnapshot _resultBuyer =
        await _userCollection.where("role", isEqualTo: status).limit(10).get();
    return _resultBuyer;
  }

  static Future<QuerySnapshot<PartnerModel>> approveList(
      DocumentSnapshot? lastDocument) async {
    if (lastDocument != null) {
      QuerySnapshot<PartnerModel> _nextPageApprove = await _approvePartner
          .where("isAccept", isEqualTo: false)
          .orderBy("fullName")
          .startAfterDocument(lastDocument)
          .withConverter<PartnerModel>(
              fromFirestore: (snapshot, _) =>
                  PartnerModel.fromMap(snapshot.data()!),
              toFirestore: (model, _) => model.toMap())
          .limit(10)
          .get();
      return _nextPageApprove;
    }
    QuerySnapshot<PartnerModel> _resultApprove = await _approvePartner
        .where("isAccept", isEqualTo: false)
        .orderBy("fullName")
        .limit(10)
        .withConverter<PartnerModel>(
            fromFirestore: (snapshot, _) =>
                PartnerModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    return _resultApprove;
  }

  static Future<QuerySnapshot> dropdownSeller() async {
    final QuerySnapshot _resultSeller = await _userCollection
        .where("role", isEqualTo: MyConstant.sellerName)
        .get();
    return _resultSeller;
  }

  static Future<Map<String, dynamic>> amountProductSeller(
      String sellerId) async {
    QuerySnapshot _resultRestaurant =
        await _restaurant.where("sellerId", isEqualTo: sellerId).get();
    QuerySnapshot _resultResort =
        await _resort.where("sellerId", isEqualTo: sellerId).get();
    QuerySnapshot _resultOtop =
        await _otop.where("sellerId", isEqualTo: sellerId).get();
    return {
      "restaurant": _resultRestaurant.size,
      "resort": _resultResort.size,
      "otop": _resultOtop.size
    };
  }

  static Future<Map<String, dynamic>> onApprove(
    String docId,
    PartnerModel partner,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: partner.email,
        password: partner.password,
      );
      String uid = userCredential.user!.uid;
      await _userCollection.doc(uid).set({
        "email": partner.email,
        "fullName": partner.fullName,
        "phoneNumber": partner.phoneNumber,
        "role": partner.role,
        "profileRef": partner.profileRef,
        "tokenDevice": partner.tokenDevice,
      });
      await _approvePartner.doc(docId).update({
        "isAccept": true,
        "password": "**secret***",
      });
      return {"status": "200", "message": "อนุมัติเรียบร้อย"};
    } on FirebaseException catch (e) {
      return {"status": "400", "message": e.message};
    }
  }

  static Future<Map<String, dynamic>> unApprove(
      String docId, String profileRef, String verifyRef) async {
    try {
      await _approvePartner.doc(docId).delete();
      if (profileRef.isNotEmpty) {
        String referenceImage = StorageFirebase.getReference(profileRef);
        StorageFirebase.deleteFile(referenceImage);
      }
      if (verifyRef.isNotEmpty) {
        String referenceImage = StorageFirebase.getReference(verifyRef);
        StorageFirebase.deleteFile(referenceImage);
      }
      return {"status": "200", "message": "ไม่อนุมัติเรียบร้อย"};
    } on FirebaseException catch (e) {
      return {"status": "400", "message": "ไม่อนุมัติล้มเหลว"};
    }
  }
}
