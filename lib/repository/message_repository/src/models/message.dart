import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

/// Deserialize Firebase Timestamp data type from Firestore
Timestamp _firestoreTimestampFromJson(dynamic value) {
  return value != null ? Timestamp.fromMicrosecondsSinceEpoch(value) : value;
}

/// This method only stores the "timestamp" data type back in the Firestore
dynamic _firestoreTimestampToJson(dynamic value) => value;

@JsonSerializable()
class Message {
  const Message({
    this.id,
    required this.authorId,
    required this.createdAt,
    required this.text,
  });

  final String? id;
  final String authorId;
  @JsonKey(
    toJson: _firestoreTimestampToJson,
    fromJson: _firestoreTimestampFromJson,
  )
  final Timestamp createdAt;
  final String text;

  factory Message.fromJson(Map<String, dynamic> json) {
    return _$MessageFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MessageToJson(this);
  }

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Message(
      id: snapshot.id,
      authorId: data?['author_id'],
      createdAt: data?['created_at'],
      text: data?['text'],
    );
  }

  Map<String, dynamic> toFirestore() {
    var json = toJson();
    json.remove('id');
    return json;
  }

  bool isDifferent(Message? other) {
    if (other == null) return true;
    if (authorId != other.authorId) return true;
    if (differenceInHours(other) > 1) return true;
    if (isDifferentDay(other)) return true;
    return false;
  }

  int differenceInHours(Message other) {
    try {
      final difference =
          (createdAt.toDate()).difference(other.createdAt.toDate());
      return difference.inHours.abs();
    } catch (_) {
      return 0;
    }
  }

  bool isDifferentDay(Message other) {
    try {
      return createdAt.toDate().toString().substring(0, 10) !=
          other.createdAt.toDate().toString().substring(0, 10);
    } catch (_) {
      return false;
    }
  }

  @override
  String toString() => 'Message { authorId: $authorId, text: $text }';
}
