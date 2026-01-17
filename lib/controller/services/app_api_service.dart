import 'package:dio/dio.dart';
final String base="https://initiate.cloudbill.in";
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://initiate.cloudbill.in/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  /// POST (JSON)
  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    return await _dio.post(
      endpoint,
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  /// GET (Query Params)
  Future<Response> get(
      String endpoint, {
        Map<String, dynamic>? query,
        Options? options,
      }) async {
    return await _dio.get(
      endpoint,
      queryParameters: query,
      options: options,
    );
  }

  /// 🔐 LOGIN API (x-www-form-urlencoded)
  Future<Response> loginWithOtp({
    required String mobile,
    required String otp,
  }) async {
    return await _dio.get(
      'api/Login',
      data: {
        'grant_type': 'password',
        'username': mobile,
        'password': otp,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }
}
