/// Exceptions related to Firestore
class FirestoreDatabaseFailure implements Exception {
  const FirestoreDatabaseFailure([this.message = 'An unknown error occured']);

  final String message;

  factory FirestoreDatabaseFailure.fromCode(String code) {
    switch (code) {
      case 'storage/unauthenticated':
        return const FirestoreDatabaseFailure('You are not authenticated');
      case 'storage/unauthorized':
        return const FirestoreDatabaseFailure(
          'You are not authorized to perform this operation',
        );
      case 'storage/server-file-wrong-size':
        return const FirestoreDatabaseFailure(
          'Try uploading the file again later',
        );
      case 'storage/unknown':
      case 'storage/object-not-found':
      case 'storage/bucket-not-found':
      case 'storage/project-not-found':
      case 'storage/quota-exceeded':
      case 'storage/retry-limit-exceeded':
      case 'storage/invalid-checksum':
      case 'storage/canceled':
      case 'storage/invalid-event-name':
      case 'storage/invalid-url':
      case 'storage/invalid-argument':
      case 'storage/no-default-bucket':
      case 'storage/cannot-slice-blob':
      default:
        return const FirestoreDatabaseFailure(
          'An server-side error occured. Try again later',
        );
    }
  }
}
