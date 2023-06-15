import 'package:flutter/material.dart';
import 'package:trip_planner/weather_api/weather_service.dart';

import '../model/weather.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  WeatherService weatherService = WeatherService();
  Weather weather = Weather();
  String currentWeather = "";
  String currentCountry = "";
  double lat = 0;
  double lon = 0;
  double tempC = 0;
  int humidity = 0;

  @override
  void initState() {
    super.initState();
    getWeather();
  }
  void getWeather()async{
    weather = await weatherService.getWeatherData('Bukit Mertajam');
    setState(() {
      currentWeather = weather.condition;
      lat = weather.latitude;
      lon = weather.longitude;
      tempC = weather.temperatureC;
      humidity = weather.humidity;
      currentCountry = weather.name;
    });
    print(weather.name);
    print(weather.latitude);
    print(weather.longitude);
    print(weather.temperatureC);
    print(weather.humidity);
    print(weather.condition);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentCountry),
            Text(currentWeather),
            Text(lat.toString()),
            Text(lon.toString()),
            Text(tempC.toString()),
            Text(humidity.toString()),
    ],
        ),
      ),
    );
  }
}
