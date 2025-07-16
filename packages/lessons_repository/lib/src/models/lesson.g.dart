// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Lesson', json, ($checkedConvert) {
      final val = Lesson(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
        updatedTime: $checkedConvert(
          'updated_time',
          (v) => _firestoreTimestampFromJson(v),
        ),
      );
      return val;
    }, fieldKeyMap: const {'updatedTime': 'updated_time'});

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'updated_time': _firestoreTimestampToJson(instance.updatedTime),
};
