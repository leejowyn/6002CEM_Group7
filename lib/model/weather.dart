class Weather {
  final String name;
  final double latitude;
  final double longitude;
  final double temperatureC;
  final String condition;
  final int humidity;

   Weather({
     this.name = "",
     this.latitude = 0,
     this.longitude = 0,
    this.temperatureC = 0,
    this.condition = "Sunny",
     this.humidity = 0,
});
   factory Weather.fromJson(Map<String,dynamic>json){
     return Weather(
     name: json['location']['name'],
     latitude: json['location']['lat'],
     longitude: json['location']['lon'],
     temperatureC: json['current']['temp_c'],
     condition: json['current']['condition']['text'],
       humidity: json['current']['humidity'],
     );
  }
}