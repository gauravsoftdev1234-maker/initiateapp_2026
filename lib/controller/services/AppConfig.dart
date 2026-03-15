import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'StorageService.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Global token check method
  Future<void> checkTokenAndNavigate() async {
    // Agar token invalid hai to login screen par jayein
    final navigator = navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
}



class TokenInterceptor extends Interceptor {
  final StorageService _storageService = StorageService();
  final AppConfig _appConfig = AppConfig();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add your custom logic here if needed
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is due to unauthorized (401) or forbidden (403)
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      debugPrint("Token expired or invalid. Redirecting to login...");

      // // Clear stored token
      // await _storageService.re();

      // Redirect to login screen
      _appConfig.checkTokenAndNavigate();

      // You can also reject the error to prevent further processing
      return handler.reject(err);
    }

    super.onError(err, handler);
  }
}