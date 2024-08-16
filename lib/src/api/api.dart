import 'dart:convert';

import 'package:http/http.dart' as http;

import '../features/weather/data/api_exception.dart';

class WeatherAPI {
  final String _apiKey;
  final http.Client _client; // Add http.Client

  WeatherAPI(this._apiKey, [http.Client? client])
      : _client = client ?? http.Client(); // Allow injection of http.Client

  final String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> getWeatherByCity(
      String city, String units) async {
    final url = '$_baseUrl/weather?q=$city&appid=$_apiKey&units=$units';
    final response = await _getRequest(url);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getForecastByCity(
      String city, String units) async {
    final url = '$_baseUrl/forecast?q=$city&cnt=30&appid=$_apiKey&units=$units';
    final response = await _getRequest(url);
    return json.decode(response.body);
  }

  Future<http.Response> _getRequest(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw InvalidApiKeyException();
      } else if (response.statusCode == 404) {
        throw CityNotFoundException();
      } else {
        throw Exception('Unexpected error: ${response.statusCode}');
      }
    } on http.ClientException {
      throw NoInternetConnectionException();
    }
  }
}
