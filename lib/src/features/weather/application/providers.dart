import 'package:flutter/material.dart';

import '../data/api_exception.dart';
import '../data/weather_repository.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherRepository _weatherRepository;
  String _units = "metric"; // Default to metric
  bool _isLoading = false; // Loading state

  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? _forecastData;
  String? _errorMessage;
  String _city = "London"; // Initial city value

  Map<String, dynamic>? get weatherData => _weatherData;

  Map<String, dynamic>? get forecastData => _forecastData;

  String? get errorMessage => _errorMessage;

  String get units => _units;

  bool get isLoading => _isLoading; // Getter for loading state
  String get city => _city; // Getter for the current city

  WeatherProvider(this._weatherRepository) {
    // Fetch weather data for the initial city when the provider is first created
    fetchWeather(_city);
  }

  void toggleUnits() {
    _units = _units == "metric" ? "imperial" : "metric";
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchWeather(String city) async {
    try {
      setLoading(true); // Set loading state to true
      _city = city; // Update the current city
      _weatherData = await _weatherRepository.fetchCurrentWeather(city, _units);
      _forecastData =
          await _weatherRepository.fetchWeatherForecast(city, _units);
      _errorMessage = null;
    } catch (e) {
      if (e is InvalidApiKeyException) {
        _errorMessage = 'Invalid API Key. Please check your API key.';
      } else if (e is NoInternetConnectionException) {
        _errorMessage = 'No internet connection. Please try again later.';
      } else if (e is CityNotFoundException) {
        _errorMessage = 'City not found. Please enter a valid city name.';
      } else {
        _errorMessage = e.toString();
      }
      _weatherData = null;
      _forecastData = null;
    } finally {
      setLoading(false); // Set loading state to false
    }
    notifyListeners();
  }
}
