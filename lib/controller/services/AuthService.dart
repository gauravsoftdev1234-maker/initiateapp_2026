import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'StorageService.dart';
import 'app_api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Helper to get real Device ID
  Future<String> _getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        var androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        var iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? "test_ios";
      }
    } catch (e) {
      debugPrint("Device ID Error: $e");
    }
    return "test_device";
  }

  /// ✅ SEND OTP
  Future<Map<String, dynamic>> sendOtp(String mobileNo) async {
    try {
      final Response response = await _apiService.post('api/Auth/sendOtp', {
        "MobileNo": mobileNo,
      });
      final data = response.data;
      if (response.statusCode == 200 && data['isSuccess'] == true) {
        return {'success': true, 'message': data['Otp']};
      }
      return {'success': false, 'message': 'OTP send failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// ✅ VERIFY OTP V2 (Updated with Device Params)
  Future<Map<String, dynamic>> verifyOtp(String mobileNo, String otp) async {
    try {
      String deviceId = await _getDeviceId();
      final Response response = await _apiService.post('api/Auth/verifyOtpV2', {
        "MobileNo": mobileNo,
        "OTP": otp,
        "p_DeviceType": Platform.isAndroid ? "Android" : "iOS",
        "p_DeviceId": deviceId,
        "p_FCMToken": "", // Placeholder for your FCM logic
      });

      final data = response.data;
      if (response.statusCode == 200 && data['isSuccess'] == true) {
        return {
          'success': true,
          'isProfileCompleted': data['isProfileCompleted'] ?? false,
          'message': data['ResponseMessage'],
        };
      }
      return {'success': false, 'message': data['ResponseMessage'] ?? 'Failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// 🔍 CHECK ALREADY LOGIN (New API Logic)
  Future<Map<String, dynamic>> checkAlreadyLogin() async {
    try {
      String? token = await StorageService().getToken();
      String deviceId = await _getDeviceId();

      debugPrint("Device ID: $deviceId");
      debugPrint("Token exists: ${token != null}");

      if (token == null) {
        return {
          'isSuccess': false,
          'message': 'No authentication token found',
          'Response': 0,
        };
      }

      final Response response = await _apiService.get(
        "api/Profile/AlreadyLogin?DeviceID=$deviceId",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      debugPrint("AlreadyLogin API Response: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      // Handle specific Dio errors
      if (e.response?.statusCode == 401) {
        debugPrint("Authentication failed - token expired or invalid");

        return {
          'isSuccess': false,
          'message': 'Session expired. Please login again.',
          'Response': 401,
        };
      }

      debugPrint("DioException: ${e.message}");
      return {
        'isSuccess': false,
        'message': e.message ?? 'Network error',
        'Response': e.response?.statusCode ?? 0,
      };
    } catch (e) {
      debugPrint("Unexpected error: $e");
      return {'isSuccess': false, 'message': e.toString(), 'Response': 0};
    }
  }

  /// 🔐 JWT LOGIN
  Future<Map<String, dynamic>> loginAndSaveToken({
    required String mobile,
    required String otp,
  }) async {
    try {
      final Response response = await _apiService.loginWithOtp(
        mobile: mobile,
        otp: otp,
      );
      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        if (token != null) {
          await SecureStorageService.saveToken(token);
          return {'success': true, 'token': token};
        }
      }
      return {'success': false, 'message': 'JWT login failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
