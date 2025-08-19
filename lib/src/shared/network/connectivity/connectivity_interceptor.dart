import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityInterceptor extends Interceptor {
  final Connectivity _connectivity = Connectivity();
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    
    if (connectivityResult == ConnectivityResult.none) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No hay conexión a internet',
        ),
      );
      return;
    }

    options.headers['X-Connectivity-Type'] = connectivityResult.name;
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && _canRetry(err.requestOptions)) {
      final retryCount = _getRetryCount(err.requestOptions);
      
      if (retryCount < _maxRetries) {
        _incrementRetryCount(err.requestOptions);
        
        await Future.delayed(_retryDelay * (retryCount + 1));
        
        try {
          final response = await _retryRequest(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (retryError) {
          // Si falla el reintento, continuar con el error original
        }
      }
    }
    
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
           err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           (err.response?.statusCode != null && 
            err.response!.statusCode! >= 500);
  }

  bool _canRetry(RequestOptions options) {
    return options.method == 'GET';
  }

  int _getRetryCount(RequestOptions options) {
    return options.extra['retry_count'] ?? 0;
  }

  void _incrementRetryCount(RequestOptions options) {
    final currentCount = _getRetryCount(options);
    options.extra['retry_count'] = currentCount + 1;
  }

  Future<Response> _retryRequest(RequestOptions options) async {
    final dio = Dio();
    
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.sendTimeout = const Duration(seconds: 10);
    
    final requestOptions = RequestOptions(
      method: options.method,
      path: options.path,
      baseUrl: options.baseUrl,
      headers: options.headers,
      queryParameters: options.queryParameters,
      data: options.data,
      extra: options.extra,
    );
    
    return await dio.fetch(requestOptions);
  }
}
