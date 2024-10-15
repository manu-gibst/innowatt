import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innowatt/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

enum RoomType { channel, direct, group }

// Dats our new system of Database. The one we have as DatabaseUser and DatabaseIndividualChat are now USELESS FUCK EM
@immutable
class CloudChat {
  final String documentId;
  final List<String> userIds;
  final String name;
  const CloudChat({
    required this.documentId,
    required this.userIds,
    required this.name,
  });

  CloudChat.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userIds = snapshot.data()[ownerUserIdFieldName] as List<String>,
        name = snapshot.data()[nameFieldName] as String;
}
