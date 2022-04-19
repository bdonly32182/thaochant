import 'dart:io';
import 'dart:math';

import 'package:chanthaburi_app/models/otop/product.dart';
import 'package:chanthaburi_app/resources/firebase_storage.dart';
import 'package:chanthaburi_app/utils/my_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference productOtopCollection =
    _firestore.collection(MyConstant.productOtopCollection);

class ProductOtopCollection {
  static Stream<QuerySnapshot<Object?>> products(
      String otopId, String categoryId) {
    Stream<QuerySnapshot<Object?>> _products = productOtopCollection
        .where('otopId', isEqualTo: otopId)
        .where('categoryId', isEqualTo: categoryId)
        .snapshots();
    return _products;
  }

  static Future<int> checkProduct(String categoryId) async {
    QuerySnapshot _products = await productOtopCollection
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return _products.size;
  }

  static Future<Map<String, dynamic>> createProduct(
      ProductOtopModel product, File? imageFile) async {
    try {
      String imageRef = '';
      if (imageFile != null) {
        String fileName = basename(imageFile.path);
        imageRef = await StorageFirebase.uploadImage(
            "images/productOtop/$fileName", imageFile);
      }
      await productOtopCollection.add({
        'productName': product.productName,
        'price': product.price,
        'imageRef': imageRef,
        'otopId': product.otopId,
        'categoryId': product.categoryId,
        'description': product.description,
        'status': product.status,
        'weight': product.weight,
        'width': product.width,
        'height': product.height,
        'long': product.long,
      });

      return {"status": "200", "message": "สร้างข้อมูลสินค้าเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "สร้างข้อมูลสินค้าล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> editProduct(
      String productId, ProductOtopModel product, File? imageFile) async {
    try {
      String imageRef = product.imageRef;
      if (imageFile != null) {
        if (product.imageRef.isNotEmpty) {
          String referenceImage =
              StorageFirebase.getReference(product.imageRef);
          StorageFirebase.deleteFile(referenceImage);
        }
        String fileName = basename(imageFile.path);
        imageRef = await StorageFirebase.uploadImage(
            "images/productOtop/$fileName", imageFile);
      }
      await productOtopCollection.doc(productId).update({
        'productName': product.productName,
        'price': product.price,
        'imageRef': imageRef,
        'categoryId': product.categoryId,
        'description': product.description,
        'status': product.status,
        'weight': product.weight,
        'width': product.width,
        'height': product.height,
        'long': product.long,
      });
      return {"status": "200", "message": "แก้ไขข้อมูลสินค้าเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "แก้ไขข้อมูลสินค้าล้มเหลว"};
    }
  }

  static Future<Map<String, dynamic>> deleteProduct(
      String productId, String imageUrl) async {
    try {
      await productOtopCollection.doc(productId).delete();
      if (imageUrl.isNotEmpty) {
        String referenceImage = StorageFirebase.getReference(imageUrl);
        StorageFirebase.deleteFile(referenceImage);
      }
      return {"status": "200", "message": "ลบข้อมูลสินค้าเรียบร้อย"};
    } catch (e) {
      return {"status": "400", "message": "ลบข้อมูลสินค้าล้มเหลว"};
    }
  }

  static Future<DocumentSnapshot> productById(String productId) async {
    DocumentSnapshot _product =
        await productOtopCollection.doc(productId).get();
    return _product;
  }

  static changeStatusProduct(productId, int status) async {
    try {
      await productOtopCollection.doc(productId).update({
        'status': status,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<QuerySnapshot> productsInOtop(String otopId) async {
    QuerySnapshot products =
        await productOtopCollection.where("otopId", isEqualTo: otopId).get();
    return products;
  }

  static Future<int> checkProductInCart(
      String productName, String otopId) async {
    QuerySnapshot _products = await productOtopCollection
        .where("otopId", isEqualTo: otopId)
        .where("productName", isEqualTo: productName)
        .get();
    return _products.size;
  }

  static Future<List<QueryDocumentSnapshot<ProductOtopModel>>>
      randomProducts() async {
    List<QueryDocumentSnapshot<ProductOtopModel>> randomProducts = [];
    List<int> checkList = [];
    QuerySnapshot<ProductOtopModel> _products = await productOtopCollection
        .where("imageRef", isNotEqualTo: "")
        .withConverter<ProductOtopModel>(
            fromFirestore: (_firestore, _) =>
                ProductOtopModel.fromMap(_firestore.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    final random = Random();
    int indexRandom = random.nextInt(_products.docs.length);
    int totalInList = 0;
    int totalInQuery = _products.docs.length > 10 ? 10 : _products.docs.length;
    while (totalInList < totalInQuery) {
      if (checkList.contains(indexRandom)) {
        indexRandom = random.nextInt(_products.docs.length);
      } else {
        checkList.add(indexRandom);
        randomProducts.add(_products.docs[indexRandom]);
        totalInList = randomProducts.length;
      }
    }
    return randomProducts;
  }
}
