import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_collection/firestore_collection.dart';
import 'package:projects_repository/src/constants/modules.dart';
import 'package:projects_repository/src/exceptions/exception.dart';
import 'package:projects_repository/src/models/project.dart';

class ProjectsRepository {
  ProjectsRepository({required String uid})
    : _uid = uid,
      _dynamicCollection = FirestoreCollection(
        collection: FirebaseFirestore.instance
            .collection('projects')
            .doc(uid)
            .collection('projects'),
        initializeOnStart: true,
        queryList: [
          FirebaseFirestore.instance
              .collection('projects')
              .doc(uid)
              .collection('projects'),
        ],
        queryOrder: QueryOrder(orderField: 'updated_time'),
        pageSize: 20,
        live: true,
      );

  final String _uid;

  CollectionReference<Project> get _projects => FirebaseFirestore.instance
      .collection('projects')
      .doc(_uid)
      .collection('projects')
      .withConverter(
        fromFirestore: Project.fromFirestore,
        toFirestore: (Project project, _) => project.toJson(),
      );

  final FirestoreCollection _dynamicCollection;

  Future<void> createProject({required String name}) async {
    final project = Project(
      name: name,
      currentModule: 0,
      modulesCount: modules.length,
      updatedTime: Timestamp.now(),
    );
    try {
      await _projects.doc().set(project);
    } on FirebaseException catch (e) {
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
  }

  /// Updates a project using its id
  Future<void> updateProject({required Project updatedProject}) async {
    try {
      updatedProject = updatedProject.copyWith(updatedTime: Timestamp.now());
      await _projects.doc(updatedProject.id!).update(updatedProject.toJson());
    } on FirebaseException catch (e) {
      throw FirestoreDatabaseFailure.fromCode(e.code);
    } catch (_) {
      throw FirestoreDatabaseFailure();
    }
  }

  Stream<List<Project>> getProjectsStream() {
    return _dynamicCollection.stream.map((snapshots) {
      if (snapshots == null || snapshots.isEmpty) return <Project>[];
      return snapshots.map((doc) {
        return Project.fromFirestore(
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
