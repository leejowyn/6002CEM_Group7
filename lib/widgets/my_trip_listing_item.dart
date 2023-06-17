import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/user_pages/trip_itinerary.dart';

class MyTripListingItem extends StatelessWidget {
  final Map trip;
  final String thumbnail;
  const MyTripListingItem({Key? key, required this.trip, required this.thumbnail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          TripItinerary.routeName,
          arguments: trip['key'],
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: Row(
          children: [
            Container(
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
                child: thumbnail == ""
                    ? Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey,
                        child: const Icon(
                          Icons.airplane_ticket,
                          size: 35,
                        ),
                      )
                    : Image.network(
                        thumbnail,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                    trip['end_date'].isEmpty
                        ? DateFormat("EEE, dd MMM yyyy")
                            .format(DateTime.parse(trip['start_date']))
                        : DateFormat("EEE, dd MMM")
                                .format(DateTime.parse(trip['start_date'])) +
                            "  -  " +
                            DateFormat("EEE, dd MMM yyyy")
                                .format(DateTime.parse(trip['end_date'])),
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    );

    // return ListTile(
    //   leading: ClipRRect(
    //     borderRadius: BorderRadius.circular(15),
    //     child: thumbnail == ""
    //         ? Container(
    //             width: 100,
    //             height: 100,
    //             color: Colors.grey,
    //             child: Icon(Icons.airplane_ticket),
    //           )
    //         : Image.network(
    //             thumbnail,
    //             width: 100,
    //             height: 100,
    //             fit: BoxFit.cover,
    //           ),
    //   ),
    //   title: Text(trip['name']),
    //   subtitle: trip['end_date'].isEmpty
    //       ? Text(DateFormat("EEE, dd MMM yyyy").format(DateTime.parse(trip['start_date'])))
    //       : Text(DateFormat("EEE, dd MMM").format(DateTime.parse(trip['start_date'])) + "  -  " + DateFormat("EEE, dd MMM yyyy").format(DateTime.parse(trip['end_date']))),
    // );
  }
}
