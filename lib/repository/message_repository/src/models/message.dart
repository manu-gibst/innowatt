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
    required this.authorId,
    required this.createdAt,
    required this.text,
  });

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
      authorId: data?['author_id'],
      createdAt: data?['created_at'],
      text: data?['text'],
    );
  }

  Map<String, dynamic> toFirestore() => toJson();

  @override
  String toString() => 'Message { authorId: $authorId, text: $text }';
}
