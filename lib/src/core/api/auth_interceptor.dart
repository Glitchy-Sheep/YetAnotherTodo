import 'package:dio/dio.dart';

class AuthDioInterceptor extends Interceptor {
  final String _token;
  AuthDioInterceptor({
    required String token,
  }) : _token = token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get the API token from env config file
    final accessToken = _token;

    // Add the API token to the request headers
    options.headers['Authorization'] = 'Bearer $accessToken';

    super.onRequest(options, handler);
  }
}
