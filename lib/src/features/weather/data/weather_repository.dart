import '../../../api/api.dart';

class WeatherRepository {
  final WeatherAPI _weatherAPI = WeatherAPI();

  Future<Map<String, dynamic>> fetchCurrentWeather(String city, String units) async {
    return await _weatherAPI.getWeatherByCity(city, units);
  }

  Future<Map<String, dynamic>> fetchWeatherForecast(String city, String units) async {
    return await _weatherAPI.getForecastByCity(city, units);
  }
}