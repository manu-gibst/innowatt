import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innowatt/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

// Dats our new system of Database. The one we have as DatabaseUser and DatabaseIndividualChat are now USELESS FUCK EM
@immutable
class CloudMessage {
  final String documentId;
  final String ownerUserId;
  final String text;
  final int createdAt;
  const CloudMessage({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.createdAt,
  });

  CloudMessage.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String,
        createdAt = snapshot.data()[createdAtFieldName] as int;
}
