import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Store a value securely
  Future<void> storeValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Retrieve a stored value
  Future<String?> retrieveValue(String key) async {
    return await _storage.read(key: key);
  }

  // Remove a stored value
  Future<void> removeValue(String key) async {
    await _storage.delete(key: key);
  }

  // Clear all stored values
  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }

  // Additional storage management methods as required
}
