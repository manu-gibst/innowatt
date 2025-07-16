import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_collection/firestore_collection.dart';
import 'package:lessons_repository/src/models/models.dart';
import 'package:lessons_repository/src/utils/firestore_references.dart';

class LessonsRepository {
  LessonsRepository({required String uid})
    : _uid = uid,
      _dynamicCollection = FirestoreCollection(
        collection: getRawCollectionReference<Lesson>(),
        initializeOnStart: true,
        queryList: [getRawCollectionReference<Lesson>()],
        queryOrder: QueryOrder(orderField: 'updated_time'),
        pageSize: 20,
        live: true,
      );

  /// TODO: UserID is needed for accessing previleged functions.
  // ignore: unused_field
  final String _uid;

  final FirestoreCollection _dynamicCollection;

  // TODO: Create a request to the server with strict checking of previleges
  // for all of functions below.
  // REFERENCE: https://firebase.google.com/docs/auth/admin/custom-claims#python
  Future<void> createProject({required String name}) async {
    throw UnimplementedError('This feature is not yet implemented.');
  }

  Future<void> updateProject({required Lesson updatedLesson}) async {
    throw UnimplementedError('This feature is not yet implemented.');
  }

  Stream<List<Lesson>> lessonsStream() {
    return _dynamicCollection.stream.map((snapshot) {
      if (snapshot == null || snapshot.isEmpty) return <Lesson>[];
      return snapshot.map((doc) {
        return Lesson.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
          null,
        );
      }).toList();
    });
  }

  Future<void> requestNextPage() async {
    await _dynamicCollection.nextPage();
  }

  Future<void> dispose() async {
    await _dynamicCollection.dispose();
  }
}
