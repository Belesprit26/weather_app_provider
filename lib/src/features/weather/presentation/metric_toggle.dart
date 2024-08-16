import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../application/providers.dart';

class MetricToggle extends StatelessWidget {
  const MetricToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '°F',
          style: TextStyle(color: Colors.white),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Switch(
            key: ValueKey<bool>(weatherProvider.units == "metric"),
            value: weatherProvider.units == "metric",
            onChanged: (value) {
              weatherProvider.toggleUnits();

              // Trigger a reload of the weather data
              weatherProvider.fetchWeather(
                  weatherProvider.weatherData?['name'] ?? '');
            },
            activeTrackColor: Colors.lightBlueAccent,
            activeColor: Colors.blue,
          ),
        ),
        const Text(
          '°C',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}