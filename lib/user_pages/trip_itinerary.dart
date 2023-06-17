import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import 'package:trip_planner/user_pages/trip_form.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';
import 'package:trip_planner/widgets/itinerary_timeline_tile.dart';

class TripItinerary extends StatefulWidget {
  static String routeName = '/tripItinerary';
  const TripItinerary({Key? key}) : super(key: key);

  @override
  State<TripItinerary> createState() => _TripItineraryState();
}

class _TripItineraryState extends State<TripItinerary> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  getTripDetails(String tripId) async {
    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child('Trip/${currentUser.uid}/$tripId').get();
    return snapshot.value;
  }

  getDestinationDetail(String destinationId) async {
    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child('Destination/$destinationId').get();
    return snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    final String tripId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Itinerary"),
        ),
        body: Timeline(
            theme: TimelineThemeData(color: Theme.of(context).primaryColor),
            children: [
              FutureBuilder(
                  future: getTripDetails(tripId),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      Map trip = snapshot.data as Map;
                      trip['key'] = tripId;
                      List<Widget> itineraryList = <Widget>[];

                      // add trip name and trip note
                      itineraryList.add(
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        trip['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                        maxLines: 5,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                TripForm.routeName,
                                                arguments: trip,
                                              );
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Delete trip?'),
                                                      content: const Text(
                                                          'Are you sure you want to delete this trip?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(context, 'Cancel'),
                                                          child: const Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context, 'OK');

                                                            DatabaseReference dbRef =
                                                            FirebaseDatabase.instance.ref('Trip/${currentUser.uid}/$tripId');

                                                            // delete this trip
                                                            dbRef.remove().then((value) {
                                                              Navigator.pop(context); // close this deleted itinerary page
                                                            }).catchError((error) {
                                                              // show error message
                                                              showDialog<void>(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return AlertDialogError(errDesc: error.toString());
                                                                },
                                                              );
                                                            });

                                                          },
                                                          child: const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: const Icon(Icons.delete))
                                      ],
                                    ),

                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    trip['end_date'].isEmpty
                                        ? DateFormat("EEE, dd MMM yyyy").format(
                                            DateTime.parse(trip['start_date']))
                                        : DateFormat("EEE, dd MMM").format(
                                                DateTime.parse(
                                                    trip['start_date'])) +
                                            "  -  " +
                                            DateFormat("EEE, dd MMM yyyy")
                                                .format(DateTime.parse(
                                                    trip['end_date'])),
                                    style:
                                        TextStyle(color: Colors.grey.shade600)),
                                Divider(
                                  height: 40,
                                  color: Colors.grey.shade200,
                                ),
                                Text(
                                  trip['note'],
                                  style: TextStyle(color: Colors.grey.shade600),
                                  textAlign: TextAlign.justify,
                                )
                              ],
                            ),
                          ),
                        ),
                      );

                      if (trip.containsKey('destination') &&
                          !trip['destination'].isEmpty) {
                        List<Map<dynamic, dynamic>> trip_itinerary =
                            (trip['destination'] as Map<dynamic, dynamic>)
                                .values
                                .cast<Map<dynamic, dynamic>>()
                                .toList();

                        Set<dynamic> destinationKeys =
                            (trip['destination'] as Map<dynamic, dynamic>)
                                .keys
                                .toSet();

                        for (var i = 0; i < trip_itinerary.length; i++) {
                          trip_itinerary[i]['key'] =
                              destinationKeys.elementAt(i);
                        }

                        print(trip_itinerary);

                        trip_itinerary.sort((a, b) {
                          DateFormat format = DateFormat('yyyy-MM-dd hh:mm');
                          DateTime dateTimeA =
                              format.parse(a['date'] + " " + a['time']);
                          DateTime dateTimeB =
                              format.parse(b['date'] + " " + b['time']);
                          return dateTimeA.compareTo(dateTimeB);
                        });

                        String previousDate = "";

                        for (Map<dynamic, dynamic> itinerary
                            in trip_itinerary) {
                          if (itinerary['date'] != previousDate) {
                            // add new day
                            itineraryList.add(Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.08),
                                ),
                                child: Text(
                                  DateFormat("EEE, dd MMM yyyy").format(
                                      DateTime.parse(itinerary['date'])),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ));
                          }

                          // add list tile
                          itineraryList.add(FutureBuilder<void>(
                              future: getDestinationDetail(
                                  itinerary['destination_id']),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot2) {
                                if (snapshot2.hasData) {
                                  Map destination = snapshot2.data;
                                  return ItineraryTimelineTile(
                                      itinerary: itinerary,
                                      destination: destination,
                                      trip: trip);
                                } else if (snapshot2.hasError) {
                                  return AlertDialogError(
                                      errDesc: snapshot2.error.toString());
                                } else {
                                  return ItineraryTimelineTile(
                                      itinerary: itinerary, trip: trip);
                                }
                              }));

                          previousDate = itinerary['date'];
                        }
                      } else {
                        itineraryList.add(Column(
                          children: [
                            const SizedBox(height: 100),
                            Container(
                              width: 300,
                              child: Text(
                                "Your itinerary is currently empty. \n\nStart to schedule exciting activities to fill your journey with joy and unforgettable memories!",
                                style: TextStyle(
                                    color: Colors.grey.shade600, height: 2.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ));
                      }

                      return Column(children: itineraryList);
                    }
                    else if (snapshot.hasError) {
                      return AlertDialogError(
                          errDesc: snapshot.error.toString());
                    }
                    else {
                      return const CircularProgressIndicator();
                    }
                  })
            ]));
  }
}
