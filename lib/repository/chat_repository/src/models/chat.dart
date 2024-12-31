import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'chat.g.dart';

/// Deserialize Firebase Timestamp data type from Firestore
Timestamp _firestoreTimestampFromJson(dynamic value) {
  return value != null ? Timestamp.fromMicrosecondsSinceEpoch(value) : value;
}

/// This method only stores the "timestamp" data type back in the Firestore
dynamic _firestoreTimestampToJson(dynamic value) => value;

@JsonSerializable()
class Chat {
  const Chat({
    this.chatId,
    required this.name,
    required this.uids,
    required this.updatedTime,
  });

  final String? chatId;
  final String name;
  final List<dynamic> uids;

  static const empty = Chat(
    name: '',
    uids: [],
    updatedTime: null,
  );

  @JsonKey(
    toJson: _firestoreTimestampToJson,
    fromJson: _firestoreTimestampFromJson,
  )
  final Timestamp? updatedTime;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  factory Chat.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Chat(
      chatId: snapshot.id,
      name: data?['name'],
      uids: data?['uids'],
      updatedTime: data?['updated_time'],
    );
  }

  Map<String, dynamic> toFirestore() => toJson();

  @override
  String toString() => 'Chat { chatId: $chatId name: $name } ';
  // 'Chat { name: $name, uids: $uids, updatedTime: $updatedTime } ';
}
