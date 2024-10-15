import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innowatt/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudUser {
  final String documentId;
  final String email;
  final String password;
  const CloudUser({
    required this.documentId,
    required this.email,
    required this.password,
  });

  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        email = snapshot.data()[emailFieldName],
        password = snapshot.data()[passwordFieldName] as String;
}
