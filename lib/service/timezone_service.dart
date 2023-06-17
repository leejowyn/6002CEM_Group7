import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_planner/model/timezone.dart';

class TimezoneService {
  Future<Timezone> getTimezoneData(String country) async {
    try {
      const apiKey = "211115054cf14e76bb068ce0a10f3f02";
      final url =
          "https://timezone.abstractapi.com/v1/current_time/?api_key=$apiKey&location=$country";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return Timezone.fromJson(jsonDecode(response.body));
      } else {
        print(jsonDecode(response.body));
        throw Exception("Unable to get timezone");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
