import 'package:flutter/material.dart';
import 'package:trip_planner/model/weather.dart';
import 'package:trip_planner/service/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  Weather _weather = Weather();

  Weather get weather => _weather;

  Future<void> fetchWeather(String location) async {
    _weather = await _weatherService.getWeatherData(location);
    notifyListeners();
  }
}