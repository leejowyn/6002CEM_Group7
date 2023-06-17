import 'package:flutter/material.dart';
import 'package:trip_planner/model/timezone.dart';
import 'package:trip_planner/service/timezone_service.dart';

class TimezoneViewModel extends ChangeNotifier {
  final TimezoneService _timezoneService = TimezoneService();
  Timezone _timezone = Timezone();

  Timezone get timezone => _timezone;

  Future<void> fetchTimezone(String country) async {
    _timezone = await _timezoneService.getTimezoneData(country);
    notifyListeners();
  }
}