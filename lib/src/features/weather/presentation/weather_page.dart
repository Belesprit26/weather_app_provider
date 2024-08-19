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

String getDayWithSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return '${day}th';
  }
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }
}

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);

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
                  Spacer(),
                  if (weatherProvider.weatherData != null) ...[
                    const CurrentWeather(),
                    Spacer(),
                    // Forecast section
                    Text('Weather Forecast:',
                        style: TextStyle(fontSize: 20, color: Colors.white60)),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        border: Border.all(color: Colors.black26),
                      ),
                      height: 390,
                      child: ListView.builder(
                        itemCount: weatherProvider.forecastData!['list'].length,
                        itemBuilder: (context, index) {
                          var forecast =
                              weatherProvider.forecastData!['list'][index];

                          DateTime dateTime =
                              DateTime.parse(forecast['dt_txt']);
                          String dayOfWeek =
                              DateFormat('EEEE').format(dateTime);
                          String dayWithSuffix = getDayWithSuffix(dateTime.day);
                          String formattedTime = DateFormat('h:mma')
                              .format(dateTime)
                              .toLowerCase();

                          return ListTile(
                            leading: WeatherIconImage(
                              iconUrl:
                                  'https://openweathermap.org/img/wn/${forecast['weather'][0]['icon']}@2x.png',
                              size: 60,
                            ),
                            title: Text(
                              '$dayOfWeek $dayWithSuffix',
                              style: TextStyle(color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              '$formattedTime',
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Text(
                              '${forecast['main']['temp']}°${weatherProvider.units == "metric" ? "C" : "F"}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    ),
                  ] else if (weatherProvider.errorMessage != null) ...[
                    Text(
                      'Error: ${weatherProvider.errorMessage}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ] else if (weatherProvider.weatherData == null &&
                      weatherProvider.forecastData == null) ...[
                    Text('Search for a city',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ] else ...[
                    CircularProgressIndicator(),
                  ],
                  Spacer(),
                  const MetricToggle(),
                ],
              ),
            ),
          ),
          if (!connectivityProvider.hasConnection)
            Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: Text(
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
              child: Center(
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
