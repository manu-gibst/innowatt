import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lessons_repository/src/models/models.dart';

final _firestore = FirebaseFirestore.instance;
final _lesson = _firestore.collection('lessons');

CollectionReference<Map<String, dynamic>> getRawCollectionReference<T>({
  String? uid,
}) {
  if (T == Lesson) return _lesson;
  throw FormatException("Unexpected Format!");
}

CollectionReference<T> getCollectionReference<T>({String? uid}) {
  if (T == Lesson) {
    return _lesson.withConverter(
      fromFirestore: Lesson.fromFirestore as FromFirestore<T>,
      toFirestore: (T lesson, _) => (lesson as Lesson).toJson(),
    );
  }
  throw FormatException("Unexpected Format!");
}
