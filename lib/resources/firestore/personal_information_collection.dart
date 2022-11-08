import 'package:chanthaburi_app/models/user/personal_information.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference personalInformationCollection = _firestore.collection("PersonalInformationCollection");

class PersonalInformationCollection { 
  static Future<void> savePersonalData(PersonalInformationModel personData) async {
    await personalInformationCollection.add(personData.toMap());
  }
}
