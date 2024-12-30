// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Chat',
      json,
      ($checkedConvert) {
        final val = Chat(
          name: $checkedConvert('name', (v) => v as String),
          uids: $checkedConvert('uids', (v) => v as List<dynamic>),
          updatedTime: $checkedConvert(
              'updated_time', (v) => _firestoreTimestampFromJson(v)),
        );
        return val;
      },
      fieldKeyMap: const {'updatedTime': 'updated_time'},
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'name': instance.name,
      'uids': instance.uids,
      'updated_time': _firestoreTimestampToJson(instance.updatedTime),
    };
