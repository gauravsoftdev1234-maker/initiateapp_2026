import 'package:dio/dio.dart';
import 'StorageService.dart';
import 'app_api_service.dart';


class AuthService {
  final ApiService _apiService = ApiService();

  /// 📩 SEND OTP
  Future<Map<String, dynamic>> sendOtp(String mobileNo) async {
    try {
      final Response response = await _apiService.post(
        'api/Auth/sendOtp',
        {"MobileNo": mobileNo},
      );

      final data = response.data;

      if (response.statusCode == 200 && data['isSuccess'] == true) {
        return {
          'success': true,
          'message': data['Otp'],
        };
      }

      return {
        'success': false,
        'message': data['Otp'] ?? 'OTP send failed',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// ✅ VERIFY OTP
  Future<Map<String, dynamic>> verifyOtp(
      String mobileNo, String otp) async {
    try {
      final Response response = await _apiService.post(
        'api/Auth/verifyOtp',
        {
          "MobileNo": mobileNo,
          "OTP": otp,
        },
      );

      final data = response.data;

      if (response.statusCode == 200 && data['isSuccess'] == true) {
        return {
          'success': true,
          'isProfileCompleted': data['isProfileCompleted'] ?? false,
        };
      }

      return {
        'success': false,
        'message': data['ResponseMessage'] ?? 'OTP verification failed',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// 🔐 JWT LOGIN + SAVE TOKEN
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

        if (token != null && token.toString().isNotEmpty) {
          await SecureStorageService.saveToken(token);

          return {
            'success': true,
            'token': token,
          };
        }
      }

      return {'success': false, 'message': 'JWT login failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
