import 'package:chanthaburi_app/models/thaochan_about/about_thaochan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final CollectionReference aboutThaochanCollection =
    _firestore.collection("aboutThaochanCollection");

class AboutThaochanCollection {
  static Future<QuerySnapshot<AboutThaoChanModel>> fetchData() async {
    QuerySnapshot<AboutThaoChanModel> data = await aboutThaochanCollection
        .withConverter<AboutThaoChanModel>(
            fromFirestore: (snapshot, options) =>
                AboutThaoChanModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .get();
    return data;
  }
}
