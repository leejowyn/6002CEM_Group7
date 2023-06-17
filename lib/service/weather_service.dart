import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/model/weather.dart';

class WeatherService {
  Future<Weather> getWeatherData(String place) async{
    try{
      final queryParameters = {
        'key':'0a3dee26538143eabb660728231406',
        'q' : place,
      };
      final uri = Uri.http('api.weatherapi.com','/v1/current.json',queryParameters);
      final response = await http.get(uri);
      if(response.statusCode ==200){
        return Weather.fromJson(jsonDecode(response.body));
      }else{
        throw Exception("Unable to get weather");
      }
    }catch(e){
      rethrow;
    }
  }
}