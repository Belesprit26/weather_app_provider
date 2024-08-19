import '../../../api/api.dart';

class WeatherRepository {
  final WeatherAPI _weatherAPI;

  // Constructor to initialize WeatherAPI with the given API key
  WeatherRepository(String apiKey) : _weatherAPI = WeatherAPI(apiKey);

  // Fetch current weather data by city and units
  Future<Map<String, dynamic>> fetchCurrentWeather(String city, String units) {
    return _weatherAPI.getWeatherByCity(city, units);
  }

  // Fetch 3-hour forecast data by city and units
  Future<Map<String, dynamic>> fetchWeatherForecast(String city, String units) {
    return _weatherAPI.getForecastByCity(city, units);
  }
}
