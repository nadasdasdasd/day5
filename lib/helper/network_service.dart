import 'package:dio/dio.dart';

class NetworkService {
  final Dio _dio = Dio();

  NetworkService() {
    _dio.options.baseUrl =
        'https://api.dictionaryapi.dev/api/v2/entries/en'; // Ganti dengan base URL API yang digunakan
    // _dio.options.connectTimeout = 5000;
    // _dio.options.receiveTimeout = 3000;
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Tambahkan metode lainnya sesuai kebutuhan seperti put, delete, dll.
}
