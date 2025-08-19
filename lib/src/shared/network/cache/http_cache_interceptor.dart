import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpCacheInterceptor extends Interceptor {
  static const String _cachePrefix = 'http_cache_';
  static const String _timestampPrefix = 'http_timestamp_';
  static const Duration _defaultExpiration = Duration(minutes: 10);
  static const Duration _shortExpiration = Duration(minutes: 2);
  static const Duration _longExpiration = Duration(hours: 1);

  final Map<String, String> _memoryCache = {};
  final Map<String, DateTime> _memoryTimestamps = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.method != 'GET') {
      handler.next(options);
      return;
    }

    final cacheKey = _generateCacheKey(options);
    final cachedResponse = await _getCachedResponse(cacheKey);
    
    if (cachedResponse != null) {
      handler.resolve(cachedResponse);
      return;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 200 && response.requestOptions.method == 'GET') {
      final cacheKey = _generateCacheKey(response.requestOptions);
      final expiration = _getExpirationTime(response.requestOptions.uri.path);
      
      await _cacheResponse(cacheKey, response, expiration);
    }
    
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionError || 
        err.type == DioExceptionType.connectionTimeout) {
      
      final cacheKey = _generateCacheKey(err.requestOptions);
      final cachedResponse = await _getCachedResponse(cacheKey);
      
      if (cachedResponse != null) {
        cachedResponse.data = {
          'cached': true,
          'original_data': cachedResponse.data,
          'cache_timestamp': DateTime.now().toIso8601String(),
        };
        
        handler.resolve(cachedResponse);
        return;
      }
    }
    
    handler.next(err);
  }

  String _generateCacheKey(RequestOptions options) {
    final uri = options.uri;
    final queryParams = uri.queryParameters.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    return '$_cachePrefix${uri.path}${queryParams.isNotEmpty ? '?$queryParams' : ''}';
  }

  Future<Response?> _getCachedResponse(String cacheKey) async {
    if (_memoryCache.containsKey(cacheKey) && _isValidInMemory(cacheKey)) {
      final cachedData = _memoryCache[cacheKey]!;
      return _deserializeResponse(cachedData);
    }

    final prefs = await SharedPreferences.getInstance();
    final cacheData = prefs.getString(cacheKey);
    final timestamp = prefs.getInt('$_timestampPrefix$cacheKey');

    if (cacheData != null && timestamp != null) {
      final cacheAge = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
      final expiration = _getExpirationTime(cacheKey);
      
      if (cacheAge < expiration) {
        _memoryCache[cacheKey] = cacheData;
        _memoryTimestamps[cacheKey] = DateTime.now();
        
        return _deserializeResponse(cacheData);
      }
    }

    return null;
  }

  Future<void> _cacheResponse(String cacheKey, Response response, Duration expiration) async {
    final serializedData = _serializeResponse(response);
    
    _memoryCache[cacheKey] = serializedData;
    _memoryTimestamps[cacheKey] = DateTime.now();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cacheKey, serializedData);
    await prefs.setInt('$_timestampPrefix$cacheKey', DateTime.now().millisecondsSinceEpoch);
  }

  Duration _getExpirationTime(String path) {
    if (path.contains('/search') || path.contains('/filter')) {
      return _shortExpiration;
    } else if (path.contains('/categories') || path.contains('/list')) {
      return _longExpiration;
    } else {
      return _defaultExpiration;
    }
  }

  bool _isValidInMemory(String key) {
    if (!_memoryTimestamps.containsKey(key)) return false;
    final age = DateTime.now().difference(_memoryTimestamps[key]!);
    final expiration = _getExpirationTime(key);
    return age < expiration;
  }

  String _serializeResponse(Response response) {
    return jsonEncode({
      'statusCode': response.statusCode,
      'headers': response.headers.map,
      'data': response.data,
      'requestOptions': {
        'method': response.requestOptions.method,
        'path': response.requestOptions.path,
        'queryParameters': response.requestOptions.queryParameters,
      },
    });
  }

  Response _deserializeResponse(String cachedData) {
    final Map<String, dynamic> data = jsonDecode(cachedData);

    final Map<String, dynamic> headersDynamic =
        Map<String, dynamic>.from(data['headers'] ?? <String, dynamic>{});
    final Map<String, List<String>> headersMap = headersDynamic.map(
      (key, value) => MapEntry(
        key,
        List<String>.from(value as List),
      ),
    );

    return Response(
      statusCode: data['statusCode'] as int?,
      headers: Headers.fromMap(headersMap),
      data: data['data'],
      requestOptions: RequestOptions(
        method: data['requestOptions']['method'] as String?,
        path: data['requestOptions']['path'] as String,
        queryParameters: Map<String, dynamic>.from(
          data['requestOptions']['queryParameters'] as Map,
        ),
      ),
    );
  }

  Future<void> clearExpiredCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_timestampPrefix)) {
        final timestamp = prefs.getInt(key);
        if (timestamp != null) {
          final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
          final cacheKey = key.replaceFirst(_timestampPrefix, '');
          final expiration = _getExpirationTime(cacheKey);
          
          if (age >= expiration) {
            await prefs.remove('${_cachePrefix}_$cacheKey');
            await prefs.remove(key);
          }
        }
      }
    }

    final expiredKeys = <String>[];
    for (final entry in _memoryTimestamps.entries) {
      if (!_isValidInMemory(entry.key)) {
        expiredKeys.add(entry.key);
      }
    }
    for (final key in expiredKeys) {
      _memoryCache.remove(key);
      _memoryTimestamps.remove(key);
    }
  }

  Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_cachePrefix) || key.startsWith(_timestampPrefix)) {
        await prefs.remove(key);
      }
    }

    _memoryCache.clear();
    _memoryTimestamps.clear();
  }
}
