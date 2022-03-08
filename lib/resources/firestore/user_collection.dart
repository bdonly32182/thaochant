import 'package:chanthaburi_app/models/user/user.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    String uid = _firebaseAuth.currentUser!.uid;
    DocumentSnapshot _user = await _userCollection.doc(uid).get();
    return _user;
  }

  static Future<QuerySnapshot> searchUser(String search) async {
    QuerySnapshot _resultUser = await _userCollection
        .orderBy("fullName")
        .startAt([search]).endAt([search + '\uf8ff']).get();
    return _resultUser;
  }

  static Future<QuerySnapshot> searchApprovePartner(String search) async {
    QuerySnapshot _resultApprovePartner = await _approvePartner
        .orderBy("fullName")
        .startAt([search]).endAt([search + '\uf8ff']).get();
    return _resultApprovePartner;
  }

  static Future<QuerySnapshot<Object?>> buyerList(
      DocumentSnapshot? lastDocument) async {
    if (lastDocument != null) {
      QuerySnapshot _nextDocumentPagination = await _userCollection
          .where("role", isEqualTo: MyConstant.buyerName)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
      return _nextDocumentPagination;
    }
    QuerySnapshot _resultBuyer = await _userCollection
        .where("role", isEqualTo: MyConstant.buyerName)
        .limit(10)
        .get();
    return _resultBuyer;
  }

  static Future<QuerySnapshot<Object?>> approveList(
      DocumentSnapshot? lastDocument) async {
    if (lastDocument != null) {
      QuerySnapshot _nextPageApprove = await _approvePartner
          .orderBy("fullName")
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
      return _nextPageApprove;
    }
    QuerySnapshot _resultApprove =
        await _approvePartner.orderBy("fullName").limit(10).get();
    return _resultApprove;
  }

  static Future<QuerySnapshot> sellerList(
      DocumentSnapshot? lastDocument) async {
    if (lastDocument != null) {
      QuerySnapshot _nextDocumentPagination = await _userCollection
          .where("role", isEqualTo: MyConstant.sellerName)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
      return _nextDocumentPagination;
    }
    QuerySnapshot _resultBuyer = await _userCollection
        .where("role", isEqualTo: MyConstant.sellerName)
        .limit(10)
        .get();
    return _resultBuyer;
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
      String fullName,
      String role,
      String phoneNumber,
      String profileRef,
      String email,
      String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;
      await _userCollection.doc(uid).set({
        "email": email,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "role": role,
        "profileRef": profileRef
      });
      await _approvePartner.doc(docId).delete();
      return {"status": "200", "message": "อนุมัติเรียบร้อย"};
    } on FirebaseException catch (e) {
      return {"status": "400", "message": "อนุมัติล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> unApprove(String docId) async {
    try {
      await _approvePartner.doc(docId).delete();
      return {"status": "200", "message": "ไม่อนุมัติเรียบร้อย"};
    } on FirebaseException catch (e) {
      print(e.code);
      return {"status": "400", "message": "ไม่อนุมัติล้มเหลว"};
    }
  }
}
