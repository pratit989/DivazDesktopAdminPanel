import 'package:firedart/firedart.dart';

class DataService {
  static const _projectID = 'divaz-8e0a9';
  final Firestore firestore = Firestore(_projectID, auth: FirebaseAuth.instance);

  Stream<List<Document>> get technicians {
    return firestore.collection('Technicians').stream;
  }

  Stream<List<Document>> get dealers {
    return firestore.collection('Dealers').stream;
  }
}