import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'project.g.dart';

/// Deserialize Firebase Timestamp data type from Firestore
Timestamp? _firestoreTimestampFromJson(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value;
  if (value is int) return Timestamp.fromMicrosecondsSinceEpoch(value);
  throw FormatException('Invalid timestamp format: $value');
}

/// This method only stores the "timestamp" data type back in the Firestore
dynamic _firestoreTimestampToJson(dynamic value) => value;

@JsonSerializable()
class Project {
  const Project({
    this.id,
    required this.name,
    required this.modulesCount,
    required this.currentModule,
    this.updatedTime,
  });

  final String? id;
  final String name;
  final int modulesCount;
  final int currentModule;

  @JsonKey(
    toJson: _firestoreTimestampToJson,
    fromJson: _firestoreTimestampFromJson,
  )
  final Timestamp? updatedTime;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  factory Project.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Project(
      id: snapshot.id,
      name: data?['name'],
      modulesCount: data?['modules_count'],
      currentModule: data?['current_module'],
      updatedTime: data?['updated_time'],
    );
  }

  Project copyWith({
    String? name,
    int? modulesCount,
    int? currentModule,
    Timestamp? updatedTime,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      modulesCount: modulesCount ?? this.modulesCount,
      currentModule: currentModule ?? this.currentModule,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }

  @override
  String toString() => "Project($id) (name: $name)";
}
