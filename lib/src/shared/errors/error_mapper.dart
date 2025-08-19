import 'package:dio/dio.dart';
import 'failure.dart';

class ErrorMapper {
  static Failure mapToFailure(Object error) {
    if (error is Failure) return error;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return const NetworkFailure(message: 'Error de conexión. Verifica tu internet.');
        case DioExceptionType.connectionTimeout:
          return const TimeoutFailure(message: 'Tiempo de conexión agotado. Intenta de nuevo.');
        case DioExceptionType.receiveTimeout:
          return const TimeoutFailure(message: 'Tiempo de respuesta agotado. Intenta de nuevo.');
        case DioExceptionType.sendTimeout:
          return const TimeoutFailure(message: 'Tiempo de envío agotado. Intenta de nuevo.');
        case DioExceptionType.badResponse:
          final status = error.response?.statusCode;
          if (status == 401) {
            return UnauthorizedFailure(message: 'No autorizado', details: _errorBody(error));
          } else if (status == 404) {
            return NotFoundFailure(message: 'Recurso no encontrado', details: _errorBody(error));
          } else if (status != null && status >= 500) {
            return ServerFailure(message: 'Error del servidor', statusCode: status, details: _errorBody(error));
          } else {
            return ServerFailure(message: 'Error en la respuesta del servidor', statusCode: status, details: _errorBody(error));
          }
        case DioExceptionType.cancel:
          return const UnexpectedFailure(message: 'Solicitud cancelada.');
        default:
          return const UnexpectedFailure(message: 'Error inesperado. Intenta de nuevo.');
      }
    }

    if (error is FormatException) {
      return const ValidationFailure(message: 'Formato de datos inválido');
    }

    return UnexpectedFailure(message: error.toString());
  }

  static Map<String, dynamic>? _errorBody(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) return data;
    return null;
  }
}
