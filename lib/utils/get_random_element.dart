import "dart:math";

import 'package:chanthaburi_app/models/business/business.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

QueryDocumentSnapshot<BusinessModel> getRandomElement<T>(List<QueryDocumentSnapshot<BusinessModel>> list) {
    final random = Random();
    var i = random.nextInt(list.length);
    return list[i];
}