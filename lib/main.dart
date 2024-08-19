import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:untitled/src/api/api_keys.dart'; // Assuming setupInjection() registers the API key
import 'package:untitled/src/features/weather/application/providers.dart';
import 'package:untitled/src/features/weather/data/weather_repository.dart'; // Import WeatherRepository

import 'src/features/weather/application/connectivity_provider.dart';
import 'src/features/weather/presentation/weather_page.dart';

void main() {
  setupInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyleWithShadow = TextStyle(color: Colors.white, shadows: [
      BoxShadow(
        color: Colors.black12.withOpacity(0.25),
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(0, 0.5),
      )
    ]);

    final apiKey = GetIt.instance<String>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(WeatherRepository(apiKey)),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider(), // Add the ConnectivityProvider
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          textTheme: TextTheme(
            displayLarge: textStyleWithShadow,
            displayMedium: textStyleWithShadow,
            displaySmall: textStyleWithShadow,
            headlineMedium: textStyleWithShadow,
            headlineSmall: textStyleWithShadow,
            titleMedium: const TextStyle(color: Colors.white),
            bodyMedium: const TextStyle(color: Colors.white),
            bodyLarge: const TextStyle(color: Colors.white),
            bodySmall: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        home: WeatherPage(),
      ),
    );
  }
}
