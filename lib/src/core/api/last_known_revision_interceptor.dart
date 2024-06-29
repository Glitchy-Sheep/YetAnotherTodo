import 'package:dio/dio.dart';

class LastKnownRevisionInterceptor extends Interceptor {
  final Future<int> Function() getLastRevision;

  LastKnownRevisionInterceptor(this.getLastRevision);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final lastKnownRevision = await getLastRevision();
    options.headers['X-Last-Known-Revision'] = lastKnownRevision;
    handler.next(options);
  }
}
