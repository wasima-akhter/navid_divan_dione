import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/variable.dart';

class ApiService {
  // Base URL for your API
  final String baseUrl = 'http://10.0.60.189:5005';

  // Singleton pattern for API service
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Headers that will be used in all requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Add auth token if available
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // Auth token storage
  String? _authToken;

  // Set auth token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear auth token (for logout)
  void clearAuthToken() {
    _authToken = null;
  }

  // Check internet connectivity
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Generic HTTP request method
  Future<dynamic> request({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    // Check internet connection first
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      return {
        'success': false,
        'message': 'No internet connection',
      };
    }

    // Build the URL with query parameters if provided
    var uri = Uri.parse('$baseUrl/$endpoint');
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }

    http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: _headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: _headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: _headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: _headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(
            uri,
            headers: _headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
if(body!=null){
  logger.d(body);
}
      // Parse response
      var responseData = json.decode(response.body);
      // logger.d(responseData);
      // Check status code
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        return {
          'success': false,
          'message': responseData['message'] ??
              'Request failed with status: ${response.statusCode}',
          'statusCode': response.statusCode,
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Request failed: ${e.toString()}',
      };
    }
  }
}
