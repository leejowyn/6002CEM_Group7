import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:trip_planner/user_pages/destination_detail.dart';
import 'package:trip_planner/user_pages/trip_itinerary.dart';
import 'package:trip_planner/view_model/destination_view_model.dart';
import 'package:trip_planner/view_model/timezone_view_model.dart';
import 'package:trip_planner/view_model/weather_view_model.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';
import 'package:trip_planner/widgets/alert_dialog_schedule_form.dart';

class ItineraryTimelineTile extends StatefulWidget {
  final Map itinerary;
  final Map? destination;
  final Map trip;
  const ItineraryTimelineTile(
      {Key? key, required this.itinerary, this.destination, required this.trip})
      : super(key: key);

  @override
  State<ItineraryTimelineTile> createState() => _ItineraryTimelineTileState();
}

class _ItineraryTimelineTileState extends State<ItineraryTimelineTile> {

  final currentUser = FirebaseAuth.instance.currentUser!;

  getIcon(String category) {
    IconData iconData;

    switch (category) {
      case 'Natural':
        iconData = Icons.landscape;
        break;

      case 'Cultural':
        iconData = Icons.temple_buddhist;
        break;

      case 'Food and Drink':
        iconData = Icons.fastfood;
        break;

      case 'Shopping':
        iconData = Icons.shopping_bag;
        break;

      case 'Entertainment':
        iconData = Icons.celebration;
        break;

      case 'Wellness and Spa':
        iconData = Icons.spa;
        break;

      default:
        iconData = Icons.broken_image;
    }
    ;

    return iconData;
  }

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      nodePosition: 0.1,
      contents: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 20),
              child: Text(
                widget.itinerary['time'],
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            InkWell(
              onTap: () {
                if (widget.destination != null) {
                  DestinationViewModel destinationViewModel = Provider.of<DestinationViewModel>(context, listen: false);
                  destinationViewModel.fetchDestination(widget.itinerary!['destination_id']);

                  WeatherViewModel weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
                  weatherViewModel.fetchWeather('${widget.destination!['state']} ${widget.destination!['country']}');

                  TimezoneViewModel timezoneViewModel = Provider.of<TimezoneViewModel>(context, listen: false);
                  timezoneViewModel.fetchTimezone(widget.destination!['country']);

                  Navigator.of(context).pushNamed(
                    DestinationDetail.routeName,
                  );
                }
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, top: 15, right: 20, bottom: 15),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 30,
                            spreadRadius: -15,
                            offset: Offset(5, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: widget.destination == null
                            ? Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 35,
                                ),
                              )
                            : Image.network(
                                widget.destination!['thumbnail'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.destination == null
                              ? "Not found"
                              : widget.destination!['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, right: 30),
                          child: Text(
                            widget.destination == null
                                ? "This destination has been deleted"
                                : widget.destination!['address'],
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialogScheduleForm(
                                trip: widget.trip,
                                destinationId:
                                    widget.itinerary['destination_id'],
                                editKey: widget.itinerary['key'],
                              );
                            }).then((value) {
                          if (value == 'OK') {
                            // reload page
                            Navigator.pop(context);
                            Navigator.of(context).pushNamed(
                              TripItinerary.routeName,
                              arguments: widget.trip['key'],
                            );
                          }
                        });
                      } else if (value == 'delete') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete destination?'),
                                content: const Text(
                                    'Are you sure you want to delete this destination from your trip?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');

                                      DatabaseReference dbRef = FirebaseDatabase.instance
                                          .ref('Trip/${currentUser.uid}/${widget.trip["key"]}/destination/${widget.itinerary["key"]}');

                                      // delete this destination from this trip
                                      dbRef.remove().then((value) {
                                        // reload page
                                        Navigator.pop(context);
                                        Navigator.of(context).pushNamed(
                                          TripItinerary.routeName,
                                          arguments: widget.trip['key'],
                                        );
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
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      node: TimelineNode(
        indicatorPosition: 0.12,
        indicator: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor,
          ),
          width: 35,
          height: 35,
          child: Icon(
            widget.destination == null
                ? getIcon("")
                : getIcon(widget.destination!['category']),
            color: Colors.white,
            size: 18,
          ),
        ),
        startConnector: const SolidLineConnector(),
        endConnector: const SolidLineConnector(),
      ),
    );
  }
}
