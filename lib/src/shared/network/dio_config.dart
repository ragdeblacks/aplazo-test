import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:cocinando_con_flow/src/core/config/environment_config.dart';
import 'package:cocinando_con_flow/src/shared/network/cache/http_cache_interceptor.dart';
import 'package:cocinando_con_flow/src/shared/network/connectivity/connectivity_interceptor.dart';

class DioConfig {
  static Dio createDio() {
    final dio = Dio();
    
    dio.options = BaseOptions(
      baseUrl: ConfiguracionEntorno.urlBaseApi,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'CocinandoConFlow/1.0.0',
      },
    );

    dio.interceptors.addAll([
      ConnectivityInterceptor(),
      HttpCacheInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);

    return dio;
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (ConfiguracionEntorno.habilitarLogging) {
      debugPrint('🌐 HTTP Request: ${options.method} ${options.uri}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('   Query Params: ${options.queryParameters}');
      }
      if (options.data != null) {
        debugPrint('   Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (ConfiguracionEntorno.habilitarLogging) {
      final isCached = response.data is Map && response.data['cached'] == true;
      final status = response.statusCode;
      final method = response.requestOptions.method;
      final path = response.requestOptions.path;
      
      if (isCached) {
        debugPrint('💾 HTTP Response (CACHED): $status $method $path');
      } else {
        debugPrint('✅ HTTP Response: $status $method $path');
      }
      
      if (ConfiguracionEntorno.esDesarrollo) {
        debugPrint('   Response Size: ${response.data.toString().length} chars');
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (ConfiguracionEntorno.habilitarLogging) {
      final method = err.requestOptions.method;
      final path = err.requestOptions.path;
      final type = err.type.name;
      final message = err.message ?? 'Unknown error';
      
      debugPrint('❌ HTTP Error: $type $method $path');
      debugPrint('   Error: $message');
      
      if (err.response != null) {
        debugPrint('   Status: ${err.response!.statusCode}');
        debugPrint('   Response: ${err.response!.data}');
      }
    }
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String userMessage;
    
    switch (err.type) {
      case DioExceptionType.connectionError:
        userMessage = 'Error de conexión. Verifica tu internet.';
        break;
      case DioExceptionType.connectionTimeout:
        userMessage = 'Tiempo de conexión agotado. Intenta de nuevo.';
        break;
      case DioExceptionType.receiveTimeout:
        userMessage = 'Tiempo de respuesta agotado. Intenta de nuevo.';
        break;
      case DioExceptionType.sendTimeout:
        userMessage = 'Tiempo de envío agotado. Intenta de nuevo.';
        break;
      case DioExceptionType.badResponse:
        if (err.response?.statusCode == 404) {
          userMessage = 'Recurso no encontrado.';
        } else if (err.response?.statusCode != null && err.response!.statusCode! >= 500) {
          userMessage = 'Error del servidor. Intenta más tarde.';
        } else {
          userMessage = 'Error en la respuesta del servidor.';
        }
        break;
      case DioExceptionType.cancel:
        userMessage = 'Request cancelada.';
        break;
      default:
        userMessage = 'Error inesperado. Intenta de nuevo.';
    }

    final newError = DioException(
      requestOptions: err.requestOptions,
      type: err.type,
      response: err.response,
      message: userMessage,
    );
    
    handler.next(newError);
  }
}
