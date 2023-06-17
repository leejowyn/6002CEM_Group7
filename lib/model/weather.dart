class Weather {
  final String name;
  final double latitude;
  final double longitude;
  final double temperatureC;
  final String condition;
  final String iconUrl;
  final int humidity;

  Weather({
    this.name = "",
    this.latitude = 0,
    this.longitude = 0,
    this.temperatureC = 0,
    this.condition = "Sunny",
    this.iconUrl = "//cdn.weatherapi.com/weather/64x64/day/116.png",
    this.humidity = 0,
  });
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      name: json['location']['name'],
      latitude: json['location']['lat'],
      longitude: json['location']['lon'],
      temperatureC: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
      iconUrl: json['current']['condition']['icon'],
      humidity: json['current']['humidity'],
    );
  }
}
