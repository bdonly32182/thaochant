import 'package:chanthaburi_app/models/user/user.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:chanthaburi_app/utils/sharePreferrence/share_referrence.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final CollectionReference _userCollection =
    _firestore.collection(MyConstant.userCollection);
final CollectionReference _approvePartner =
    _firestore.collection(MyConstant.approvePartnerCollection);

class AuthMethods {
  static Future<Map<String, dynamic>> register(
      UserModel _user, bool isPartner) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: _user.email as String,
        password: _user.password as String,
      );
      String uid = userCredential.user!.uid;
      if (isPartner) {
        _approvePartner
            .doc(uid)
            .set({
              "email": _user.email,
              "fullName": _user.fullName,
              "phoneNumber": _user.phoneNumber,
              "profileRef": _user.profileRef,
              "role": _user.role
            })
            .then((value) => print("create partner success"))
            .catchError(
              (onError) =>
                  {"status": "400", "message": "สร้างบัญชีผู้ใช้งานล้มเหลว"},
            );
      } else {
        _userCollection
            .doc(uid)
            .set({
              "email": _user.email,
              "fullName": _user.fullName,
              "phoneNumber": _user.phoneNumber,
              "profileRef": _user.profileRef,
              "role": _user.role,
            })
            .then((value) => print("create partner success"))
            .catchError(
              (onError) =>
                  {"status": "400", "message": "สร้างบัญชีผู้ใช้งานล้มเหลว"},
            );
      }

      return {"status": "200", "message": "สร้างบัญชีผู้ใช้งานเรียบร้อย"};
    } on FirebaseAuthException catch (e) {
      print(e.code);
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
    await _firebaseAuth.signOut();
    ShareRefferrence.setReferrence("", "");
  }
}
