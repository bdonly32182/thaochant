import 'dart:io';

import 'package:chanthaburi_app/models/user/partner.dart';
import 'package:chanthaburi_app/models/user/user.dart';
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

class AuthMethods {
  static Future<Map<String, dynamic>> register(
      UserModel _user, File? imageRef) async {
    try {
      if (imageRef != null) {
        String fileName = basename(imageRef.path);
        _user.profileRef = await StorageFirebase.uploadImage(
            "images/register/$fileName", imageRef);
      }
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: _user.email as String,
        password: _user.password as String,
      );
      String uid = userCredential.user!.uid;
      await _userCollection.doc(uid).set({
        "email": _user.email,
        "fullName": _user.fullName,
        "phoneNumber": _user.phoneNumber,
        "profileRef": _user.profileRef,
        "role": _user.role,
        "tokenDevice": _user.tokenDevice,
        "rangeAge":_user.rangeAge,
        "gender":_user.gender,
      });
      return {"status": "200", "message": "สร้างบัญชีผู้ใช้งานเรียบร้อย"};
    } on FirebaseAuthException catch (e) {
      return {"status": "400", "message": e.code};
    }
  }

  static Future<Map<String, dynamic>> registerPartner(
      PartnerModel partner, File? imageRef, File? verifyImage) async {
    try {
      if (imageRef != null) {
        String fileName = basename(imageRef.path);
        partner.profileRef = await StorageFirebase.uploadImage(
            "images/partner/$fileName", imageRef);
      }
      if (verifyImage != null) {
        String fileName = basename(verifyImage.path);
        partner.verifyRef = await StorageFirebase.uploadImage(
            "images/verify/$fileName", verifyImage);
      }
      await _approvePartner.add(partner.toMap());
      return {"status": "200", "message": "สร้างบัญชีผู้ใช้งานเรียบร้อย"};
    } on FirebaseAuthException catch (e) {
      return {"status": "400", "message": e.code};
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      DocumentSnapshot<Object?> user = await _userCollection.doc(uid).get();
      if (!user.exists) {
        return {"status": "400", "message": "เข้าสู่ระบบล้มเหลว"};
      }
      String userRole = user.get("role");
      ShareRefferrence.setReferrence(userRole, uid);
      return {
        "status": "200",
        "message": "เข้าสู่ระบบเรียบร้อย",
        "role": userRole,
      };
    } on FirebaseAuthException catch (e) {
      return {"status": "400", "message": e.code};
    }
  }

  static Future<void> logout() async {
    String userId = await ShareRefferrence.getUserId();
    await _userCollection.doc(userId).update({"tokenDevice": ""});
    await _firebaseAuth.signOut();
    ShareRefferrence.setReferrence("", "");
  }

  static String currentUser() {
    print(_firebaseAuth.currentUser!.uid);
    if (_firebaseAuth.currentUser == null) {
      return "";
    }
    return _firebaseAuth.currentUser!.uid;
  }

  static Future<void> userUpdateToken(String token, String userId) async {
    try {
      DocumentSnapshot user = await _userCollection.doc(userId).get();
      if (user.get("tokenDevice") == "") {
        await _userCollection.doc(userId).update({"tokenDevice": token});
      }
    } catch (e) {}
  }

  static Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
  
}
