// lib/core/services/storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys
  static const String _authTokenKey = 'auth_token';
  static const String _mobileNumberKey = 'mobile_number';
  static const String _isProfileCompletedKey = 'is_profile_completed';

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  // Get token
  Future<String?> getToken() async {
    return await _storage.read(key: _authTokenKey);
  }

  // Save mobile number
  Future<void> saveMobileNumber(String mobileNo) async {
    await _storage.write(key: _mobileNumberKey, value: mobileNo);
  }

  // Get mobile number
  Future<String?> getMobileNumber() async {
    return await _storage.read(key: _mobileNumberKey);
  }

  // Save profile completion status
  Future<void> saveProfileCompletionStatus(bool isCompleted) async {
    await _storage.write(
      key: _isProfileCompletedKey,
      value: isCompleted.toString(),
    );
  }

  // Get profile completion status
  Future<bool> getProfileCompletionStatus() async {
    final value = await _storage.read(key: _isProfileCompletedKey);
    return value == 'true';
  }

  // Clear all data (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}



class SecureStorageService {
  static const FlutterSecureStorage _storage =
  FlutterSecureStorage();

  static const String _tokenKey = 'access_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}


