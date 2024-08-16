import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/src/features/weather/application/providers.dart';
import 'package:untitled/src/features/weather/data/weather_repository.dart';

import 'providers_test.mocks.dart';

@GenerateMocks([WeatherRepository])
void main() {
  late WeatherProvider weatherProvider;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    weatherProvider = WeatherProvider(mockWeatherRepository);
  });

  group('WeatherProvider', () {
    const cityName = 'London';
    const units = 'metric';

    test('initializes with default city and fetches weather data', () async {
      // Arrange
      final mockWeatherData = {
        'main': {'temp': 20}
      };
      final mockForecastData = {'list': []};

      when(mockWeatherRepository.fetchCurrentWeather(cityName, units))
          .thenAnswer((_) async => mockWeatherData);

      when(mockWeatherRepository.fetchWeatherForecast(cityName, units))
          .thenAnswer((_) async => mockForecastData);

      // Act
      await weatherProvider.fetchWeather(cityName);

      // Assert
      expect(weatherProvider.weatherData, mockWeatherData);
      expect(weatherProvider.forecastData, mockForecastData);
      expect(weatherProvider.errorMessage, isNull);
    });

    // Add more tests here
  });
}
