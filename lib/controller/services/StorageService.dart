// lib/core/services/storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Singleton Pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<void> clearAllAuthData() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'isLoggedIn');
    await _storage.delete(key: 'isProfileCompleted');
    // Aur koi auth related keys hain to unhe bhi delete karein
  }
  // Standardized Keys
  static const String _tokenKey = 'access_token';
  static const String _mobileKey = 'mobile_number';
  static const String _isProfileCompletedKey = 'is_profile_completed';
  static const String _isFirstTimeKey = 'isFirstTime';
  static const String _isLoggedInKey = 'isLoggedIn';

  // --- TOKEN METHODS ---
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // --- PROFILE STATUS METHODS ---
  Future<void> saveProfileStatus(bool isCompleted) async {
    await _storage.write(key: _isProfileCompletedKey, value: isCompleted.toString());
  }

  Future<bool> getProfileStatus() async {
    final value = await _storage.read(key: _isProfileCompletedKey);
    return value == 'true';
  }

  // --- ONBOARDING & LOGIN FLAGS ---
  Future<void> saveLoginStatus(bool loggedIn) async {
    await _storage.write(key: _isLoggedInKey, value: loggedIn.toString());
  }

  Future<void> setFirstTime(bool status) async {
    await _storage.write(key: _isFirstTimeKey, value: status.toString());
  }

  Future<String?> readRaw(String key) async {
    return await _storage.read(key: key);
  }

  // --- MOBILE NUMBER ---
  Future<void> saveMobile(String mobile) async {
    await _storage.write(key: _mobileKey, value: mobile);
  }

  // --- UTILS ---
  Future<void> logout() async {
    await _storage.deleteAll();
  }
}



class SecureStorageService {
  static const FlutterSecureStorage _storage =
  FlutterSecureStorage();

  static const String _tokenKey = 'access_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  // User ID methods
  static Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: 'userId', value: userId);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}


