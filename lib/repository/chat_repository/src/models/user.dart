import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.uid,
    required this.email,
    this.fullname = '',
  });

  final String uid;
  final String email;
  final String fullname;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      uid: data?['uid'],
      email: data?['email'],
      fullname: data?['fullname'],
    );
  }

  Map<String, dynamic> toFirestore() => toJson();
}
