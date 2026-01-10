import 'dart:convert';
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

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
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
          statusCode: response.statusCode
        );
    }
  }
}
