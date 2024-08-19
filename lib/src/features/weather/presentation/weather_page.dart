import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../application/connectivity_provider.dart';
import '../application/providers.dart';
import 'city_search_box.dart';
import 'current_weather.dart';
import 'metric_toggle.dart';
import 'weather_icon_image.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);

    // Group forecasts by day and get the forecast at midday
    Map<String, Map<String, dynamic>> groupedForecasts = {};

    if (weatherProvider.forecastData != null) {
      for (var forecast in weatherProvider.forecastData!['list']) {
        DateTime dateTime = DateTime.parse(forecast['dt_txt']);
        String dayKey = DateFormat('yyyy-MM-dd').format(dateTime);

        // Identify forecasts closest to midday (12:00 PM)
        if (dateTime.hour == 12) {
          groupedForecasts[dayKey] = {
            'day': DateFormat('EEE').format(dateTime),
            'icon': forecast['weather'][0]['icon'],
            'temp': forecast['main']['temp'],
          };
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.rainGradient,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CitySearchBox(),
                  const Spacer(),
                  if (weatherProvider.weatherData != null) ...[
                    const CurrentWeather(),
                    const Spacer(),
                    // Forecast section
                    Text(
                      'Weather Midday Forecast:',
                      style: TextStyle(fontSize: 20, color: Colors.white60),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        groupedForecasts.keys.length,
                        (index) {
                          String dayKey =
                              groupedForecasts.keys.elementAt(index);
                          var dayData = groupedForecasts[dayKey]!;
                          String dayOfWeek = dayData['day'];
                          String iconUrl =
                              'https://openweathermap.org/img/wn/${dayData['icon']}@2x.png';
                          double middayTemp = dayData['temp'];

                          return Expanded(
                            child: Column(
                              children: [
                                Text(
                                  dayOfWeek,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 5),
                                WeatherIconImage(
                                  iconUrl: iconUrl,
                                  size: 40,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${middayTemp.toStringAsFixed(0)}°',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ] else if (weatherProvider.errorMessage != null) ...[
                    Text(
                      'Error: ${weatherProvider.errorMessage}',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ] else if (weatherProvider.weatherData == null &&
                      weatherProvider.forecastData == null) ...[
                    const Text(
                      'Search for a city',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ] else ...[
                    const CircularProgressIndicator(),
                  ],
                  const Spacer(),
                  const MetricToggle(),
                ],
              ),
            ),
          ),
          if (!connectivityProvider.hasConnection)
            Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: const Text(
                "No internet connection!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (weatherProvider.isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
