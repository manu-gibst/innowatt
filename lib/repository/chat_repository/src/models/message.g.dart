// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Message',
      json,
      ($checkedConvert) {
        final val = Message(
          authorId: $checkedConvert('author_id', (v) => v as String),
          createdAt: $checkedConvert(
              'created_at', (v) => _firestoreTimestampFromJson(v)),
          text: $checkedConvert('text', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'authorId': 'author_id', 'createdAt': 'created_at'},
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'author_id': instance.authorId,
      'created_at': _firestoreTimestampToJson(instance.createdAt),
      'text': instance.text,
    };
