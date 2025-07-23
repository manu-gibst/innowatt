import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'lesson.g.dart';

/// Deserialize Firebase Timestamp data type from Firestore
Timestamp _firestoreTimestampFromJson(dynamic value) {
  if (value is Timestamp) return value;
  if (value is int) return Timestamp.fromMicrosecondsSinceEpoch(value);
  throw FormatException('Invalid timestamp format: $value');
}

/// This method only stores the "timestamp" data type back in the Firestore
dynamic _firestoreTimestampToJson(dynamic value) => value;

@JsonSerializable()
class Lesson {
  const Lesson({
    required this.id,
    required this.name,
    required this.description,
    required this.updatedTime,
  });
  final int id;
  final String name;
  final String description;

  @JsonKey(
    toJson: _firestoreTimestampToJson,
    fromJson: _firestoreTimestampFromJson,
  )
  final Timestamp updatedTime;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);

  factory Lesson.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Lesson(
      id: int.tryParse(snapshot.id) ?? -1,
      name: data?['name'],
      description: data?['description'],
      updatedTime: data?['updated_time'],
    );
  }

  Lesson copyWith({String? name, String? description, Timestamp? updatedTime}) {
    return Lesson(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      updatedTime: updatedTime ?? this.updatedTime,
    );
  }
}
