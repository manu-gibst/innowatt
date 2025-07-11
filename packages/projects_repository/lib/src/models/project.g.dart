// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Project',
  json,
  ($checkedConvert) {
    final val = Project(
      id: $checkedConvert('id', (v) => v as String?),
      name: $checkedConvert('name', (v) => v as String),
      modulesCount: $checkedConvert('modules_count', (v) => (v as num).toInt()),
      currentModule: $checkedConvert(
        'current_module',
        (v) => (v as num).toInt(),
      ),
      updatedTime: $checkedConvert(
        'updated_time',
        (v) => _firestoreTimestampFromJson(v),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'modulesCount': 'modules_count',
    'currentModule': 'current_module',
    'updatedTime': 'updated_time',
  },
);

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'modules_count': instance.modulesCount,
  'current_module': instance.currentModule,
  'updated_time': _firestoreTimestampToJson(instance.updatedTime),
};
