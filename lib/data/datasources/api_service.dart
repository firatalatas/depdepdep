import '../../models/earthquake_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  // Base URL'inizi buraya girin
  final String _baseUrl = 'https://api.orhanaydogdu.com.tr';

  Future<List<Earthquake>> fetchEarthquakes() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/deprem/kandilli/live',
        queryParameters: {
          'limit': 100,
          'skip': 0,
        },
      );

      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result is List) {
          return result.map((e) => Earthquake.fromJson(e)).toList();
        }
        return [];
      } else {
        throw Exception('Failed to load earthquakes');
      }
    } catch (e) {
      rethrow;
    }
  }
}
