import 'package:flutter/material.dart';

class ConfiguracionEntorno {
  static const String _entorno = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static const String _urlBaseApi = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://www.themealdb.com/api/json/v1/1',
  );

  static const bool _habilitarLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  static const bool _habilitarAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  static String get entorno => _entorno;

  static String get urlBaseApi => _urlBaseApi;

  static bool get habilitarLogging => _habilitarLogging;

  static bool get habilitarAnalytics => _habilitarAnalytics;

  static bool get esDesarrollo => _entorno == 'development';

  static bool get esStaging => _entorno == 'staging';

  static bool get esProduccion => _entorno == 'production';

  static String get nombreEntorno {
    switch (_entorno) {
      case 'development':
        return 'Desarrollo';
      case 'staging':
        return 'Staging';
      case 'production':
        return 'Producción';
      default:
        return 'Desconocido';
    }
  }

  static int get colorEntorno {
    switch (_entorno) {
      case 'development':
        return 0xFF00BCD4;
      case 'staging':
        return 0xFFFF9800;
      case 'production':
        return 0xFF4CAF50;
      default:
        return 0xFF9E9E9E;
    }
  }

  static IconData get iconoEntorno {
    switch (_entorno) {
      case 'development':
        return Icons.developer_mode;
      case 'staging':
        return Icons.science;
      case 'production':
        return Icons.rocket_launch;
      default:
        return Icons.help;
    }
  }
}
