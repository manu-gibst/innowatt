import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects_repository/src/models/models.dart';

final _firestore = FirebaseFirestore.instance;
CollectionReference<Map<String, dynamic>> _projects(String uid) =>
    _firestore.collection('projects').doc(uid).collection('projects');

CollectionReference<Map<String, dynamic>> getRawCollectionReference<T>({
  String? uid,
}) {
  if (T == Project) return _projects(uid!);
  throw FormatException("Unexpected Format!");
}

CollectionReference<T> getCollectionReference<T>({String? uid}) {
  if (T == Project) {
    return _projects(uid!).withConverter(
      fromFirestore: Project.fromFirestore as FromFirestore<T>,
      toFirestore: (T project, _) => (project as Project).toJson(),
    );
  }
  throw FormatException("Unexpected Format!");
}
