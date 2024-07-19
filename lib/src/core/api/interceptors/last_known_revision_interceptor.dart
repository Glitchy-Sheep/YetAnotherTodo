import 'package:dio/dio.dart';

typedef RevisionGetter = Future<int> Function();

class LastKnownRevisionInterceptor extends Interceptor {
  final RevisionGetter lastRevisionGetter;

  LastKnownRevisionInterceptor({
    required this.lastRevisionGetter,
  });

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final lastKnownRevision = await lastRevisionGetter();
    options.headers['X-Last-Known-Revision'] = lastKnownRevision;
    handler.next(options);
  }
}
