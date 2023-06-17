import 'package:flutter/material.dart';
import 'package:trip_planner/model/destination_model.dart';
import 'package:trip_planner/service/destination_firebase_service.dart';

class DestinationViewModel extends ChangeNotifier {
  final DestinationFirebaseService _firebaseService = DestinationFirebaseService();
  DestinationModel? _destination;

  DestinationModel? get destination => _destination;

  Future<void> fetchDestination(String destinationId) async {
    _destination = await _firebaseService.getDestination(destinationId);
    notifyListeners();
  }
}
