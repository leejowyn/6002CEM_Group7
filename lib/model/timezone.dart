class Timezone {
  final String timeLocation;
  final String timezone;
  final String gmt;

  Timezone({this.timeLocation = "", this.timezone = "", this.gmt = ""});

  factory Timezone.fromJson(Map<String, dynamic> json) {
    return Timezone(
      timeLocation: json['timezone_location'],
      timezone: json['datetime'],
      gmt: json['gmt_offset'].toString(),
    );
  }
}
