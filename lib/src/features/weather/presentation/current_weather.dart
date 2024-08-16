import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../application/providers.dart';
import 'weather_icon_image.dart'; // Import the WeatherIconImage widget

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WeatherProvider, (String city, Map<String, dynamic>? weatherData)>(
      selector: (context, provider) => (provider.weatherData!['name'], provider.weatherData),
      builder: (context, data, _) {
        if (data.$2 == null) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.accentColor,
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              data.$1,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white70),
            ),

            CurrentWeatherContents(data: data.$2!),
          ],
        );
      },
    );
  }
}

class CurrentWeatherContents extends StatelessWidget {
  const CurrentWeatherContents({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data['main']['temp'].toInt().toString();
    final minTemp = data['main']['temp_min'].toInt().toString();
    final maxTemp = data['main']['temp_max'].toInt().toString();
    final highAndLow = 'H:$maxTemp° L:$minTemp°';
    final iconUrl = 'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeatherIconImage(iconUrl: iconUrl, size: 120),
        Text('$temp°', style: textTheme.displayMedium?.copyWith(color: Colors.white)),
        Text(highAndLow, style: textTheme.bodyMedium?.copyWith(color: Colors.white60)),
      ],
    );
  }
}
