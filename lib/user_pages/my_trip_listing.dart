import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';
import 'package:trip_planner/widgets/my_trip_listing_item.dart';
import 'package:trip_planner/widgets/title.dart';

class MyTripListing extends StatefulWidget {
  static String routeName = '/myTripListing';
  const MyTripListing({Key? key}) : super(key: key);

  @override
  State<MyTripListing> createState() => _MyTripListingState();
}

class _MyTripListingState extends State<MyTripListing> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  getDestinationThumbnail(String destinationId) async {
    var ref = FirebaseDatabase.instance.ref();
    var snapshot =
        await ref.child('Destination/$destinationId/thumbnail').get();
    return snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          const TitleHeading(title: "My Trips"),
          Flexible(
            child: FirebaseAnimatedList(
                query: FirebaseDatabase.instance
                    .ref()
                    .child('Trip/${currentUser.uid}'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {

                  Map trip = snapshot.value as Map;
                  trip['key'] = snapshot.key;

                  // if user scheduled destination to this trip before, get the thumbnail of destination from first key
                  if (trip.containsKey('destination') &&
                      !trip['destination'].isEmpty) {
                    var destinationIdForThumbnail = trip['destination']
                        [trip['destination'].keys.first]['destination_id'];

                    return FutureBuilder<void>(
                        future:
                            getDestinationThumbnail(destinationIdForThumbnail),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot2) {
                          if (snapshot2.hasData) {
                            return MyTripListingItem(
                                trip: trip, thumbnail: snapshot2.data);
                          } else if (snapshot2.hasError) {
                            return AlertDialogError(
                                errDesc: snapshot2.error.toString());
                          } else {
                            return MyTripListingItem(trip: trip, thumbnail: '');
                          }
                        });
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
