import 'package:firebase_storage/firebase_storage.dart';

/// A wrapper around [FirebaseStorage] to make it mockable for tests.
class FirebaseStorageWrapper {
  final FirebaseStorage _storage;

  FirebaseStorageWrapper({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Exposes the ref() method from the underlying [FirebaseStorage] instance.
  Reference ref([String? path]) => _storage.ref(path);
}
