import 'package:firebase_database/firebase_database.dart';
import 'package:trip_planner/model/destination_model.dart';

class DestinationFirebaseService {
  final _databaseRef = FirebaseDatabase.instance.ref();

  Future<DestinationModel?> getDestination(String destinationId) async {
    DataSnapshot snapshot =
        await _databaseRef.child('Destination/$destinationId').get();

    if (snapshot.value == null) {
      return null;
    }

    Map<dynamic, dynamic> data = snapshot.value as Map;

    return DestinationModel(
      id: snapshot.key!,
      name: data['name'],
      description: data['description'],
      address: data['address'],
      category: data['category'],
      contact: data['contact'],
      country: data['country'],
      endTime: data['endTime'],
      startTime: data['startTime'],
      state: data['state'],
      thumbnail: data['thumbnail'],
    );
  }
}
