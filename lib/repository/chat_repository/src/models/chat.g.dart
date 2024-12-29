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
          uids: $checkedConvert('uids',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'name': instance.name,
      'uids': instance.uids,
    };
