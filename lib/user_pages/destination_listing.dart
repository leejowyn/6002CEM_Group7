import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/user_pages/my_trip_listing.dart';
import 'package:trip_planner/widgets/destination_card.dart';

class DestinationListing extends StatefulWidget {
  static String routeName = '/destinationListing';
  final String? keyword;
  final String? country;
  const DestinationListing({Key? key, this.keyword, this.country})
      : super(key: key);

  @override
  State<DestinationListing> createState() => _DestinationListingState();
}

class _DestinationListingState extends State<DestinationListing> {
  getAverageRating(String destinationId) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    final event = await databaseReference
        .child('Destination')
        .child(destinationId)
        .child('review')
        .once();

    double totalRating = 0;
    int reviewCount = 0;

    if (event.snapshot.value != null) {
      Map reviews = event.snapshot.value as Map;

      reviews.forEach((reviewId, reviewData) {
        final rating = double.parse(reviewData['rating']);

        totalRating += rating;
        reviewCount++;
      });
    }

    if (reviewCount > 0) {
      return totalRating / reviewCount;
    } else {
      return 0.0; // No reviews found, return default rating
    }
  }

  @override
  Widget build(BuildContext context) {
    String? categoryName =
        ModalRoute.of(context)!.settings.arguments as String?;

    Query dbRef = FirebaseDatabase.instance.ref().child('Destination');

    if (categoryName != null) {
      dbRef = FirebaseDatabase.instance
          .ref()
          .child('Destination')
          .orderByChild('category')
          .equalTo(categoryName);
      // dbRef = dbRef.orderByChild('category').equalTo(categoryName);
    } else if (widget.country != null) {
      dbRef = FirebaseDatabase.instance
          .ref()
          .child('Destination')
          .orderByChild('country')
          .equalTo(widget.country);
      // dbRef = dbRef.orderByChild('country').equalTo(widget.country);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          categoryName == null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(left: 45, top: 60, bottom: 30),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Category: $categoryName",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25))),
                ),
          Flexible(
            child: FirebaseAnimatedList(
                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                key: Key(DateTime.now().toString()),
                query: dbRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map destination = snapshot.value as Map;
                  destination['key'] = snapshot.key;

                  return FutureBuilder(
                      future: getAverageRating(destination['key']),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        destination['avg_rating'] = snapshot.data.toString();

                        bool filter = false;

                        // filter state
                        // if (widget.state != null && destination['state'] != widget.state) {
                        //   filter = true;
                        // }

                        // filter search keyword
                        if (widget.keyword != null) {
                          if ((destination['name'].toLowerCase())
                                  .contains(widget.keyword) ==
                              false) filter = true;
                        }

                        if (!filter) {
                          return DestinationCard(destination: destination);
                        } else {
                          return const SizedBox();
                        }
                      });
                }),
          ),
        ],
      ),
    );
  }
}
