import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service for securely storing key-value pairs.
///
/// Utilizes FlutterSecureStorage to provide secure storage functionalities.
class StorageService {
  // Instance of FlutterSecureStorage for secure data storage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Stores a value securely associated with a given key.
  ///
  /// [key] is the identifier for the stored value.
  /// [value] is the data to be stored securely.
  ///
  /// This method securely writes the key-value pair to storage.
  Future<void> storeValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Retrieves a stored value associated with a given key.
  ///
  /// [key] is the identifier for the value to be retrieved.
  ///
  /// Returns the value as a String if it exists, or `null` if it doesn't.
  ///
  /// This method reads the value associated with the key from secure storage.
  Future<String?> retrieveValue(String key) async {
    return await _storage.read(key: key);
  }

  /// Removes a stored value associated with a given key.
  ///
  /// [key] is the identifier for the value to be removed.
  ///
  /// This method deletes the key-value pair from storage.
  Future<void> removeValue(String key) async {
    await _storage.delete(key: key);
  }

  /// Clears all stored values.
  ///
  /// This method deletes all key-value pairs from storage, effectively clearing it.
  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }

  // Additional storage management methods can be implemented as required
}
