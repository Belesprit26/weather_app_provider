import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/src/api/api.dart';
import 'package:untitled/src/features/weather/data/api_exception.dart';

import 'api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late WeatherAPI weatherAPI;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    weatherAPI =
        WeatherAPI('dummy_api_key', mockHttpClient); // Inject the mock client
  });

  Future<Map<String, dynamic>> loadJson(String path) async {
    final file = File(path);
    final jsonString = await file.readAsString();
    return json.decode(jsonString);
  }

  group('WeatherAPI', () {
    const cityName = 'London';
    const units = 'metric';
    final weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=dummy_api_key&units=$units';
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&cnt=30&appid=dummy_api_key&units=$units';

    test('fetches current weather data successfully', () async {
      // Arrange
      final mockWeatherData =
          await loadJson('test/mockData/dummy_weather_response.json');
      final mockResponse = http.Response(json.encode(mockWeatherData), 200);
      when(mockHttpClient.get(Uri.parse(weatherUrl)))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await weatherAPI.getWeatherByCity(cityName, units);

      // Assert
      expect(result['main']['temp'], 20);
      verify(mockHttpClient.get(Uri.parse(weatherUrl))).called(1);
    });

    test('fetches weather forecast data successfully', () async {
      // Arrange
      final mockForecastData =
          await loadJson('test/mockData/dummy_forecast_response.json');
      final mockResponse = http.Response(json.encode(mockForecastData), 200);
      when(mockHttpClient.get(Uri.parse(forecastUrl)))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await weatherAPI.getForecastByCity(cityName, units);

      // Assert
      expect(result['list'][0]['main']['temp'], 20);
      verify(mockHttpClient.get(Uri.parse(forecastUrl))).called(1);
    });

    test('throws InvalidApiKeyException on 401 error', () async {
      // Arrange
      final mockResponse = http.Response('Unauthorized', 401);
      when(mockHttpClient.get(Uri.parse(weatherUrl)))
          .thenAnswer((_) async => mockResponse);

      // Act & Assert
      expect(() => weatherAPI.getWeatherByCity(cityName, units),
          throwsA(isA<InvalidApiKeyException>()));
      verify(mockHttpClient.get(Uri.parse(weatherUrl))).called(1);
    });

    test('throws CityNotFoundException on 404 error', () async {
      // Arrange
      final mockResponse = http.Response('Not Found', 404);
      when(mockHttpClient.get(Uri.parse(weatherUrl)))
          .thenAnswer((_) async => mockResponse);

      // Act & Assert
      expect(() => weatherAPI.getWeatherByCity(cityName, units),
          throwsA(isA<CityNotFoundException>()));
      verify(mockHttpClient.get(Uri.parse(weatherUrl))).called(1);
    });

    test('throws NoInternetConnectionException on ClientException', () async {
      // Arrange
      when(mockHttpClient.get(Uri.parse(weatherUrl)))
          .thenThrow(http.ClientException('No Internet'));

      // Act & Assert
      expect(() => weatherAPI.getWeatherByCity(cityName, units),
          throwsA(isA<NoInternetConnectionException>()));
      verify(mockHttpClient.get(Uri.parse(weatherUrl))).called(1);
    });
  });
}
