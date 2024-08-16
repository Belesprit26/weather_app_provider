import 'package:http/http.dart' as http;
import 'dart:convert';
import '../features/weather/data/api_exception.dart';
import 'api_keys.dart'; // Import the API keys and service locator

class WeatherAPI {
  static final WeatherAPI _instance = WeatherAPI._internal();

  factory WeatherAPI() {
    return _instance;
  }

  WeatherAPI._internal();

  final String _apiKey = getIt<String>(); // Get the injected API key
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> getWeatherByCity(String city, String units) async {
    final url = '$_baseUrl/weather?q=$city&appid=$_apiKey&units=$units';

    final response = await _getRequest(url);

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getForecastByCity(String city, String units) async {
    final url = '$_baseUrl/forecast?q=$city&cnt=30&appid=$_apiKey&units=$units';

    final response = await _getRequest(url);

    return json.decode(response.body);
  }

  Future<http.Response> _getRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        throw InvalidApiKeyException();
      } else if (response.statusCode == 404) {
        throw CityNotFoundException();
      } else {
        throw Exception('Oops, there seems to be a problem: \n$response');
      }
    } on http.ClientException {
      throw NoInternetConnectionException();
    }
  }
}