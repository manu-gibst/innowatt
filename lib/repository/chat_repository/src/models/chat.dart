import 'package:json_annotation/json_annotation.dart';
part 'chat.g.dart';

@JsonSerializable()
class Chat {
  const Chat({
    required this.name,
    required this.uids,
  });
  final String name;
  final List<String> uids;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
