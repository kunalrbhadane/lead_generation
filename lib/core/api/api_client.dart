import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../storage/storage_service.dart';
import 'api_exceptions.dart';

class ApiClient {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      
      final response = await http.get(uri, headers: headers);
      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No Internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final response = await http.post(
        uri, 
        headers: headers, 
        body: jsonEncode(body)
      );
      
      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No Internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  Future<dynamic> postMultipart(String endpoint, Map<String, String> fields, Map<String, dynamic> files) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);
      
      request.fields.addAll(fields);

      for (var entry in files.entries) {
        if (entry.value is File) {
          final file = entry.value as File;
          if (file.existsSync()) {
            request.files.add(await http.MultipartFile.fromPath(entry.key, file.path));
          }
        } else if (entry.value is List<File>) {
          final list = entry.value as List<File>;
          for (var file in list) {
             if (file.existsSync()) {
               request.files.add(await http.MultipartFile.fromPath(entry.key, file.path));
             }
          }
        }
      }

      final streamkdResponse = await request.send();
      final response = await http.Response.fromStream(streamkdResponse);

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No Internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    log(response.headers.toString());
    final dynamic decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      // Normalizing common token keys
      if (decoded['token'] == null) {
        if (decoded['User_token'] != null) {
          decoded['token'] = decoded['User_token'];
        } else if (decoded['data'] != null && decoded['data']['token'] != null) {
          decoded['token'] = decoded['data']['token'];
        } else if (decoded['accessToken'] != null) {
          decoded['token'] = decoded['accessToken'];
        }
      }

      final setCookie = response.headers['set-cookie'];
      if (setCookie != null && decoded['token'] == null) {
        final token = _extractTokenFromCookie(setCookie);
        if (token != null) {
          decoded['token'] = token;
        }
      }
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return decoded;
      case 400:
        throw ApiException('Bad Request: ${response.body}', statusCode: 400);
      case 401:
      case 403:
        throw UnauthorizedException('Unauthorized');
      case 404:
        throw ApiException('Not Found', statusCode: 404);
      case 500:
      default:
        throw ApiException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}',
            statusCode: response.statusCode);
    }
  }

  String? _extractTokenFromCookie(String setCookie) {
    try {
      // Cookies can be separated by semicolons
      final parts = setCookie.split(';');
      for (var part in parts) {
        final trimmed = part.trim();
        
        // Split by comma in case multiple cookies are combined in one part (common in some HTTP bridges)
        final subParts = trimmed.split(',');
        for (var sub in subParts) {
          final subTrimmed = sub.trim();
          final lower = subTrimmed.toLowerCase();
          
          if (lower.startsWith('token=') || 
              lower.startsWith('user_token=') || 
              lower.startsWith('auth_token=') ||
              lower.startsWith('access_token=')) {
            final eqIndex = subTrimmed.indexOf('=');
            if (eqIndex != -1) {
              return subTrimmed.substring(eqIndex + 1);
            }
          }
        }
      }
    } catch (e) {
      log('Error extracting token from cookie: $e');
      return null;
    }
    return null;
  }
}
