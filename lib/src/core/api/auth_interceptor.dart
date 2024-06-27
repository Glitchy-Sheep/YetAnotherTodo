import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get the API token from env config file
    final accessToken = dotenv.env['API_TOKEN'];

    // Add the API token to the request headers
    options.headers['Authorization'] = 'Bearer $accessToken';

    super.onRequest(options, handler);
  }
}
